//
//  StreamViewController.swift
//  Lecture09-SocialDemo
//
//  Created by Jonathan Engelsma on 6/2/16.
//  Copyright © 2016 Jonathan Engelsma. All rights reserved.
//

import UIKit
import Accounts
import Social

class StreamViewController: UITableViewController {

    var account: ACAccount!
    var updates: NSArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.retrieveTweetStream()
        let tweetButton  = UIBarButtonItem(barButtonSystemItem: .Compose, target: self, action: "postTweet")
        self.navigationItem.rightBarButtonItem = tweetButton
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func retrieveTweetStream()
    {
        let url = NSURL(string: "https://api.twitter.com/1.1/statuses/user_timeline.json")
        let params : [NSObject:AnyObject]! = ["screen_name" : self.account.username]
        let request : SLRequest = SLRequest(forServiceType: SLServiceTypeTwitter,
                                            requestMethod: SLRequestMethod.GET, URL: url, parameters: params)
        request.account = self.account
        request.performRequestWithHandler { (response: NSData!, urlResponse: NSHTTPURLResponse!, error:NSError!) -> Void in
            if urlResponse.statusCode == 200 {
                
                let parsedObject: AnyObject?
                do {
                    parsedObject = try NSJSONSerialization.JSONObjectWithData(response,
                        options: NSJSONReadingOptions.AllowFragments)
                } catch _ as NSError {
                    parsedObject = nil
                } catch {
                    fatalError()
                }
                if (parsedObject != nil) {
                    if let topLevelObj = parsedObject as? NSArray {
                        self.updates = topLevelObj
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.tableView.reloadData()
                        })
                    }
                }
            }
        }
        
    }
    

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.updates != nil {
            return self.updates.count
        } else {
            return 0
        }
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        let update : Dictionary<String,AnyObject> =  self.updates[indexPath.row] as! Dictionary<String,AnyObject>
        cell.textLabel!.text = update["text"] as? String
        cell.detailTextLabel!.text = update["user"]!["name"]! as? String
        return cell
    }

    func postTweet()
    {
        let view: SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        view.setInitialText("Hello CIS 657!")
        view.addURL(NSURL(string:"http://masl.cis.gvsu.edu"))
        self.presentViewController(view, animated: true, completion: nil)
    }

    @IBAction func refreshTweets(sender: UIRefreshControl) {
        self.retrieveTweetStream()
        sender.endRefreshing()
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
