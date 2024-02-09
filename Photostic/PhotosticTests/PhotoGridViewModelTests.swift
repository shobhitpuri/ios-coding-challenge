//
//  PhotoGridViewModelTests.swift
//  PhotosticTests
//
//  Created by Shobhit Puri on 2024-02-09.
//

import XCTest
@testable import Photostic

@MainActor
final class PhotoGridViewModelTests: XCTestCase {
    
    var viewModel: PhotoGridViewModel!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        // Inject mock network manager
        viewModel = PhotoGridViewModel(network: MockNetworkManager.shared)
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModel = nil
    }
    
    // MARK: - Test fetchMockData
    
    func testFetchMockData() {
        viewModel.fetchMockData()
        XCTAssertTrue(!viewModel.imageArray.isEmpty)
    }

    func testFetchMockDataAtleastOneObject() {
        viewModel.fetchMockData()
        XCTAssertTrue(viewModel.imageArray.count >= 1)
    }

    // MARK: - Test fetchNextPageIfNeeded
    
    func testFetchNextPageIfNeeded_Success() {
        // Has 40 items
        viewModel.imageArray = MockUnsplashData().loadMockData()!
        // get the last item access
        let lastItem = viewModel.imageArray[viewModel.imageArray.count - 1]
        // The function should fetch the next page if the currentItem is the last item in the array.
        // In this case the current item is one of the ones present in the mockfiles
        viewModel.fetchNextPageIfNeeded(currentItem: lastItem)
        // Page increases and fetch is called
        XCTAssertEqual(viewModel.page, 2)
    }

    func testFetchNextPageIfNeeded_Failure() {
        // Has 40 items
        viewModel.imageArray = MockUnsplashData().loadMockData()!
        // get the last item access
        let firstItem = MockUnsplashData.sampleImage
        // The function should fetch the next page if the currentItem is the last item in the array.
        // In this case the current item is one of the ones present in the mockfiles
        viewModel.fetchNextPageIfNeeded(currentItem: firstItem)
        // We still continue to be there
        XCTAssertEqual(viewModel.page, 1)
    }

    // MARK: - Test fetchNetworkImages

    func testFetchNetworkImages() async {
        // Stub NetworkManager to return some mock images
        let mockImages = [MockUnsplashData.sampleImage]
        viewModel.fetchNetworkImages()
        XCTAssertTrue(viewModel.isLoading)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertFalse(self.viewModel.isLoading)
            XCTAssertEqual(self.viewModel.imageArray, mockImages)
        }
    }
}
