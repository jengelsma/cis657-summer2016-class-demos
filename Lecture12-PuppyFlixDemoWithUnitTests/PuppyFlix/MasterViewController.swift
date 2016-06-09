//
//  MasterViewController.swift
//  PuppyFlix
//
//  Created by Jonathan Engelsma on 10/14/15.
//  Copyright © 2015 Jonathan Engelsma. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var Action = UIAlertAction.self
    var detailViewController: DetailViewController? = nil
    var videos = [VideoInfo]()
    var videoAPI: VideoAPI?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        self.loadVideoData()
    }

    override func viewWillAppear(animated: Bool) {
        if self.splitViewController != nil {
            self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        }
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func loadVideoData() {
        
        self.videoAPI!.getVideos("puppy") { [weak self] (inner) -> () in
            
            if let strongSelf = self {
                do {
                    
                    //try to get video data
                    let videos = try inner()
                    
                    //load table with earthquake data
                    strongSelf.videos = videos!
                    dispatch_async(dispatch_get_main_queue(),{ _ in
                        (UIApplication.sharedApplication().delegate as! AppDelegate).decrementNetworkActivity()
                        strongSelf.tableView.reloadData()

                    })
                } catch let error {
                    
                    //catch exception and present error
                    print("Error occurred - \(error)")
                    dispatch_async(dispatch_get_main_queue(),{ _ in
                        strongSelf.showAlertError()
                    })
                }
            }
        }
    }
    
    func showAlertError() {
        
        let alert = UIAlertController(title: "Error", message: "An error occurred while trying to fetch YouTube videos.  Press button below to try again", preferredStyle: UIAlertControllerStyle.Alert)
        let action = Action.init(title: "Try Again", style: UIAlertActionStyle.Default, handler: { [weak self](alert: UIAlertAction!)  -> () in
            
            if let strongSelf = self {
                strongSelf.loadVideoData()
            }
            })
        alert.addAction(action)
        self.presentViewController(alert, animated: true, completion: nil)
    }

   
    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let video : VideoInfo = self.videos[indexPath.row]
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = video
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.videos.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        // setup text.
        let video : VideoInfo = self.videos[indexPath.row]
        cell.textLabel!.text = video.title
        cell.detailTextLabel!.text = video.description

        // fetch image
        cell.imageView?.image = UIImage(named:"YouTubeIcon")
        cell.imageView?.loadImageFromURL(NSURL(string:video.smallImageUrl!), placeholderImage: cell.imageView?.image, cachingKey: video.smallImageUrl)

        return cell
    }


}

