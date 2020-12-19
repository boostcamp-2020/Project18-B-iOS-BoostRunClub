//
//  DefaultsProvider.swift
//  BoostRunClub
//
//  Created by Imho Jang on 2020/12/11.
//

import Foundation

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
