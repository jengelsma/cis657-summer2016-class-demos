//
//  ViewController.swift
//  Lecture04-LifeCycle-Demo
//
//  Created by Jonathan Engelsma on 5/19/16.
//  Copyright © 2016 Jonathan Engelsma. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Calling \(#function) in ViewController")
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print("Calling \(#function) in ViewController")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print("Calling \(#function) in ViewController")
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        print("Calling \(#function) in ViewController")
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        print("Calling \(#function) in ViewController")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

