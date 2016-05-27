//
//  LSViewController.swift
//  Lecture07-AutoRotateDemo
//
//  Created by Jonathan Engelsma on 5/26/16.
//  Copyright © 2016 Jonathan Engelsma. All rights reserved.
//

import UIKit

class LSViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(LSViewController.handleSwipes(_:)))
        rightSwipe.direction = .Right
        self.view.addGestureRecognizer(rightSwipe)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        
        return UIInterfaceOrientationMask.Landscape
    }

    func handleSwipes(sender: UISwipeGestureRecognizer) {
        if sender.direction == .Right {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
