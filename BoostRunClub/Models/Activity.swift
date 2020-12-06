//
//  Activity.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/06.
//

import Foundation

public class Activity: NSObject, NSSecureCoding {
    public static var supportsSecureCoding: Bool = true

    public func encode(with coder: NSCoder) {
        coder.encode(distance, forKey: "distance")
    }

    public required init?(coder: NSCoder) {
        guard
            let distance = coder.decodeObject(of: [NSObject.self], forKey: "distance")
        else {
            return nil
        }
        self.distance = 001_010
    }

    override init() {}

    var distance: Double = 0
}

class ActivityAttributeTransformer: NSSecureUnarchiveFromDataTransformer {
    override static var allowedTopLevelClasses: [AnyClass] {
        [Activity.self]
    }

    static func register() {
        let className = String(describing: ActivityAttributeTransformer.self)
        // the key to the ValueTransformer
        let name = NSValueTransformerName(className)
        // the value to the ValueTransformer
        let transformer = ActivityAttributeTransformer()
        ValueTransformer.setValueTransformer(transformer, forName: name)
    }
}
