//
//  APIErrors.swift
//  Photostic
//
//  Created by Shobhit Puri on 2024-02-08.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case invalidAPIKey
    case invalidResponse
    case genericError
}
