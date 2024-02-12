//
//  ContentView.swift
//  Photostic
//
//  Created by Shobhit Puri on 2024-02-07.
//

import SwiftUI

struct PhotoGridView: View {
    @StateObject var viewModel = PhotoGridViewModel(network: NetworkManager.shared)
    
    // This changes if the position from details view changes. Used for scrolling logic to that position.
    @State var finalPositionFromDetails: Int = -1
    
    // Using this extra variable, because of a 'feature' of ScrollViewReader, wherein (I quote):
    //
    // https://developer.apple.com/documentation/swiftui/scrollviewreader
    //"You may not use the ScrollViewProxy during execution of the content view builder;
    // doing so results in a runtime error. Instead, only actions created within content can call the proxy,
    // such as gesture handlers or a view’s onChange(of:perform:) method.
    //
    // Because of above, we can scroll the view onAppear, and also if we listen on Change, it gets called
    // even if details view is onTop. So we reply on this extra @State var, which only gets changed onAPpear,
    // and we scroll on changing of this "currentPositionFromDetailsReceived" below, and not the "finalPositionFromDetails"
    @State var currentPositionFromDetailsReceived: Int = -1
    
    var body: some View {
        ZStack { // Needed for trasucent loader
            NavigationView { // For navigation to details view
                ScrollViewReader { proxy in // For scrolling programatically using scrollTo
                    ScrollView { // Make the grid scrollable
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 160))]) {
                            
                            // Loop through the image array.
                            // Make sure to use like this, and not through the count, since if the imageArray changes, not reflected here.
                            // Docs say: "It's important that the `id` of a data element doesn't change, unless SwiftUI considers the data element to have been replaced with a new data
                            // element that has a new identity.
                            ForEach(viewModel.imageArray) { currentImage in
                                
                                // Can later keep this somewhere else.
                                let imageBackgroundColor: Color = currentImage.color != nil ? Color(hex: currentImage.color!) : Color.white
                                let imageAspectWidth = CGFloat(viewModel.frameSizeWidth) / 2 - 10;
                                let imageAspectHeight = CGFloat((Int(imageAspectWidth) * (currentImage.height ?? 160)) / (currentImage.width ?? 160))
                                
                                // Find the index of the currently tapped grid item
                                if let currentObjectIndex = viewModel.imageArray.firstIndex(where: { $0.id == currentImage.id }) {
                                    
                                    NavigationLink(destination: PhotoDetailsView(imageArray: $viewModel.imageArray,
                                                                                 currentIndex: currentObjectIndex,
                                                                                 frameSizeWidth: $viewModel.frameSizeWidth,
                                                                                 finalPositionFromDetails: $finalPositionFromDetails)
                                    ) {
                                        VStack{
                                            Spacer()
                                            UnsplashImageView(
                                                urlString: (currentImage.urls?.thumb ?? currentImage.urls?.small ?? ""),
                                                color: imageBackgroundColor,
                                                size: CGSize(width: imageAspectWidth, height: imageAspectHeight))
                                            .id(currentImage.id) // for scrolling back
                                            .aspectRatio(contentMode: .fit)
                                            
                                            Spacer()
                                        }
                                        .background(imageBackgroundColor.opacity(0.25))
                                        
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
                        
                    }.onAppear {
                        // This will be called first time, or when coming from details etc.
                        print("Scroll: View Appear: \(finalPositionFromDetails)")
                        currentPositionFromDetailsReceived = finalPositionFromDetails
                        
                    }.onChange(of: currentPositionFromDetailsReceived) { newValue in
                        // Using logic to scroll to the position of the image, the user left in details view.
                        withAnimation {
                            print("Grid onChange to \(newValue)")
                            if !viewModel.imageArray.isEmpty && newValue >= 0 {
                                proxy.scrollTo(viewModel.imageArray[newValue].id, anchor: .center)
                            }
                        }
                    }
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .onAppear {
                // set frame size to claculate how to proper image size, while maintaining aspect ratio
                print("Navigation View Appear: Set FrameSize to be used for calculating aspectratio image size ")
                let screenWidth = Int(UIScreen.main.bounds.width)
                let screenHeight = Int(UIScreen.main.bounds.height)
                viewModel.setFrameSizes(screenWidth:screenWidth, screenHeight:screenHeight)
            }.task{
                print("Fetch Network Images")
                viewModel.fetchNetworkImages()
                // For situations where we want to test without washing 50/hr calls available
                //viewModel.fetchMockData()
            }
            
            // Loader when fetching more from API on Zlevel
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
        PhotoGridView(finalPositionFromDetails: 0)
    }
}
