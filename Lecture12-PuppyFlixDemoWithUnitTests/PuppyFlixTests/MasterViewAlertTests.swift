//
//  MasterViewAlertTests.swift
//  PuppyFlix
//
//  Created by Jonathan Engelsma on 12/8/15.
//  Copyright © 2015 Jonathan Engelsma. All rights reserved.
//

import Foundation

import XCTest
@testable import PuppyFlix

// Mock the UIAlertController action so we can see button was pressed.
class MockAlertAction : UIAlertAction {
    
    typealias Handler = ((UIAlertAction) -> Void)
    var handler: Handler?
    var mockTitle: String?
    var mockStyle: UIAlertActionStyle
    
    convenience init(title: String?, style: UIAlertActionStyle, handler: ((UIAlertAction) -> Void)?) {
        self.init()
        
        mockTitle = title
        mockStyle = style
        self.handler = handler
    }
    
    override init() {
        mockStyle = .Default
        
        super.init()
    }
}

// We don't need that data here, just want to make sure the API was called from the alert dialog
class MockDoNothingAPI : YouTubeAPI {
    var videosLoaded : XCTestExpectation?
    var calledLoadVideos = false
    
    override init() {
        super.init()
        self.videosLoaded = nil
    }
    
    override func getVideos(qStr: String?, completion: ((inner: () throws -> [VideoInfo]?) -> ())) {
        self.calledLoadVideos = true
    }
}

// Test that the alert displays on network error, and that it calls the API again when button is pressed. 
class MasterViewAlertTests: XCTestCase {

    var viewController: MasterViewController!
    
    override func setUp() {
        super.setUp()
        viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MasterViewController") as! MasterViewController
    }
    
    func testShowAlertErrorTitleGetsSet()
    {
        viewController.videoAPI = MockDoNothingAPI()
        
        let _ = viewController.view
        
        // need to set rootViewController or we can't present UIAlertViewController.
        UIApplication.sharedApplication().keyWindow?.rootViewController = viewController
        
        viewController.showAlertError()
        
        XCTAssertTrue(viewController.presentedViewController is UIAlertController)
        let alertController = viewController.presentedViewController as! UIAlertController

        XCTAssertEqual(alertController.title, "Error")
        XCTAssertEqual(alertController.message, "An error occurred while trying to fetch YouTube videos.  Press button below to try again")

    }

    func testAlertOKButtonCallsLoadVideos()
    {
        let api = MockDoNothingAPI()
        viewController.videoAPI = api
        viewController.Action = MockAlertAction.self
        
        let _ = viewController.view
        
        UIApplication.sharedApplication().keyWindow?.rootViewController = viewController
        
        viewController.showAlertError()
        api.calledLoadVideos = false  // loading the view called it, so we reset. 
        let alertController = viewController.presentedViewController as! UIAlertController
        let action = alertController.actions.first as! MockAlertAction
        action.handler!(action)
        XCTAssertTrue(api.calledLoadVideos)
        

    }
}