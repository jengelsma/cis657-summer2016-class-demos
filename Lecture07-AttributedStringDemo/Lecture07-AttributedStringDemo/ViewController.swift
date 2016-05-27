//
//  ViewController.swift
//  Lecture07-AttributedStringDemo
//
//  Created by Jonathan Engelsma on 5/26/16.
//  Copyright © 2016 Jonathan Engelsma. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var body: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func underlineOn(sender: AnyObject) {
        self.body.textStorage.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.StyleDouble.rawValue, range: self.body.selectedRange)

        
    }
    
    @IBAction func underlineOff(sender: AnyObject) {
        self.body.textStorage.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.StyleNone.rawValue, range: self.body.selectedRange)

    }
    

    @IBAction func setColor(sender: UIButton) {
        self.body.textStorage.addAttribute(NSForegroundColorAttributeName, value: sender.backgroundColor!, range: self.body.selectedRange)
    }

}

