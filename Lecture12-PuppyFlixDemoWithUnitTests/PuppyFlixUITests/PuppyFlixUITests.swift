//
//  PuppyFlixUITests.swift
//  PuppyFlixUITests
//
//  Created by Jonathan Engelsma on 10/14/15.
//  Copyright © 2015 Jonathan Engelsma. All rights reserved.
//

import XCTest

class PuppyFlixUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        //XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // helper function that lets us modify the startup args.
    private func launchAppWithArgs(args: [String]) -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments = args
        app.launch()
        return app
    }
    
    func testTableLoads() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCUIDevice.sharedDevice().orientation = .Portrait
        
        let app = launchAppWithArgs([ "UI_TESTING_MODE" ])
        
        // check if we have one table
        XCTAssertEqual(app.tables.count, 1)
        
        // confirm we have five rows in the table
        XCTAssertEqual(app.tables.element.cells.count, 5)
        
        XCUIDevice.sharedDevice().orientation = .Portrait
        XCUIApplication().tables.staticTexts["Puppyhood"].tap()
        
    }
    
    func testDetailSegue() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCUIDevice.sharedDevice().orientation = .Portrait
        
        let app = launchAppWithArgs([ "UI_TESTING_MODE" ])
        
        XCUIDevice.sharedDevice().orientation = .Portrait
        XCUIApplication().tables.staticTexts["Puppyhood"].tap()

        
        // check that you have three items in the view.
        XCTAssert(app.staticTexts["title"].exists)
        XCTAssert(app.otherElements["description"].exists)
        XCTAssert(app.images["thumbnail"].exists)
        
        // check for the share button.
        let detailNavigationBarsQuery = app.navigationBars.matchingIdentifier("Detail")
        XCTAssert(detailNavigationBarsQuery.buttons["Share"].exists)


    }
    
    func testViewInSafariWorks() {
        
        let app = launchAppWithArgs([ "UI_TESTING_MODE" ])
        
        app.tables.staticTexts["Funny puppies doing funny things in this funny puppy videos compilation."].tap()
        
        // confirm we are on the detail screen
        XCTAssert(app.staticTexts["Detail"].exists)

        let detailNavigationBarsQuery = app.navigationBars.matchingIdentifier("Detail")
        XCTAssert(detailNavigationBarsQuery.buttons["Share"].exists)
        detailNavigationBarsQuery.buttons["Share"].tap()
        
        // make sure the open in safari button exists
        XCTAssert(app.sheets.collectionViews.collectionViews.buttons["Open in Safari"].exists)
        app.sheets.collectionViews.collectionViews.buttons["Open in Safari"].tap()

        // confirm we are NOT on the detail screen anymore.
        //XCTAssert(!app.staticTexts["Detail"].exists)
    }

    
    func testThatAlertPopsOnNetworkError()
    {
        
        _ = launchAppWithArgs(["UI_TESTING_MODE_NO_NETWORK"])
        
        // at this point we should have a dandy error alert showing with a try again button.
        let errorAlert = XCUIApplication().alerts["Error"]
        XCTAssert(errorAlert.staticTexts["An error occurred while trying to fetch YouTube videos.  Press button below to try again"].exists)
        XCTAssert(errorAlert.collectionViews.buttons["Try Again"].exists)
        
    }
    
    func testDemoMethod()
    {
        
let app = launchAppWithArgs([ "UI_TESTING_MODE" ])
        let tablesQuery = app.tables
        tablesQuery.staticTexts["Puppyhood"].pressForDuration(0.6);
        
        let masterButton = app.navigationBars.matchingIdentifier("Detail").buttons["Master"]
        masterButton.tap()
        tablesQuery.staticTexts["This man found a soulmate in a puppy and it's adorable. Grow up right from the first bite. Visit https://puppyhood.com/ for all things puppy. Music by Brooms ..."].tap()
        masterButton.tap()
        
    }
    
}
