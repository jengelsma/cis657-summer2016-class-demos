//
//  DetailViewController.swift
//  PuppyFlix
//
//  Created by Jonathan Engelsma on 10/14/15.
//  Copyright © 2015 Jonathan Engelsma. All rights reserved.
//

import UIKit
import TUSafariActivity

class DetailViewController: UIViewController {

    @IBOutlet weak var videoTitle: UILabel!
    @IBOutlet weak var videoImage: UIImageView!
    @IBOutlet weak var videoDescription: UITextView!



    var detailItem: VideoInfo? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            if let title = self.videoTitle {
                title.text = detail.title
            }
            if let descript = self.videoDescription {
                descript.text = detail.description
            }
            
            if let videoImage = self.videoImage {
                videoImage.image = UIImage(named:"YouTubeIcon")
                videoImage.loadImageFromURL(NSURL(string:detail.mediumImageUrl!), placeholderImage: videoImage.image, cachingKey: detail.mediumImageUrl)
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
            
            let url = NSURL(string: "http://www.youtube.com/watch?v=" + detail.id )
            let msg = "Check out my favorite puppy video on YouTube"
            let items = [ msg, url! ]
                    
            // add this after you add the cocoa pod:
            let activity = TUSafariActivity()
                    
            let avc = UIActivityViewController(activityItems: items, applicationActivities: [activity])
            self.navigationController?.presentViewController(avc, animated: true, completion: nil)
        }
    }
}

