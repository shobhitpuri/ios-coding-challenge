//
//  NetworkImageViewModel.swift
//  Photostic
//
//  Created by Shobhit Puri on 2024-02-08.
//
import SwiftUI

final class UnsplashImageViewModel: ObservableObject {
    
    // If this changes we want the view to know
    @Published var image: Image? = nil
    
    /// Used to safely modify the Image once returned,  because it will always be running on the main queue.
    @MainActor
    func downloadImage(fromURLString urlString: String)  {
        Task{
            // Call NetworkManager in background using async await
            do {
                let uiImage = try await NetworkManager.shared.downloadImage(fromURLString: urlString)
                guard let uiImage = uiImage else {
                    return
                }
                
                self.image = Image(uiImage: uiImage)
            } catch {
                print("Error Loading Images \(error)")
            }
        }
    }
}
