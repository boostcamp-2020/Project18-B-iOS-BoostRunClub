//
//  CaseIterable+.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/11/27.
//

import Foundation

extension CaseIterable where Self: Equatable, AllCases: BidirectionalCollection {
    func next() -> Self? {
        let all = Self.allCases
        let idx = all.firstIndex(of: self)!
        let next = all.index(after: idx)
        return next == all.endIndex ? nil : all[next]
    }

    func circularNext() -> Self {
        return next() ?? Self.allCases.first!
    }

    func prev() -> Self? {
        let all = Self.allCases
        let idx = all.firstIndex(of: self)!
        return idx == all.startIndex ? nil : all[all.index(before: idx)]
    }
}
