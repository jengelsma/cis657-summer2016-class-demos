//
//  ViewController.swift
//  URLSchemeRunner
//
//  Created by Jonathan Engelsma on 6/14/16.
//  Copyright © 2016 Jonathan Engelsma. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func launchCustomApp(sender: AnyObject) {
        let url = NSURL(string: "customdemoapp://")
        UIApplication.sharedApplication().openURL(url!)
    }

    @IBAction func launchGoogleMaps(sender: AnyObject) {
        if (UIApplication.sharedApplication().canOpenURL(NSURL(string:"comgooglemaps://")!)) {
            UIApplication.sharedApplication().openURL(NSURL(string:
                "comgooglemaps://?center=42.964188,-85.677409&zoom=14&views=traffic")!)
        } else {
            print("Can't use comgooglemaps://");
        }
    }


}

