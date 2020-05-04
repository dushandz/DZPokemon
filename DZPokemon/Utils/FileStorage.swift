//
//  FileStorage.swift
//  DZPokemon
//
//  Created by dushandz on 2020/5/3.
//  Copyright © 2020 dushandz. All rights reserved.
//

import Foundation

@propertyWrapper
struct FileStorage<T: Codable> {
    var value: T?
    let directory: FileManager.SearchPathDirectory
    let fileName: String
    
    init(directory: FileManager.SearchPathDirectory, fileName: String) {
        value = try? FileHelper.loadJSON(from: directory, fileName: fileName)
        self.directory = directory
        self.fileName = fileName
    }
    
    var wrappedValue: T? {
        set {
            value = newValue
            if let value = newValue {
                try? FileHelper.writeJSON(value, to: directory, fileName: fileName)
            } else {
                try? FileHelper.delete(from: directory, fileName: fileName)
            }
        }
        
        get { value }
    }
}

@propertyWrapper
struct UserDefaultsStorage<T: Codable> {
    var value: T
    let keyName: String
    
    init(initialValue: T, keyName: String) {
        if let val = UserDefaults.standard.value(forKey: keyName) {
            self.value = val as! T
        } else {
            self.value = initialValue
        }
        self.keyName = keyName
    }
    
    var wrappedValue: T {
        set {
            self.value = newValue
            UserDefaults.standard.set(newValue, forKey: keyName)
        }
        
        get { value }
    }
}
