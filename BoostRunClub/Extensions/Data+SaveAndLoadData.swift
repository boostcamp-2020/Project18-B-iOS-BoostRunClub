//
//  Data+SaveAndLoadData.swift
//  BoostRunClub
//
//  Created by Imho Jang on 2020/12/10.
//

import Foundation

extension Data {
    static func loadImageDataFromDocumentsDirectory(fileName: String) -> Data? {
        let fileURL = URL.documents.appendingPathComponent(fileName)
        do {
            let imageData = try Data(contentsOf: fileURL)
            return imageData
        } catch {
            print(error)
        }
        return nil
    }

    static func saveImageDataToDocumentsDirectory(fileName: String, imageData: Data) {
        let url = URL.documents.appendingPathComponent(fileName)
        do {
            try imageData.write(to: url)
        } catch {
            print(error)
        }
    }
}
