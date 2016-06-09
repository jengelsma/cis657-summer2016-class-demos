//
//  MasterViewControllerTests.swift
//  PuppyFlix
//
//  Created by Jonathan Engelsma on 12/7/15.
//  Copyright © 2015 Jonathan Engelsma. All rights reserved.
//

import XCTest
@testable import PuppyFlix

class MockDetailViewController : DetailViewController {}


class MockAPI : YouTubeAPI {
    var videosLoaded : XCTestExpectation?
    
    override init() {
        super.init()
        self.videosLoaded = nil
    }
    
    override func getVideos(qStr: String?, completion: ((inner: () throws -> [VideoInfo]?) -> ())) {
        super.getVideos(qStr) { (inner) -> () in
            self.videosLoaded?.fulfill()
            completion(inner: inner)
        }
    }
}

// Test the MasterViewController methods
class MasterViewControllerTests: XCTestCase {
    
    var viewController: MasterViewController!
    let timeout = NSTimeInterval(3.0)

    
    override func setUp() {
        super.setUp()
        viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MasterViewController") as! MasterViewController
    
        
        let url : String = MockAPI.url + "&q=puppy"
        stub(isHost(url), response: fixture("VideoStubSuccess.json"))
        
        let api = MockAPI()
        viewController.videoAPI = api
        
        // set expections
        api.videosLoaded = self.expectationWithDescription("videos have been loaded")
        
        
        // force view did load to load.
        let _ = viewController.view

    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testViewDidLoad() {
        
        let expectedPuppyVids = buildPuppyVideoExpectedList()
        
        // 
        //wait for viewDidLoad to complete before running assertions
        self.waitForExpectationsWithTimeout(timeout) { _ -> Void in
            
            // after view loads, you should have 5 videos loaded!
            XCTAssertEqual(self.viewController.videos.count, 5)
            
            // the model data should be correct.
            for x in 0..<self.viewController.videos.count {
                XCTAssertEqual(expectedPuppyVids[x], self.viewController.videos[x])
            }
        }
    }
    
    func testViewTableCellConfigruation() {

        let expectedPuppyVids = buildPuppyVideoExpectedList()
        
        //
        //wait for viewDidLoad to complete before running assertions
        self.waitForExpectationsWithTimeout(timeout) { _ -> Void in
            
            // loop through the expected videos and make sure each cell is 
            // properly populated.
//            for var i = 0; i < expectedPuppyVids.count; i++ {
            for i in 0..<expectedPuppyVids.count {
                let cell: UITableViewCell = self.viewController.tableView(self.viewController.tableView, cellForRowAtIndexPath: NSIndexPath(forRow: i, inSection: 0))
                XCTAssertEqual(cell.textLabel!.text, expectedPuppyVids[i].title)
                XCTAssertEqual(cell.detailTextLabel!.text, expectedPuppyVids[i].description)
                XCTAssertNotNil(cell.imageView)
            }
        }
        
    }
    
    func testNumberOfRowsInSection() {
        let expectedPuppyVids = buildPuppyVideoExpectedList()
        
        self.waitForExpectationsWithTimeout(timeout) { _ -> Void in
            
            let numRows = self.viewController.tableView(self.viewController.tableView, numberOfRowsInSection: 0)
            
            XCTAssertEqual(numRows,expectedPuppyVids.count)
        }
        
    }
    
    func testSegueToDetail() {
        
        self.waitForExpectationsWithTimeout(timeout) { _ -> Void in
            
            let destCtrl = MockDetailViewController()
            let uiNavCtrl = UINavigationController()
            uiNavCtrl.setViewControllers([destCtrl], animated: false)
            
            // create a dummy but realistic segue instance
            let segue : UIStoryboardSegue = UIStoryboardSegue(identifier: "showDetail", source: self.viewController, destination: uiNavCtrl)
            
            // segue from every possible cell. 
            //for var i = 0; i<self.viewController.videos.count; i++ {
            for i in 0..<self.viewController.videos.count {
                
                // fudge the current row selection.
                self.viewController.tableView.selectRowAtIndexPath(NSIndexPath(forRow: i, inSection: 0), animated: false, scrollPosition: UITableViewScrollPosition.Top)
                
                let sender: UITableViewCell = self.viewController.tableView(self.viewController.tableView, cellForRowAtIndexPath: NSIndexPath(forRow: i, inSection: 0))
                
                self.viewController.prepareForSegue(segue, sender: sender)
                
                // make sure the model data on the target detail is set properly.
                XCTAssertEqual(destCtrl.detailItem, self.viewController.videos[i]);
            }
        }
    }
    

}
