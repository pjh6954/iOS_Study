import UIKit

func ChickenBreastAmountCalculation(_ myWeight: Float, proteinGram: Float = 25) {
    // 적정 프로틴 섭취량은 내 몸무게의 1배에서 2배를 섭취해야 한다.
    let maxAdequateProtein: Float = myWeight * 2
    let minAdequateProtein: Float = myWeight
    
    let forMaxProtein = (maxAdequateProtein / proteinGram)
    let forMinProtein = (minAdequateProtein / proteinGram)
    
    print("최대 섭취량 : \(maxAdequateProtein), 최소 섭취량 : \(minAdequateProtein), 1회 제공량의 단백질 함량 \(proteinGram)g 일 때 최대 \(forMaxProtein)개에서 최소 \(forMinProtein)개 섭취해야 함.")
}

ChickenBreastAmountCalculation(90, proteinGram: 15)

/*
 1.
 Have the function StringChallenge (str) insert dashes (-) between each two odd numbers in str. For example: if str is 454793 the output should be 4547-9-3. Don't count zero as an odd number.
 */

let stringChallengeValues : [String] = [
    "454793", // 4547-9-3
    "56730",
    "07337054"
]
func StringChallenge(_ str: String) -> String {
    // code goes here
    // Note: feel free to modify the return type of this function
    var resultStr = ""
    var isBeforeOdd: Bool = false
    for element in str {
        guard let newValue = Int(String(element)) else { continue }
        if newValue % 2 == 1 {
            // odd 홀수
            if isBeforeOdd {
                resultStr += "-"
            }
            isBeforeOdd = true
        } else {
            isBeforeOdd = false
        }
        resultStr += "\(newValue)"
        
    }
    return resultStr
}

// keep this function call here
for element in stringChallengeValues {
    print(StringChallenge(element))
}

/*
 2.
 Have the function Stringchallenge (str) take the str parameter being passed, which will contain only the characters (* and "), and determine the minimum number of brackets that need to be removed to create a string of correctly matched brackets. For example: if str is '(0))" then your program should return the number 1. The answer could potentially be 0, and there will always be at least one set of matching brackets in the string.
 */
/*
let stringChallengeValues : [String] = [
    "(()()((()())))",
    ")((())()))))(((((()",
    "((((())))(()()))",
    "((((())))(()())))",
    ")))(((" // 이 경우 카운트는 0으로 가능하지만, 시작이 ")"괄호라서 닫히지 않음. 따라서 false가 나와야 한다.
]
func StringChallenge(_ str: String) -> String {
    // code goes here
    // Note: feel free to modify the return type of this function
    var result = true
    var count = 0 // 괄호 갯수 카운트. 시작은 +1, 닫음은 -1
    for element in str {
        if element == "(" { // 시작 괄호
            count += 1
        } else if count <= 0 && element == ")" { // ")" 부터 시작하는 경우 반복문을 종료하고 false를 반환해준다 <- 이 부분이 가장 중요.
            result = false
            break
        } else { // ")"의 경우 "(" 와 짝지어서 카운트에 -1 진행
            count -= 1
        }
    }
    return count == 0 && result ? "true" : "false"
}

// keep this function call here
for element in stringChallengeValues {
    print(StringChallenge(element))
}
*/

/*
 3.
 Have the function StringChallenge (str) take the str parameter being passed and determine if it passes as a valid password that follows the list of constraints:
 1. It must have a capital letter.
 2. It must contain at least one number
 3. it must contain a punctuation mark or mathematical symbol
 4. It cannot have the word "password" in the string.
 5. It must be longer than 7 characters and shorter than 31 characters.
 if all the above constraints are met within the string, the your program should return the string true, otherwise your program should return the string false. For example: if str is "apple!M7* then your program should return "true'
 */
/*
let stringChallengeValues : [String] = [
    "apple!M7*",
    "pAssWord17!.",
    "passW17!.",
    "nothankS2!=",
    "tesT!6789012345678901234567890", // 30
    "tesT!67890123456789012345678901", // 31
    "tesT!6",
    "tesT!67"
]

func StringChallenge(_ str: String) -> String {
    // code goes here
    // Note: feel free to modify the return type of this function
    // 소문자, 대문자, 숫자, 특문 포함된 경우 true, 7 ~ 30 글자 갯수, 조합에서는 소문자는 필수가 아님. 필수로 넣고 싶다면 (?=.*[a-z]) 추가
    guard str.range(of: "^(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*#?&.])[a-zA-Z\\d$@$!%*#?&.]{7,30}$", options: .regularExpression) != nil else {
        return "false"
    }
    // Password 단어(대소문자 구분 없이)가 없는 경우 true
    guard str.range(of: "((?i)password)", options: .regularExpression) == nil else {
        return "false"
    }
    return "true"
}
// keep this function call here
for element in stringChallengeValues {
    print(StringChallenge(element))
}
*/

