//
//  staticConfigurationWidget.swift
//  staticConfigurationWidget
//
//  Created by JunHo Park on 2023/05/16.
//

import WidgetKit
import SwiftUI
import Intents

/// TimelineProvider를 준수하고 위젯을 렌더링 할 때 WidgetKit에 알려주는 타임라인을 생성하는 개체
struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }
    /**
     Content Closure : WidgetKit은 Content Closure 호출하여 위젯의 콘텐츠를 렌더링하고 공급자로부터 TimelineEntry 개개변수를 전달합니다.
     */
    /// Content Closure
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }
    /// Content Closure
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

/// 넘어온 것들로 View를 구성할 수 있는 것
struct staticConfigurationWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        Text(entry.date, style: .time)
    }
}

struct staticConfigurationWidget: Widget {
    /// 위젯 식별 문자열
    let kind: String = "staticConfigurationWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            staticConfigurationWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct staticConfigurationWidget_Previews: PreviewProvider {
    static var previews: some View {
        staticConfigurationWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
