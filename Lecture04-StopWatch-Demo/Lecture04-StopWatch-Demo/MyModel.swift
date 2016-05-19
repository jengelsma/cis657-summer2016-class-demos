//
//  MyModel.swift
//  Lecture04-StopWatch-Demo
//
//  Created by Jonathan Engelsma on 5/19/16.
//  Copyright © 2016 Jonathan Engelsma. All rights reserved.
//

import Foundation

struct MyModel {
    var startTime: NSDate
    var pauseTime: NSDate
    var nightMode: Bool = false
    var timing: Bool = false
    var stopWatchTimer: NSTimer
    
    
    init() {
        startTime = NSDate()
        pauseTime = NSDate()
        stopWatchTimer = NSTimer()
    }
    
    
}

