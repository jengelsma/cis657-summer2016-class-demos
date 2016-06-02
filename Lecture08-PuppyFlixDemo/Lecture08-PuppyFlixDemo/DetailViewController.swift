//
//  DetailViewController.swift
//  Lecture08-PuppyFlixDemo
//
//  Created by Jonathan Engelsma on 5/31/16.
//  Copyright © 2016 Jonathan Engelsma. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var videoTitle: UILabel!
    @IBOutlet weak var videoImage: UIImageView!
    @IBOutlet weak var videoDescription: UITextView!



    var detailItem: Dictionary<String, AnyObject>? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            if let snippet = detail["snippet"] as? Dictionary<String,AnyObject> {
                if let title = self.videoTitle {
                    title.text = snippet["title"] as? String
                }
                if let descript = self.videoDescription {
                    descript.text = snippet["description"] as? String
                }
                
                self.videoImage?.image = UIImage(named:"YouTubeIcon")
                if let images = snippet["thumbnails"] as? Dictionary<String,AnyObject> {
                    if let firstImage = images["medium"] as? Dictionary<String,AnyObject> {
                        if let imageUrl : String = firstImage["url"] as! String {
                            self.videoImage?.loadImageFromURL(NSURL(string:imageUrl), placeholderImage: self.videoImage?.image, cachingKey: imageUrl)
                        }
                    }
                }
                
            }
        }
        
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
        
        let safari : UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: self, action: #selector(DetailViewController.share))
        
        self.navigationItem.rightBarButtonItems = [safari]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func share()
    {
        if let detail = self.detailItem {
            if let ytId = detail["id"] as? NSDictionary {
                if let videoId = ytId["videoId"] as? String {
                    let url = NSURL(string: "http://www.youtube.com/watch?v=" + videoId )
                    let msg = "Check out my favorite puppy video on YouTube"
                    let items = [ msg, url! ]
                    let avc = UIActivityViewController(activityItems: items, applicationActivities: nil)
                    self.navigationController?.presentViewController(avc, animated: true, completion: nil)
                }
            }
        }
    }


}

