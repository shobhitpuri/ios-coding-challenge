//
//  ContentView.swift
//  Photostic
//
//  Created by Shobhit Puri on 2024-02-07.
//

import SwiftUI

struct PhotoGridView: View {
    @StateObject var viewModel = PhotoGridViewModel(network: NetworkManager.shared)

    
    var body: some View {
        ZStack { // Needed for trasucent loader
            NavigationView { // For navigation to details view
                ScrollViewReader { value in
                    
                    ScrollView { // Make the grid scrollable
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 160))]) {
                            
                            // Loop through the image array.
                            // Make sure to use like this, and not through the count, since if the imageArray changes, not reflected here.
                            // Docs say: "It's important that the `id` of a data element doesn't change, unless SwiftUI considers the data element to have been replaced with a new data
                            // element that has a new identity.
                            ForEach(viewModel.imageArray) { currentImage in
                                let imageBackgroundColor: Color = currentImage.color != nil ? Color(hex: currentImage.color!) : Color.white
                                let imageAspectWidth = CGFloat(viewModel.frameSizeWidth) / 2 - 10;
                                let imageAspectHeight = CGFloat((Int(imageAspectWidth) * (currentImage.height ?? 160)) / (currentImage.width ?? 160))
                                
                                // Find the index of the currently tapped grid item
                                if let currentObjectIndex = viewModel.imageArray.firstIndex(where: { $0.id == currentImage.id }) {
                                    
                                    NavigationLink(destination: PhotoDetailsView(imageArray: $viewModel.imageArray,
                                                                                 currentIndex: currentObjectIndex,
                                                                                 frameSizeWidth: $viewModel.frameSizeWidth)) {
                                        VStack{
                                            Spacer()
                                            UnsplashImageView(
                                                urlString: (currentImage.urls?.thumb ?? currentImage.urls?.small ?? ""),
                                                color: imageBackgroundColor,
                                                size: CGSize(width: imageAspectWidth, height: imageAspectHeight))
                                            .id(currentObjectIndex) // for scrolling back
                                            .aspectRatio(contentMode: .fit)
                                            
                                            Spacer()
                                        }.background(imageBackgroundColor.opacity(0.25))
                                        
                                    }.onAppear {
                                        // Each time a new grid object appears, we check if we've reached the end of the list inside
                                        // the view model. Only then we load more.
                                        viewModel.fetchNextPageIfNeeded(currentItem: currentImage)
                                    }
                                } else {
                                    Text("!Error!")
                                }
                            }
                        }.navigationTitle("Grid")
                    }
                }
            }.onAppear {
                // set frame size to claculate how to proper image size, while maintaining aspect ratio
                print("Set FrameSize to be used for calculating aspectratio image size ")
                let screenWidth = Int(UIScreen.main.bounds.width)
                let screenHeight = Int(UIScreen.main.bounds.height)
                viewModel.setFrameSizes(screenWidth:screenWidth, screenHeight:screenHeight)
                
                
            }.task{
                print("Fetch Network Images")
                viewModel.fetchNetworkImages()
                // For situations where we want to test without washing 50/hr calls available
                //viewModel.fetchMockData()
            }
            
            if viewModel.isLoading {
                LoadingView()
            }
        }.alert(item: $viewModel.alertItem) { alertItem in
            // Alert shown on network related errors
            Alert(title: alertItem.title,
                  message: alertItem.message,
                  dismissButton: alertItem.dismissButton)
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoGridView()
    }
}
