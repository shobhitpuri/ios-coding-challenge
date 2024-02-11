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
    @Binding var finalPositionFromDetails: Int
    
    var body: some View {
        TabView(selection: $currentIndex) {
            ForEach(imageArray) { image in
                
                // TODO: Cleanup and get rid of repititive code.
                let imageBackgroundColor: Color = image.color != nil ? Color(hex: image.color!) : Color.white
                let imageAspectWidth = CGFloat(frameSizeWidth) / 2 - 10;
                let imageAspectHeight = CGFloat((Int(imageAspectWidth) * (image.height ?? 160)) / (image.width ?? 160))
                
                // Needed to assign tag to tab, since we are using index for it.
                // The currentIndex used relects that.
                if let positionInImageArray = imageArray.firstIndex(where: { $0.id == image.id }) {
                    VStack {
                        UnsplashImageView(urlString: (image.urls?.regular ?? image.urls?.full ?? ""),
                                          color: imageBackgroundColor,
                                          size: CGSize(width: imageAspectWidth, height: imageAspectHeight))
                        .aspectRatio(contentMode: .fit)
                        .padding(8)
                        Text(image.altDescription ?? image.description ?? "")
                            .padding(8)
                        Spacer()
                    }
                    // .tag() modifier used to keep track of each tab. It assigns a unique hashable id to each tab.
                    // Needed if you want to programmatically control which tab is currently showing, such as when initial one.
                    .tag(positionInImageArray)
                    .background(imageBackgroundColor.opacity(0.25))
                } else {
                    Text ("Error")
                }
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        // Listen to the change of the current tab, and since it reflects index, we use it to scroll back
        .onChange(of: currentIndex){ newValue in
            print("TAB: Current Index changed: \(newValue)")
            // This will be reflected in the SwiftUI view.
            finalPositionFromDetails = newValue
        }
    }
}


struct PhotoDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoDetailsView(imageArray: .constant(
            [MockUnsplashData.sampleImage]),
                         currentIndex: 0,
                         frameSizeWidth: .constant(160),
                         finalPositionFromDetails: .constant(0))
    }
}
