//
//  PhotoGridViewModel.swift
//  Photostic
//
//  Created by Shobhit Puri on 2024-02-08.
//

import Foundation


/// Marking whole class with @MainActor, since all @Publishedh properties here update the UI and
/// we want to ensure these UI updates always happen on the main actor, an
@MainActor final class PhotoGridViewModel: ObservableObject {
    // Helpful in mocking
    private let network : NetworkingService

    // If this changes we want the view to know. This will happen when new pages are fetched and image appended
    @Published var imageArray: [UnsplashImage] = []
    // In case there is rotation, we want view to know of the change
    @Published var frameSizeWidth: Int = 160
    // We want view to know when loading finishes or starts
    @Published var isLoading = false
    // Alerts need to be notified there
    @Published var alertItem: AlertItem?
        

    
    var page : Int = 1
    
    init (network: NetworkingService) {
        self.network = network
    }
    
    /// Updates the frameSizeWidth to be used to calculate the size of placeholder as well as image view
    /// while maintaining the aspect ratio.
    /// - Parameters:
    ///   - screenWidth: screenWidth
    ///   - screenHeight: screenHeight
    func setFrameSizes (screenWidth: Int, screenHeight: Int) {
        print ("ViewModel: Setting frameSizeWidth")
        if ( screenWidth < screenHeight) {
            self.frameSizeWidth = screenWidth
        } else {
            self.frameSizeWidth = screenHeight
        }
    }
    
    
    /// Call and set the mock data of 40 image responses available in the json file locally for testing
    func fetchMockData() {
        // Once the data is fetched, update the `imageArray` property
        // For demonstration, using mock data
        print("ViewModel: Fetching Mock data..")
        self.imageArray = MockUnsplashData().imageArray
    }
    
    
    /// Checks if we've reached the threshold and need to fetch the next page for more images to load,
    /// and then initiates the network call accordingly.
    /// - Parameter currentItem: last item that was displayed
    func fetchNextPageIfNeeded(currentItem: UnsplashImage){
        let thresholdIndex = self.imageArray.index(self.imageArray.endIndex, offsetBy: -1)
        if imageArray[thresholdIndex].id == currentItem.id {
            page += 1
            fetchNetworkImages()
        }
    }
    
    
    /// Call Unsplash API via NetworkManager to  start fetching.
    func fetchNetworkImages() {
        isLoading = true
        Task {
            do {
                // careful of the append here
                imageArray.append(contentsOf: try await network.getUnsplashImages(page: page))
                // if success, set loading to false, which will be reflected in the view, and Loading view would be hidden
                isLoading = false
            } catch {
                if let apiError = error as? APIError {
                    switch apiError {
                    case .invalidURL:
                        alertItem = Alerts.invalidURL
                    case .invalidAPIKey:
                        alertItem = Alerts.invalidAPIKey
                    case .invalidResponse:
                        alertItem = Alerts.invalidResponse
                    case .genericError:
                        alertItem = Alerts.genericError
                    }
                } else {
                    alertItem = Alerts.invalidResponse
                }
                // still need to set loading to false for error
                isLoading = false
            }
        }
    }
}
