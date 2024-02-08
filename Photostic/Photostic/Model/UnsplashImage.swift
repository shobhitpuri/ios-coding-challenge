//
//  UnsplashModel.swift
//  Photostic
//
//  Created by Shobhit Puri on 2024-02-07.
//
//  Created using https://app.quicktype.io/
//  This file was generated from JSON Schema using quicktype, do not modify it directly.
//  To parse the JSON, add this file to your project and do:
//
//  let unsplashAPI = try? JSONDecoder().decode(UnsplashAPI.self, from: jsonData)

import Foundation

// MARK: - UnsplashAPIElement
struct UnsplashImage: Codable, Identifiable {
    let id: String
    let width, height: Int?
    let color, blurHash: String?
    let description: String?
    let altDescription: String?
    let urls: Urls?
    
    enum CodingKeys: String, CodingKey {
        case id
        case width, height, color
        case blurHash = "blur_hash"
        case description
        case altDescription = "alt_description"
        case urls
    }
}

// MARK: - Urls
struct Urls: Codable {
    let raw, full, regular, small: String?
    let thumb, smallS3: String?

    enum CodingKeys: String, CodingKey {
        case raw, full, regular, small, thumb
        case smallS3 = "small_s3"
    }
}
