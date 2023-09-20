//
//  ContentView.swift
//  LotteryApp
//
//  Created by JunHo Park on 2023/07/31.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var batteryHelper = HomeViewModel()
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
            // Text("\(batteryHelper.correctItems)")
            if batteryHelper.selectedItems.count > 0 {
                ForEach(Array(batteryHelper.selectedItems.keys).sorted(by: <), id: \.self) { itemKey in
                    if let value = batteryHelper.selectedItems[itemKey] {
                        let str = value.map(String.init).joined(separator: " ")
                        
                        Text("\(str)")
                    }
                }
            }
            /*
            CHECKER : [4, 6, 8, 10, 11, 14, 17, 23, 30, 34, 35, 36, 38, 40, 43]
             ["C": [7, 16, 25, 28, 37, 20], "D": [5, 9, 15, 19, 31, 42], "A": [1, 12, 27, 32, 45, 3], "E": [2, 13, 21, 33, 39, 41], "B": [18, 22, 26, 29, 44, 24]]
            CHECKER 2 : [4, 6, 8, 10, 11, 14, 17, 23, 30, 34, 35, 36, 38, 40, 43]
             ["C": [7, 16, 25, 28, 37, 20], "D": [5, 9, 15, 19, 31, 42], "A": [1, 12, 27, 32, 45, 3], "E": [2, 13, 21, 33, 39, 41], "B": [18, 22, 26, 29, 44, 24]]

            */
            Button {
                batteryHelper.readItems()
                batteryHelper.setRandomItem()
            } label: {
                Text("READ ITEM")
            }

        }
        .padding()
        .onAppear {
            // batteryHelper.readItems()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