/*
 4.
 Array Challenge
 Have the function ArrayChallenge (arr) take the array of numbers stored in arr and return the string true if any combination of numbers in the array (excluding the largest number) can be added up to equal the largest number in the array, otherwise return the string false. For example: if arr contains (4, 6, 23, 10, 1, 3] the output should return true because
 4 + 6 + 10 + 3 = 23. The array will not be empty, will not contain
 all the same elements, and may contain negative numbers.
 
 */
/*
let arrayChallengeValues: [[Int]] = [
    [5, 7, 16, 1, 2],
    [3, 5, -1, 8, 12],
    [-5, -7, -10, -3, 2, 3],
    [13, 4, 9, 10, -5, -1],
    []
]

func ArrayChallenge(_ arr: [Int], isCombi2: Bool = false) -> String {
    // code goes here
    // Note: feel free to modify the return type of this function
    guard arr.count > 0 else { return "false" }
    var tempArr = arr.sorted(by: >) // O(n)
    let max = tempArr.removeFirst()
    var returnValue: Bool = false
    print("\(tempArr) :: \(max)")
    
    func combi(_ nowArr: [Int], index: Int) {
        //print("Start : \(tempArr.count), \(index)")
        guard !returnValue && index < tempArr.count else {
            return
        }
        var combiArr = nowArr
        combiArr.append(tempArr[index])
        print("NOW ARRAY : \(combiArr), add : \(combiArr.reduce(0, +))")
        if combiArr.reduce(0, +) == max {
            print("TRUE!")
            returnValue = true
        } else {
            combi(combiArr, index: index + 1)
            combi(nowArr, index: index + 1)
        }
    }
    
    print("BREAKER +++++++++++++++++++++++++++")
    func combi2(_ nowValue: Int, index: Int) {
        guard !returnValue && index < tempArr.count else {
            return
        }
        let addedValue = nowValue + tempArr[index]
        print("CHECK ADDED VALUE : \(addedValue), index : \(index)")
        if addedValue == max {
            print("TRUE!")
            returnValue = true
        } else {
            combi2(addedValue, index: index + 1)
            combi2(nowValue, index: index + 1)
        }
    }
    if !isCombi2 {
        combi([], index: 0)
    } else {
        combi2(0, index: 0)
    }
    
    return returnValue ? "true" : "false"
}

// keep this function call here
for element in arrayChallengeValues {
    print(ArrayChallenge(element))
    print(ArrayChallenge(element, isCombi2: true))
    print("BREAKER -------------------------------------------")
}

func arrayChecker(_ arr: [Int]) -> Bool {
    guard arr.count >= 3 else { return false }
    var tempArr = arr.sorted(by: >) // O(n)
    let max = tempArr.removeFirst() // tempArr는 여기서 최대값이 제외된 배열이 된다.
    // let thirdBigNum = tempArr[1] // 최대값을 제외한 나머지 값이 내림차순으로 정렬되어 있기 때문에 1번 인덱스 값이 기존 arr의 3번째로 큰 값이 된다.
    // let maxMinusThird = max - tempArr[1] // 최대값 - 세번째로 큰 값
    let maxMinusThird = Int(max / tempArr[1]) // 최대값 / 세번째로 큰 값
    print("max : \(max) :: \(maxMinusThird)")
    var combiFirstResult: Bool = false
    var combiSecondResult: Bool = false
    // 배열을 사용해서 값 계산
    func combi(_ nowArr: [Int], index: Int, isMax: Bool) {
        guard !(isMax ? combiFirstResult : combiSecondResult) && index < tempArr.count else {
            return
        }
        var combiArr = nowArr
        combiArr.append(tempArr[index])
        print("NOW ARRAY : \(combiArr), add : \(combiArr.reduce(0, +))")
        if combiArr.reduce(0, +) == (isMax ? max : maxMinusThird) {
            print("TRUE!")
            if isMax {
                combiFirstResult = true
            } else {
                combiSecondResult = true
            }
        } else {
            combi(combiArr, index: index + 1, isMax: isMax)
            combi(nowArr, index: index + 1, isMax: isMax)
        }
    }
    // 배열 사용 안하고 값으로 바로 계산
    func combiSecond(_ nowValue: Int, index: Int, isMax: Bool) {
        guard !(isMax ? combiFirstResult : combiSecondResult) && index < tempArr.count else {
            return
        }
        let addedValue = nowValue + tempArr[index]
        print("CHECK ADDED VALUE : \(addedValue), index : \(index)")
        if addedValue == (isMax ? max : maxMinusThird) {
            print("TRUE! :: \(addedValue)")
            if isMax {
                combiFirstResult = true
            } else {
                combiSecondResult = true
            }
        } else {
            combiSecond(addedValue, index: index + 1, isMax: isMax)
            combiSecond(nowValue, index: index + 1, isMax: isMax)
        }
    }
//    combi([], index: 0, isMax: true)
//    combi([], index: 0, isMax: false)
    
    combiSecond(0, index: 0, isMax: true)
    combiSecond(0, index: 0, isMax: false)
    return combiFirstResult && combiSecondResult
}

for element in arrayChallengeValues {
    print(arrayChecker(element))
    print("BREAKER -------------------------------------------")
}

*/
