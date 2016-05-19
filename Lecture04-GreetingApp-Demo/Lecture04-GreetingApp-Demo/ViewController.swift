//
//  ViewController.swift
//  Lecture04-GreetingApp-Demo
//
//  Created by Jonathan Engelsma on 5/19/16.
//  Copyright © 2016 Jonathan Engelsma. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var greetingLabel: UILabel!
    
    // this is our model
    var greeting :String = "Stony and Awkward silence!"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.greetingLabel.text = self.greeting
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func greetButtonPressed(sender: UIButton) {
        self.greeting = "A warm welcome to you sir!"
        self.greetingLabel.text = self.greeting
    }

}

