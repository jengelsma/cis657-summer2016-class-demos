//
//  AppDelegate.swift
//  PuppyFlix
//
//  Created by Jonathan Engelsma on 10/14/15.
//  Copyright © 2015 Jonathan Engelsma. All rights reserved.
//

import UIKit
import OHHTTPStubs

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?

    var count: Int?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        let splitViewController = self.window!.rootViewController as! UISplitViewController
        let navigationController = splitViewController.viewControllers[splitViewController.viewControllers.count-1] as! UINavigationController
        navigationController.topViewController!.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem()
        splitViewController.delegate = self
        
        // wire up the video API
        let nav2 = splitViewController.viewControllers[0] as? UINavigationController
        let controller = nav2?.topViewController as? MasterViewController
        
        
        
        let arguments = NSProcessInfo.processInfo().arguments
        let mock = arguments.contains("UI_TESTING_MODE")
        let errorMock = arguments.contains("UI_TESTING_MODE_NO_NETWORK")
        if mock  {
            // hijack the HTTP fetch
            let url : String = YouTubeAPI.url + "&q=puppy"
            stub(isHost(url), response: fixture("VideoStubSuccess.json"))
        } else if errorMock {
            let url : String = YouTubeAPI.url + "&q=puppy"
            let notConnectedError = NSError(domain:NSURLErrorDomain, code:Int(CFNetworkErrors.CFURLErrorNotConnectedToInternet.rawValue), userInfo:nil)
            stub(isHost(url), response: fixture(notConnectedError))
        }
        controller?.videoAPI = YouTubeAPI.sharedInstance

        self.count = 0
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    // MARK: - Split view

    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController:UIViewController, ontoPrimaryViewController primaryViewController:UIViewController) -> Bool {
        guard let secondaryAsNavController = secondaryViewController as? UINavigationController else { return false }
        guard let topAsDetailController = secondaryAsNavController.topViewController as? DetailViewController else { return false }
        if topAsDetailController.detailItem == nil {
            // Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
            return true
        }
        return false
    }
    
    func incrementNetworkActivity() {
        self.count! += 1
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    func decrementNetworkActivity() {
        if self.count! > 0 {
            self.count! -= 1
        }
        if self.count! == 0 {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
    }
    
    func resetNetworkActivity() {
        self.count! = 0
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    
    // NOTE: Should try to implement these as a protocol extension!!! (new in Swift 2.x) 
    
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

