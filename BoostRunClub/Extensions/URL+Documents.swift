//
//  URL+Documents.swift
//  BoostRunClub
//
//  Created by Imho Jang on 2020/12/10.
//

import Foundation

extension URL {
    static var documents: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}
