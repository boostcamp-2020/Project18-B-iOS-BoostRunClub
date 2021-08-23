//
//  DefaultsProviderMock.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/20.
//

import Foundation

class DefaultsProviderMock: DefaultsReadable, DefaultsWritable {
    func set(_: Any?, forKey _: String) {}

    func string(forKey _: String) -> String? {
        return ""
    }
}
