//
//  PhotoGridViewUITests.swift
//  PhotosticUITests
//
//  Created by Shobhit Puri on 2024-02-09.
//

import XCTest
@testable import Photostic

final class PhotoGridViewUITests: XCTestCase {
    
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let app = XCUIApplication()
        app.launch()
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testGridViewIsPresent() {
        let app = XCUIApplication()
        let scrollView = app.scrollViews
        XCTAssert(scrollView.element.exists)
    }
    
    func testTapImageViewForDetailsViewAndCheckNavBarBackButtonText() {
        let app = XCUIApplication()
        app.scrollViews.children(matching: .other).element(boundBy: 0).children(matching: .other).element.children(matching: .button).element(boundBy: 1).tap()
        XCTAssert(app.navigationBars["_TtGC7SwiftUI19UIHosting"].buttons["Grid"].exists)
    }
        
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
