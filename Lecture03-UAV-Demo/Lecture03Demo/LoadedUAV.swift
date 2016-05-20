//
//  LoadedUAV.swift
//  Lecture03Demo
//
//  Created by Jonathan Engelsma on 5/17/16.
//  Copyright © 2016 Jonathan Engelsma. All rights reserved.
//

import Foundation

class LoadedUAV : UnmannedAerialVehicle {
    var payloadWeight : Int
    var payloadDesc: String?
    
    convenience init(battery:Int, weight:Int) {
        self.init(battery: battery, weight:weight, desc:"a default payload")
    }
    
    // designated Initializer
    init(battery:Int, weight:Int, desc:String?)
    {
        self.payloadWeight = weight
        self.payloadDesc = desc
        super.init(battery: battery)
    }
    
    override func programmableTakeOff(instructions: (Int) -> Void) {
        instructions(self.batteryCharge)
        print("UAV is now airbourne with payload: " + self.payloadDesc! + " and weight=\(self.payloadWeight)" )
    }
    
    
}
