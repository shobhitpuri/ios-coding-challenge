//
//  NetworkingService.swift
//  Photostic
//
//  Created by Shobhit Puri on 2024-02-09.
//

import UIKit

/// An interface for implementing network functions. This is to be able to inject MockNetworkManager for tests
protocol NetworkingService {
    func getUnsplashImages(page: Int) async throws -> [UnsplashImage]
    func downloadImage(fromURLString urlString: String) async throws -> UIImage?    
}
