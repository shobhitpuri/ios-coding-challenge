//
//  MockNetwork.swift
//  Photostic
//
//  Created by Shobhit Puri on 2024-02-09.
//

import UIKit

final class MockNetworkManager : NetworkingService {
    
    static let shared = MockNetworkManager()

    
    func getUnsplashImages(page: Int) async throws -> [UnsplashImage] {
        return MockUnsplashData().imageArray
    }
    
    func downloadImage(fromURLString urlString: String) async throws -> UIImage? {
        return UIImage(systemName: "heart.fill")
    }
}
