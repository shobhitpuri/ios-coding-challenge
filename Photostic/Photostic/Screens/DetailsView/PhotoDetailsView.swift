//
//  PhotoDetailsView.swift
//  Photostic
//
//  Shows details view of class.
//
//  Created by Shobhit Puri on 2024-02-08.
//

import SwiftUI

struct PhotoDetailsView: View {
    let imageObj: UnsplashImage
    let w: CGFloat
    let h: CGFloat
    let color: Color
    
        var body: some View {
            VStack{
                // Done to keep view in middle
                Spacer()
                UnsplashImageView(urlString: (imageObj.urls?.full)!, color: color, size: CGSize(width: w, height: h))
                    .aspectRatio(contentMode: .fit)
                Spacer()
            }.background(color.opacity(0.25))
        }
}

struct PhotoDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoDetailsView(imageObj: MockUnsplashData.sampleImage, w: CGFloat(200), h: CGFloat(250), color: Color.gray)
    }
}
