//
//  Swift+Extension.swift
//  LotteryApp
//
//  Created by JunHo Park on 2023/07/31.
//

import Foundation

extension String {
    
    var localizedString: String {
        return NSLocalizedString(self, comment: "")
    }
    
    var trimmed: String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    
    func replace(_ target: String, withString: String) -> String {
        return self.replacingOccurrences(of: target, with: withString)
    }
}
