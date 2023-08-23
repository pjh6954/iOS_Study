//
//  HomeViewModel.swift
//  LotteryApp
//
//  Created by JunHo Park on 2023/07/31.
//

import Foundation

class HomeViewModel: ObservableObject {
    @Published private var testHomeModel = LotteryModel()
    
    var correctItems: [Int] { return self.testHomeModel.correctNumbers }
    
    func readItems() {
        if let fileUrl = Bundle.main.url(forResource: "lotteryData", withExtension: "txt") {
            do {
                var tempText = try String.init(contentsOf: fileUrl, encoding: .utf8)
                // text = text.replace("'", withString: "\"")
                // text = "[\(text.replace("\n", withString: ","))]"
                var text: String = ""
                var beforeSlash : Bool = false
                var beforeStar : Bool = false
                var isMarkdownStarted: Bool = false
                for element in tempText {
                    
                    if element == "/", !beforeSlash {
                        beforeSlash = true
                    } else {
                        if element == "*", beforeSlash {
                            isMarkdownStarted = true
                        } else {
                            beforeSlash = false
                        }
                    }
                    guard isMarkdownStarted else {
                        text += String(element)
                        continue
                    }
                    if element == "*", !beforeStar {
                        beforeStar = true
                    } else {
                        if element == "/", beforeStar {
                            isMarkdownStarted = false
                        } else {
                            beforeStar = false
                        }
                    }
                }
                print("Txt : \(text)")
                text = text.replace("\n", withString: ",")
                text = text.replace("/", withString: "")
                print("Txt2 : \(text)")
                var lotteryModel = LotteryModel()
                for element in text.split(separator: ",") {
                    print("tesxt : 3 : \(element)")
                    lotteryModel.insertLotteryItem(String(element))
                }
                print("Lottery Model : \(lotteryModel.correctNumbers), \(lotteryModel.selectedNumbers)")
                self.testHomeModel = lotteryModel
            } catch {
                // handle error
                print("handle error")
            }
        }
    }
    
    func setRandomItem() {
        // LotteryTotalValues.lotto
        var lottoRemainValue = LotteryTotalValues.lotto
        let correctValues = self.testHomeModel.correctNumbers
        var selectedValues = self.testHomeModel.selectedNumbers
        for element in selectedValues {
            var temp = element.value
            for (index, value) in element.value.enumerated().reversed() {
                if correctValues.contains(value) {
                    temp.remove(at: index)
                }
                lottoRemainValue.removeAll { remainValue in
                    return remainValue == value
                }
            }
            print("TEMP : \(temp)")
            selectedValues[element.key] = temp
        }
        
        print("CHECKER : \(lottoRemainValue)\n \(selectedValues)")
        var isBreak = false
        
        while !isBreak {
            var isAllComp = true
            var tempSelectedValue = selectedValues
            for element in selectedValues {
                guard element.value.count < 6 else {
                    continue
                }
                // MARK - past command line
                isAllComp = false
                guard let randomValue = lottoRemainValue.randomElement() else {
                    continue
                }
                var tempValue = element.value
                lottoRemainValue.removeAll(where: {$0 == randomValue})
                tempValue.append(randomValue)
                print("TEmpValue : \(tempValue)")
                selectedValues[element.key] = tempValue
            }
            
            if isAllComp {
                isBreak = true
            }
        }
        print("CHECKER 2 : \(lottoRemainValue)\n \(selectedValues)")
        
        self.testHomeModel.selectedNumbers = selectedValues
    }
}
