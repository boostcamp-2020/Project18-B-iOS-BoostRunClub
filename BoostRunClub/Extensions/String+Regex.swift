//
//  String+Regex.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/11/26.
//

import Foundation

extension String {
    enum RegexPattern {
        case distance, time
        var patternString: String {
            switch self {
            case .distance:
                return "^([0-9]{0,2}(\\.[0-9]{0,2})?|\\.?\\[0-9]{1,2})$"
            case .time:
                return ""
            }
        }
    }

    static func ~= (lhs: String, rhs: String) -> Bool {
        guard let regex = try? NSRegularExpression(pattern: rhs) else { return false }
        let range = NSRange(location: 0, length: lhs.utf16.count)
        return regex.firstMatch(in: lhs, options: [], range: range) != nil
    }
}
