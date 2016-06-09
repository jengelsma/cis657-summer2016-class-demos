//
//  PuppyFlixTests.swift
//  PuppyFlixTests
//
//  Created by Jonathan Engelsma on 10/14/15.
//  Copyright © 2015 Jonathan Engelsma. All rights reserved.
//

import XCTest
import OHHTTPStubs
@testable import PuppyFlix

// Test our YouTube integration
class YouTubeAPITests: XCTestCase {
    
    let timeout = NSTimeInterval(3.0)
    let url : String = YouTubeAPI.url + "&q=puppy"
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        //remove all stubs on tear down
        OHHTTPStubs.removeAllStubs()
    }
    
    func testGetVideosSuccess() {
        //set up stub to use
        stub(isHost(url), response: fixture("VideoStubSuccess.json"))
        
        let expectedPuppyVids = buildPuppyVideoExpectedList()
        var asynchVideos: [VideoInfo]?
        
        //get video data
        let responseArrived = self.expectationWithDescription("Response of async request has arrived.")
        YouTubeAPI.sharedInstance.getVideos("puppy") { (inner) -> () in
            
            responseArrived.fulfill()
            
            do {
                asynchVideos = try inner()
            } catch _ { }
        }
        
        //wait for asynchronous call to complete before running assertions
        self.waitForExpectationsWithTimeout(timeout) { _ -> Void in
            
            //test assertions
            XCTAssertEqual(asynchVideos!.count, 5)
            
            for x in 0..<asynchVideos!.count {
                XCTAssertEqual(expectedPuppyVids[x], asynchVideos![x])
            }
        }

        
    }
 
    func testGetVideoDataError() {
        
        //set up stub to use
        stub(isHost(url), response: fixture(NSData(), returnStatus: 400))
        
        var asynchErrorCode: Int?
        var asynchVideos: [VideoInfo]?
        
        //get video data
        let responseArrived = self.expectationWithDescription("Response of async request has arrived.")
        YouTubeAPI.sharedInstance.getVideos("puppy") { (inner) -> () in
            
            responseArrived.fulfill()
            do {
                asynchVideos = try inner()
            } catch VideoAPIError.StatusCodeError(let code) {
                asynchErrorCode = code
            } catch _ { }
        }
        
        //wait for asynchronous call to complete before running assertions
        self.waitForExpectationsWithTimeout(timeout) { _ -> Void in
            
            //test assertions
            XCTAssertEqual(asynchErrorCode, 400)
            XCTAssertNil(asynchVideos)
        }
    }

    
    func testGetVideoDataParseError() {
        
        //set up stub to use
        stub(isHost(url), response: fixture("VideoStubParseError.json"))
        
        var asynchVideos: [VideoInfo]?
        var asyncErrorOccurred = false

        //get video data
        let responseArrived = self.expectationWithDescription("Response of async request has arrived.")
        YouTubeAPI.sharedInstance.getVideos("puppy") { (inner) -> () in
            
            responseArrived.fulfill()

            do {
                asynchVideos = try inner()
            } catch VideoAPIError.ParseError {
                asyncErrorOccurred = true
            } catch _ { }
            

        }
        
        //wait for asynchronous call to complete before running assertions
        self.waitForExpectationsWithTimeout(self.timeout) { _ -> Void in
            
            //test assertions
            XCTAssertTrue(asyncErrorOccurred)
            XCTAssertNil(asynchVideos)
        }
    }

    func testGetVideosNetworkDown() {
        
        let notConnectedError = NSError(domain:NSURLErrorDomain, code:Int(CFNetworkErrors.CFURLErrorNotConnectedToInternet.rawValue), userInfo:nil)
        
        //set up stub to use
        stub(isHost(url), response: fixture(notConnectedError))
        
        var asynchError: NSError?
        var asynchVideos: [VideoInfo]?
        
        //get video data
        let responseArrived = self.expectationWithDescription("Response of async request has arrived.")
        YouTubeAPI.sharedInstance.getVideos("puppy") { (inner) -> () in
            
            responseArrived.fulfill()
            do {
                asynchVideos = try inner()
            } catch VideoAPIError.ResponseError(let error) {
                asynchError = error
            } catch _ { }
        }
        
        //wait for asynchronous call to complete before running assertions
        self.waitForExpectationsWithTimeout(timeout) { _ -> Void in
            
            //test assertions
            XCTAssertNil(asynchVideos)
            XCTAssertEqual(asynchError!.code, -1009)
        }
    }
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    



    

    
}
