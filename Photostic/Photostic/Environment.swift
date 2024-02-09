//
//  Environment.swift
//  Photostic
//
//  Created by Shobhit Puri on 2024-02-08.
//
//  This is useful when we don't want tp put senstivie keys in codebase
//

import Foundation

public enum Environment {
    enum Keys {
        static let apiKey = "UNSPLASH_API_CLIENT_ID"
    }
    
    //Getting plist here
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("plist file not found")
        }
        return dict
    }()
    
    //Get apiKey
    static let apiKey: String = {
        guard let apiKeyString = Environment.infoDictionary [Keys.apiKey] as? String else {
            fatalError("API Key not set in plist")
        }
        return apiKeyString
    }()
}
