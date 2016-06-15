//
//  InterfaceController.swift
//  AppleWatchApp Extension
//
//  Created by Jonathan Engelsma on 6/14/16.
//  Copyright © 2016 Jonathan Engelsma. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    @IBOutlet var greeting: WKInterfaceLabel!
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    @IBAction func setGreeting() {
        self.greeting.setText("Hello there!")
    }

}
