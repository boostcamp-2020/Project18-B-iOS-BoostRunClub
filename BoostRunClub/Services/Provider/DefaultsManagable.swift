//
//  DefaultsManagable.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/20.
//

import Foundation

protocol DefaultsWritable {
    func set(_ value: Any?, forKey: String)
}

protocol DefaultsReadable {
    func string(forKey: String) -> String?
}

protocol DefaultsManagable {
    var reader: DefaultsReadable { get }
    var writer: DefaultsWritable { get }
}
