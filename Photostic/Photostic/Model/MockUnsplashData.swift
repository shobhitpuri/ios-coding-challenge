//
//  ImageResponseFramework.swift
//  Photostic
//
//  Mock Class to parse sample JSON file from Unsplash API response. This was done for two reasons:
//  1. Real world scenario: Many time API are not ready, and we can start app login in mean time. This was to show this approach.
//  2. prevent getting beyond the 50 calls per hour limit when testing.
//
//  Created by Shobhit Puri on 2024-02-07.
//

import Foundation

class MockUnsplashData: ObservableObject, Identifiable {
    
    @Published var imageArray: [UnsplashImage] = []
    
    init () {
        imageArray = loadMockData()!
    }
    
    func loadMockData() -> [UnsplashImage]? {
        // sampleResponse.json file is in app bundle
        guard let url = Bundle.main.url(forResource: "sampleResponse", withExtension: "json") else {
            fatalError("Failed to locate sampleResponse.json in bundle.")
        }
        
        do {
            // Read the JSON data from the file
            let jsonData = try Data(contentsOf: url)
            // Decode the JSON data into Swift structs
            let unsplashAPIResponse: [UnsplashImage] = try JSONDecoder().decode([UnsplashImage].self, from: jsonData)
            // Now you can use the `unsplashAPI` object as your mock data
            return unsplashAPIResponse
        } catch {
            print("Error decoding JSON: \(error)")
        }
        return nil
    }
    
    
    static let sampleImage = UnsplashImage(id: "1",
                                           width: 200,
                                           height: 250,
                                           color: "#c0d9d9",
                                           blurHash: "LdI$E24oMxo#~qNakXaeTex]ayay",
                                           description: "Sweeping aerial views over a beautiful sunset on along New Zealand's West Coast.",
                                           altDescription: "an aerial view of a beach and a forested area",
                                           urls: Urls(raw: "https://images.unsplash.com/photo-1707090804669-72f8a7f3348e?ixid=M3w1MTE0MnwwfDF8YWxsfDEyfHx8fHx8Mnx8MTcwNzM1MDA1OHw&ixlib=rb-4.0.3",
                                                      full: "https://images.unsplash.com/photo-1707090804669-72f8a7f3348e?crop=entropy&cs=srgb&fm=jpg&ixid=M3w1MTE0MnwwfDF8YWxsfDEyfHx8fHx8Mnx8MTcwNzM1MDA1OHw&ixlib=rb-4.0.3&q=85",
                                                      regular: "https://images.unsplash.com/photo-1707090804669-72f8a7f3348e?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w1MTE0MnwwfDF8YWxsfDEyfHx8fHx8Mnx8MTcwNzM1MDA1OHw&ixlib=rb-4.0.3&q=80&w=1080",
                                                      small: "https://images.unsplash.com/photo-1707090804669-72f8a7f3348e?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w1MTE0MnwwfDF8YWxsfDEyfHx8fHx8Mnx8MTcwNzM1MDA1OHw&ixlib=rb-4.0.3&q=80&w=400",
                                                      thumb: "https://images.unsplash.com/photo-1707090804669-72f8a7f3348e?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w1MTE0MnwwfDF8YWxsfDEyfHx8fHx8Mnx8MTcwNzM1MDA1OHw&ixlib=rb-4.0.3&q=80&w=200",
                                                      smallS3: ""))
}
