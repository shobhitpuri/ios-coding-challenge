//
//  PhotoDetailsView.swift
//  Photostic
//
//  Shows details view of class.
//
//  Created by Shobhit Puri on 2024-02-08.
//

import SwiftUI

/// TODO: Consider this for memory savings reasons to prevent OOM issues. However there is a bug when user does fast scrolling.
/// Needs more time to think and fix
///
/// Source of inspiratiopn: https://stackoverflow.com/a/76266987/1306419
/// Need for this comes from propert memory utilization
/// There is nothing available like LazyTabView.
/// If 100s of images in memory, the tabView will hold all, and there is no memory management
/// Here if we maintain 3 tabs, and replace the ImageViews there, it's more performant.

struct PhotoDetailsView: View {
    @Binding var imageArray: [UnsplashImage]
    @State var currentIndex: Int
    @Binding var frameSizeWidth: Int

    var body: some View {
        TabView(selection: $currentIndex) {
            ForEach(imageArray) { image in
                
                // TODO: Cleanup and get rid of repititive code.
                let imageBackgroundColor: Color = image.color != nil ? Color(hex: image.color!) : Color.white
                let imageAspectWidth = CGFloat(frameSizeWidth) / 2 - 10;
                let imageAspectHeight = CGFloat((Int(imageAspectWidth) * (image.height ?? 160)) / (image.width ?? 160))
                
                if let currentObjectIndex = imageArray.firstIndex(where: { $0.id == image.id }) {
                    
                    VStack {
                        UnsplashImageView(urlString: (image.urls?.regular ?? image.urls?.full ?? ""),
                                          color: imageBackgroundColor,
                                          size: CGSize(width: imageAspectWidth, height: imageAspectHeight))
                        .aspectRatio(contentMode: .fit)
                        Spacer()
                    }.tag(currentObjectIndex)
                        .background(imageBackgroundColor.opacity(0.25))
                } else {
                    Text ("Error").tag(0)
                }
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
    }
}


struct PhotoDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoDetailsView(imageArray: .constant([MockUnsplashData.sampleImage]), currentIndex: 0, frameSizeWidth: .constant(160))
    }
}
