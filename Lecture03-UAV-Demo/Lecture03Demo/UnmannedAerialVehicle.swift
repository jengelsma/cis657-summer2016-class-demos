//
//  UnmannedAerialVehicle.swift
//  Lecture03Demo
//
//  Created by Jonathan Engelsma on 5/17/16.
//  Copyright © 2016 Jonathan Engelsma. All rights reserved.
//

import Foundation

protocol SelfHomingUAV {
    func goHome() -> Void
}


class UnmannedAerialVehicle : SelfHomingUAV {
    var batteryCharge: Int
    
    init(battery: Int) {
        self.batteryCharge = battery
    }

    func takeOff() {
        for i in (1...4) {
            print("Engine \(i) is powered.")
        }
        print("UAV is now airbourne")
    }
    
    func programmableTakeOff(instructions: (Int) -> Void) {
        instructions(self.batteryCharge)
        print("UAV is now airbourne")
    }
    
    func goHome() {
        print("got it... aircraft has returned to origin")
    }



}
