//
//  DetailViewControllerTests.swift
//  PuppyFlix
//
//  Created by Jonathan Engelsma on 12/10/15.
//  Copyright © 2015 Jonathan Engelsma. All rights reserved.
//

import XCTest
@testable import PuppyFlix

class DetailViewControllerTests: XCTestCase {

    var viewController: DetailViewController!
    
    override func setUp() {
        super.setUp()
        viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testViewDidLoad() {
        
        // create/set  a dummy fixture.
        let detailData = VideoInfo(id: "1",title: "title", description: "description", smallImageUrl: "https://i.ytimg.com/vi/dgHRwscpPIA/default.jpg", mediumImageUrl: "https://i.ytimg.com/vi/dgHRwscpPIA/mqdefault.jpg")
        self.viewController.detailItem = detailData
        
        // force view did load to load.
        let _ = viewController.view
        
        // make sure detail item is set and view data populated.
        XCTAssertNotNil(self.viewController.detailItem)
        XCTAssertNotNil(self.viewController.videoTitle)
        XCTAssertEqual(self.viewController.videoTitle.text, detailData.title)
        XCTAssertNotNil(self.viewController.videoDescription)
        XCTAssertEqual(self.viewController.videoDescription.text, detailData.description)
        XCTAssertNotNil(self.viewController.videoImage)
        
        // make sure the sharebutton is on the nav bar and wired up to the share method.
        let barButtons = self.viewController.navigationItem.rightBarButtonItems
        XCTAssertEqual(barButtons?.count, 1)
        let shareButton: UIBarButtonItem = barButtons![0]

        XCTAssertEqual(shareButton.action, #selector(DetailViewController.share))
        XCTAssertEqual(shareButton.target as? DetailViewController, self.viewController)
        
    }
    
    func testShareAction() {
        
        // create the data fixture.
        let detailData = VideoInfo(id: "1",title: "title", description: "description", smallImageUrl: "https://i.ytimg.com/vi/dgHRwscpPIA/default.jpg", mediumImageUrl: "https://i.ytimg.com/vi/dgHRwscpPIA/mqdefault.jpg")
        
        // the share action depends on the controller being embedded in a nav controller.
        let nc = UINavigationController(rootViewController: self.viewController)
        
        // set the data fixture.
        self.viewController.detailItem = detailData
        
        // force view did load to load.
        let _ = viewController.view
        
        // absolutely must do this or you will not be able to get the UIActivityViewController to present.
        UIApplication.sharedApplication().keyWindow?.rootViewController = nc
        
        // call the method we are testing.
        viewController.share()
        
        // make sure the bugger is properly presented.
        let activityController = viewController.presentedViewController as! UIActivityViewController
        XCTAssertNotNil(activityController)
        XCTAssertEqual(activityController.presentingViewController, nc)
        
    }


}
