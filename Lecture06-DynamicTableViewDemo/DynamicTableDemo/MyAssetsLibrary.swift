//
//  MyAssetsLibrary.swift
//  DynamicTableDemo
//
//  Created by Jonathan Engelsma on 5/24/16.
//  Copyright © 2016 Jonathan Engelsma. All rights reserved.
//

import UIKit
import AssetsLibrary

class MyAssetsLibrary: ALAssetsLibrary {
    static let singleton = MyAssetsLibrary()
    
    class func defaultInstance() -> MyAssetsLibrary
    {
        return singleton
    }
}
