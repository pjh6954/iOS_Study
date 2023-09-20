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
    var selectedItems: [String: [Int]] { return self.testHomeModel.selectedNumbers }
    
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
        // 남은 Lotto 번호 확인을 위한 변수
        var lottoRemainValue = LotteryTotalValues.lotto
        // 실제 당첨 번호
        let correctValues = self.testHomeModel.correctNumbers
        // 선택했던 번호들
        var selectedValues = self.testHomeModel.selectedNumbers
        print("selectedValues  : \(selectedValues)")
        for element in selectedValues {
            var temp = element.value
            for (index, value) in element.value.enumerated().reversed() {
                // 선택했던 번호가 당첨번호가 같은지 체크. 같으면 해당 번호의 인덱스를 이용해서 제거
                if correctValues.contains(value) {
                    temp.remove(at: index)
                }
                // 선택 번호 중 이 번호는 제거
                lottoRemainValue.removeAll { remainValue in
                    return remainValue == value
                }
            }
            print("TEMP : \(temp)")
            // 이전 당첨 번호를 제거한 값들을 다시 선택했던 번호들 리스트에 저장
            selectedValues[element.key] = temp
        }
        
        print("CHECKER : \(lottoRemainValue)\n \(selectedValues)")
        var isBreak = false
        
        while !isBreak {
            var isAllComp = true
            var tempSelectedValue = selectedValues
            for element in selectedValues {
                guard element.value.count < 6 else {
                    // 6개 또는 그 이상이면 어쨋든 모두 선택된 것이므로 넘어감.
                    continue
                }
                // MARK - past command line
                isAllComp = false
                // 남은 로또 선택 번호 중 랜덤 선택
                guard let randomValue = lottoRemainValue.randomElement() else {
                    continue
                }
                var tempValue = element.value
                // 남은 값 중 randomValue값은 삭제
                lottoRemainValue.removeAll(where: {$0 == randomValue})
                tempValue.append(randomValue)
                // print("TEmpValue : \(tempValue)")
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
