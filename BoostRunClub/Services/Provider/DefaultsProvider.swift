//
//  DefaultsProvider.swift
//  BoostRunClub
//
//  Created by Imho Jang on 2020/12/11.
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

class DefaultsProvider: DefaultsWritable, DefaultsReadable {
    var defaults = UserDefaults.standard

    func set(_ value: Any?, forKey: String) {
        defaults.set(value, forKey: forKey)
    }

    func string(forKey: String) -> String? {
        defaults.string(forKey: forKey)
    }
}

extension DefaultsProvider: DefaultsManagable {
    var reader: DefaultsReadable { self }
    var writer: DefaultsWritable { self }
}
