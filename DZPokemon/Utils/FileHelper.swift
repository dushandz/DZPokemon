//
//  FileHelper.swift
//  DZPokemon
//
//  Created by dushandz on 2020/4/16.
//  Copyright © 2020 dushandz. All rights reserved.
//

import Foundation

enum FileHelper {
    
    static func loadBundleJson<T: Decodable>(file: String) -> T {
        guard let url = Bundle.main.url(forResource: file, withExtension: "json") else {
            fatalError("file not found.")
        }
        //if error thrown runtime crash.
        return try! loadJSON(from: url)
    }
    
    static func loadJSON<T: Decodable>(from url: URL) throws -> T {
        //if error thrown runtime crash.
        let data = try Data(contentsOf: url)
        return try appDecoder.decode(T.self, from: data)
    }
    
}


