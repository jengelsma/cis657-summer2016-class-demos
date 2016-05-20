//
//  main.swift
//  Lecture03Demo
//
//  Created by Jonathan Engelsma on 5/17/16.
//  Copyright © 2016 Jonathan Engelsma. All rights reserved.
//

import Foundation

var uav : UnmannedAerialVehicle =   UnmannedAerialVehicle(battery: 89)
//uav.takeOff()

uav.programmableTakeOff { (Int) -> Void in
    for i in (1...4).reverse() {
        print("Engine \(i) is powered.")
    }
    for i in (1...2).reverse() {
        print("Sonar \(i) is tested.")
    }
}

uav.goHome()

var luav : LoadedUAV = LoadedUAV(battery: 10, weight: 1000, desc:"Fancy")
luav.programmableTakeOff { (Int) -> Void in
    for i in (1...4).reverse() {
        print("Engine \(i) is powered.")
    }
    for i in (1...2).reverse() {
        print("Sonar \(i) is tested.")
    }
}



