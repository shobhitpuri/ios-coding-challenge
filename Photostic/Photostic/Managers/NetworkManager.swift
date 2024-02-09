//
//  NetworkManager.swift
//  Photostic
//
//  Created by Shobhit Puri on 2024-02-07.
//

import UIKit

final class NetworkManager : NetworkingService {
    enum Constants {
      static let cacheCountLimit: Int = 69
      static let baseUrl: String = "https://api.unsplash.com/photos/"
      static var perPageImages = 10 // Max 30, default 10 // Free API limited to default
    }
        
    static let shared = NetworkManager()
    
    //Image cahce
    private let cache = NSCache<NSString, UIImage>()
    
    // URL
    private let unsplashAPIFetchURL = Constants.baseUrl +
        "?client_id=\(Environment.apiKey)" +
        "&fit=fill" + // Resizes the image while preserving the original aspect ratio and without discarding any original image data.
        "&auto=format" + //Automatic supports AVIF / webP and switches b/w them, way better than jpg. Free might not allow it.
        "$per_page=\(Constants.perPageImages)"
        //+    "&page=\(page)" // This we modify later
        
    
    /// API call to Unsplash API to fetch the response containing links of latest random  images, average colors, size etc
    /// - Parameter page: page no.
    /// - Returns: Array of UnsplashImage type
    func getUnsplashImages(page: Int) async throws -> [UnsplashImage] {
        print("Fetch URL: \(unsplashAPIFetchURL)")
        print("Page: \(page)")
        // Check for key
        if Environment.apiKey.isEmpty {
            throw APIError.invalidAPIKey
        }
        
        // Check for proper URL
        guard let url = URL(string: unsplashAPIFetchURL+"&page=\(page)") else {
            throw APIError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode([UnsplashImage].self, from: data)
        } catch {
            throw APIError.invalidResponse
        }
    }
    
    
    /// Network call to download the image given a link using await and async.
    /// NOTE: This was prefereed over AsyncImage, since there isnb't a caching mechanism available with it.
    /// Here we also store it to cache on success
    ///
    /// - Parameter urlString: urlString
    /// - Returns: UIImage?
    func downloadImage(fromURLString urlString: String) async throws -> UIImage? {
        
        let cacheKey = NSString(string: urlString)
        
        if let image = cache.object(forKey: cacheKey) {
            return image
        }
        
        guard let url = URL(string: urlString) else {
            return nil
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let image = UIImage(data: data) else {
                return nil
            }
            cache.setObject(image, forKey: cacheKey)
            return image
        } catch {
            print("Error Downloading Image: \(error)")
            return nil
        }
    }
}

