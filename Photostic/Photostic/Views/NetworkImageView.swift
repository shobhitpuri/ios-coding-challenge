//
//  NetworkImageView.swift
//  Photostic
//
//  Created by Shobhit Puri on 2024-02-07.
//

import SwiftUI

final class ImageLoader: ObservableObject {
    
    @Published var image: Image? = nil
    
    func load(fromURLString urlString: String)  {
        Task{
            do {
                let uiImage = try await NetworkManager.shared.downloadImage(fromURLString: urlString)
                guard let uiImage = uiImage else {
                    return
                }
                DispatchQueue.main.async {
                    self.image = Image(uiImage: uiImage)
                }
            } catch {
                print("Error Loading Images \(error)")
            }
        }
    }
}


struct NetworkImageView: View {
    
    var image: Image?
    var placeHolderImage: Image?
    
    var body: some View {
        ZStack {
            if image != nil {
                image?.resizable()
            } else {
                placeHolderImage ?? Image(systemName: "questionmark.square.dashed").resizable()
                ProgressView().frame(width: 40, height: 40)
            }
                        
        }
        
    }
}

struct UnsplashImageView: View {
    
    @StateObject var imageLoader = ImageLoader()

    let urlString: String
    let color: Color
    let size: CGSize
    
    var body: some View {
        let placeHolderImage: Image = Image(uiImage: (UIColor(color).withAlphaComponent(0.1).image(size))).resizable()

        NetworkImageView(image: imageLoader.image, placeHolderImage: placeHolderImage)
            .onAppear { imageLoader.load(fromURLString: urlString) }
    }
}
