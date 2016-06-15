//
//  TodayViewController.swift
//  TodayExtension
//
//  Created by Jonathan Engelsma on 6/14/16.
//  Copyright © 2016 Jonathan Engelsma. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet weak var videoTitle1: UILabel!
    @IBOutlet weak var videoDesc1: UILabel!
    @IBOutlet weak var videoTitle2: UILabel!
    @IBOutlet weak var videoDesc2: UILabel!
    @IBOutlet weak var videoTitle3: UILabel!
    @IBOutlet weak var videoDesc3: UILabel!
    @IBOutlet weak var showMoreButton: UIButton!
    
    var expanded: Bool = false
    var objects = [AnyObject]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.preferredContentSize = CGSizeMake(0, 50)
        self.loadVideos()
    }
    
    func widgetMarginInsetsForProposedMarginInsets
        (defaultMarginInsets: UIEdgeInsets) -> (UIEdgeInsets) {
        return UIEdgeInsetsZero
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData

        completionHandler(NCUpdateResult.NewData)
    }
    
    @IBAction func showMore(sender: UIButton) {
        if self.expanded {
            self.preferredContentSize = CGSizeMake(0, 50)
            showMoreButton.transform = CGAffineTransformMakeRotation(0)
            self.expanded = false
        } else {
            self.preferredContentSize = CGSizeMake(0, 270)
            showMoreButton.transform = CGAffineTransformMakeRotation(CGFloat(180.0 * M_PI/180.0))
            self.expanded = true
        }
        
        
    }
    
    func loadVideos()
    {
        // Get ready to fetch the list of dog videos from YouTube V3 Data API.
        let url = NSURL(string: "https://www.googleapis.com/youtube/v3/search?part=snippet&maxResults=3&q=puppies&type=youtube%23video&key=\(YOUTUBE_API_KEY_GOES_HERE)")
        
        
        let session = NSURLSession.sharedSession()
        let task = session.downloadTaskWithURL(url!) {
            (loc:NSURL?, response:NSURLResponse?, error:NSError?) in
            if error != nil {
                print(error)
                return
            }
            
            
            // print out the fetched string for debug purposes.
            let d = NSData(contentsOfURL: loc!)!
            print("got data")
            let datastring = NSString(data: d, encoding: NSUTF8StringEncoding)
            print(datastring)
            
            
            // Parse the top level  JSON object.
            let parsedObject: AnyObject?
            do {
                parsedObject = try NSJSONSerialization.JSONObjectWithData(d,
                                                                          options: NSJSONReadingOptions.AllowFragments)
            } catch let error as NSError {
                print(error)
                return
            } catch {
                fatalError()
            }
            
            
            // retrieve the individual videos from the JSON document.
            if let topLevelObj = parsedObject as? Dictionary<String,AnyObject> {
                if let items = topLevelObj["items"] as? Array<Dictionary<String,AnyObject>> {
                    for i in items {
                        self.objects.append(i)
                    }
                    dispatch_async(dispatch_get_main_queue()) {
                        if self.objects.count == 3 {
                            self.updateFields()
                        }
                        
                        
                    }
                }
            }
        }
        task.resume()
        
        
    }

    func updateFields()
    {
        if let object = objects[0] as? Dictionary<String, AnyObject> {
            if let snippet = object["snippet"] as? Dictionary<String, AnyObject> {
                self.videoTitle1!.text = snippet["title"] as? String
                self.videoDesc1!.text = snippet["description"] as? String
            }
        }
        if let object = objects[1] as? Dictionary<String, AnyObject> {
            if let snippet = object["snippet"] as? Dictionary<String, AnyObject> {
                self.videoTitle2!.text = snippet["title"] as? String
                self.videoDesc2!.text = snippet["description"] as? String
            }
        }
        if let object = objects[2] as? Dictionary<String, AnyObject> {
            if let snippet = object["snippet"] as? Dictionary<String, AnyObject> {
                self.videoTitle3!.text = snippet["title"] as? String
                self.videoDesc3!.text = snippet["description"] as? String
            }
        }
    }

    @IBAction func viewMore(sender: AnyObject) {
        let url = NSURL(string: "puppyflix://")
        self.extensionContext?.openURL(url!, completionHandler: nil)
    }

    
}
