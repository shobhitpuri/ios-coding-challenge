//
//  NetworkImageView.swift
//  Photostic
//
//  Resuable Image View to be usin=ed to display images in the grid view as well as the details view
//
//  Created by Shobhit Puri on 2024-02-07.
//

import SwiftUI

struct UnsplashImageView: View {
    @StateObject var unsplashImageViewModel = UnsplashImageViewModel()
    
    @State var urlString: String
    @State var color: Color
    @State var size: CGSize
    
    var body: some View {
        // Placeholder view when image is being loaded.
        // We receive color and image size from the API,
        // After getting the right size keeping aspect ratio intant, we generate a Image of same size
        // as the Image to be loaded.
        //
        // The earlier intention was to use blur_has that comes with UnsplashAPI, but the Blur Decoder is very slow
        // Can read more about slowness here: https://github.com/woltapp/blurhash/issues/70, sometimes 4x slower than Android
        // Blur_has placeholders here: https://unsplash.com/documentation#blurhash-placeholders
        let placeHolderImage: Image = Image(uiImage: (UIColor(color)
            .withAlphaComponent(0.1)
            .image(size)))
            .resizable()
        
        NetworkImageView(image: unsplashImageViewModel.image,
                         placeHolderImage: placeHolderImage,
                         color: color)
        .onAppear {
            // Need to start the download of image when the placeholder appears
            unsplashImageViewModel.downloadImage(fromURLString: urlString)
        }
    }
}

struct NetworkImageView: View {
    var image: Image?
    var placeHolderImage: Image?
    var color: Color?
    
    var body: some View {
        if image != nil {
            image?.resizable()
        } else {
            ZStack {
                // placeholder
                placeHolderImage ?? Image(systemName: "questionmark.square.dashed").resizable()
                // Prorgess circle
                ProgressView().frame(width: 40, height: 40)
            }
        }
    }
}

