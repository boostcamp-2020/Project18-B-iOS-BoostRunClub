//
//  ServiceProvider.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/01.
//

import Foundation

protocol ServiceProvidable: AnyObject {
    func registerService<T>(service: T)
    func getService<T>() -> T?
    func removeService<T>(service: T.Type)
}

class ServiceProvider: ServiceProvidable {
    private lazy var serviceDictionary: [String: Any] = [:]
    /*
     (some is type(of: )) ?
         "\(some)" :
     */
    private func typeName(some: Any) -> String {
        return "\(type(of: some as Any))"
    }

    func registerService<T>(service: T) {
        let key = typeName(some: type(of: service as Any))
        print("[ServiceProvider] registerService \(key)")
        serviceDictionary[key] = service
    }

    func getService<T>() -> T? {
        let key = typeName(some: T.self as Any)
        print("[ServiceProvider] getService \(key)")
        return serviceDictionary[key] as? T
    }

    func removeService<T>(service: T.Type) {
        let key = typeName(some: service)
        serviceDictionary.removeValue(forKey: key)
    }
}
