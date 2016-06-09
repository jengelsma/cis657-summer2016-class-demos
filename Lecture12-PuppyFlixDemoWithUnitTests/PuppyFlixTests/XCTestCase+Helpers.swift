//
//  XCTestCase+Helpers.swift
//  
//  Some handy methods extending XCTestCase to make it easy to work with OHHTTPStubs in test cases.
//
//  Created by Jonathan Engelsma on 12/7/15.
//  Copyright © 2015 Jonathan Engelsma. All rights reserved.
//

import Foundation
import XCTest
import OHHTTPStubs
@testable import PuppyFlix

extension XCTestCase {
    
    
    // helper function to generate the expected model data given the test fixtures. 
    func buildPuppyVideoExpectedList() -> [VideoInfo] {
        
        var videos = [VideoInfo]()
        
        videos.append(VideoInfo(id: "dgHRwscpPIA", title: "Funny Puppy Videos Compilation 2014", description: "Funny puppies doing funny things in this funny puppy videos compilation.", smallImageUrl: "https://i.ytimg.com/vi/dgHRwscpPIA/default.jpg", mediumImageUrl: "https://i.ytimg.com/vi/dgHRwscpPIA/mqdefault.jpg"))
        videos.append(VideoInfo(id: "cMSOQ3fSvJs", title: "Newfoundland Puppy Dog Carries Smaller Puppy Dog in Mouth", description: "A Newfoundland puppy dog runs outdoors with a smaller puppy dog in his mouth. SUBSCRIBE TO KYOOT!: http://bit.ly/16JmSEQ Watch More Animal Videos at: ...", smallImageUrl: "https://i.ytimg.com/vi/cMSOQ3fSvJs/default.jpg", mediumImageUrl: "https://i.ytimg.com/vi/cMSOQ3fSvJs/mqdefault.jpg"))
        videos.append(VideoInfo(id: "E__F5a2pQco", title: "Cats Meeting Puppies for the First Time Compilation 2014 [HD]", description: "Cats first encounter with new puppies. Cats and puppies interacting is so funny, some of these cats really don't know what to think! Puppies & Babies & Kitties ...", smallImageUrl: "https://i.ytimg.com/vi/E__F5a2pQco/default.jpg", mediumImageUrl: "https://i.ytimg.com/vi/E__F5a2pQco/mqdefault.jpg"))
        videos.append(VideoInfo(id: "L3MtFGWRXAA", title: "Puppyhood", description: "This man found a soulmate in a puppy and it's adorable. Grow up right from the first bite. Visit https://puppyhood.com/ for all things puppy. Music by Brooms ...", smallImageUrl: "https://i.ytimg.com/vi/L3MtFGWRXAA/default.jpg", mediumImageUrl: "https://i.ytimg.com/vi/L3MtFGWRXAA/mqdefault.jpg" ))
        videos.append(VideoInfo(id: "2EfHtzauHcM", title: "I GOT A PUPPY! - Cooper the 8 week old Golden Retriever", description: "Thumbs up for more Cooper on this channel! Follow me on Twitter/Instagram for more pictures:  http://www.twitter.com/TmarTn ...", smallImageUrl: "https://i.ytimg.com/vi/2EfHtzauHcM/default.jpg", mediumImageUrl: "https://i.ytimg.com/vi/2EfHtzauHcM/mqdefault.jpg"))
        
        return videos
    }
    
    /**
     * Helper function which tests host URL request to see if it is contained in given host.
     */
    func isHost(host: String) -> (NSURLRequest -> Bool) {
        return { req in req.URL?.absoluteString == host }
    }
    
    /**
     * Helper function which returns stubbed response for given file
     */
    func fixture(filename: String, status: Int32 = 200) -> (NSURLRequest -> OHHTTPStubsResponse) {
        let filePath = OHPathForFile(filename, self.dynamicType)
        return { _ in OHHTTPStubsResponse(fileAtPath: filePath!, statusCode: status, headers: ["Content-Type":"application/json"]) }
    }
    
    /**
     * Helper function which returns stubbed response for given data
     */
    func fixture(data: NSData, returnStatus: Int32 = 200) -> (NSURLRequest -> OHHTTPStubsResponse) {
        return { _ in OHHTTPStubsResponse(data: data, statusCode: returnStatus, headers: ["Content-Type":"application/json"]) }
    }
    
    /**
     * Helper function which returns stubbed response for given error
     */
     func fixture(error: NSError) -> (NSURLRequest -> OHHTTPStubsResponse) {
        return { _ in  return OHHTTPStubsResponse(error: error) }
    }
    
    /**
     * Helper function that takes a request and response and sets up stub.
     */
    func stub(condition: NSURLRequest -> Bool, response: NSURLRequest -> OHHTTPStubsResponse) {
        OHHTTPStubs.stubRequestsPassingTest({ condition($0) }, withStubResponse: response)
    }
}