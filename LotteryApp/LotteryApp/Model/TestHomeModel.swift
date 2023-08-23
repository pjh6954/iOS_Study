//
//  TestHomeModel.swift
//  LotteryApp
//
//  Created by JunHo Park on 2023/07/31.
//

import Foundation

struct LotteryTotalValues {
    static let lotto: [Int] = [
        1,2,3,4,5,6,7,8,9,10,
        11,12,13,14,15,16,17,18,19,20,
        21,22,23,24,25,26,27,28,29,30,
        31,32,33,34,35,36,37,38,39,40,
        41,42,43,44,45
    ]
}

struct TestModel {
    // 기존 item
    var items : [String]
    
    init(items: [String] = []) {
        self.items = items
    }
}

struct LotteryModel {
    var correctNumbers: [Int] = []
    var selectedNumbers: [String: [Int]] = [:]
    
    mutating func insertLotteryItem(_ value: String) {
        var key: String = ""
        var dictValue: [Int] = []
        for (index, element) in value.split(separator: "|").enumerated() {
            if index == 0, !element.isEmpty {
                key = String(element)
            }
            if index == 1, !key.isEmpty, !element.isEmpty {
                for intStrValue in String(element).split(separator: " ") {
                    guard let intValue = Int(String(intStrValue)) else {
                        break
                    }
                    dictValue.append(intValue)
                }
            }
        }
        // print(" KEyy : \(key), value : \(dictValue.count) || \(dictValue)")
        if !key.isEmpty, !dictValue.isEmpty, dictValue.count == 6 {
            self.selectedNumbers[key] = dictValue
        } else if key.lowercased().elementsEqual("bo"), dictValue.count == 7 {
            correctNumbers = dictValue
        }
    }
}
