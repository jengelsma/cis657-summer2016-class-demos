//
//  File.swift
//  Lecture11-FireBaseDemonstration
//
//  Created by Jonathan Engelsma on 6/7/16.
//  Copyright © 2016 Jonathan Engelsma. All rights reserved.
//

import Foundation
import Firebase


struct MyDateEntry {
    
    //let key: String!
    let name: String!
    let date: NSDate!
    
    
    init(name: String, date: NSDate, key: String = "") {
        //self.key = key
        self.name = name
        self.date = date
    }
    
    
    init(snapshot: FIRDataSnapshot) {
        let dateStringFormatter = NSDateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZZ"
        dateStringFormatter.timeZone = NSTimeZone(name: "UTC")
        
        
        //key = snapshot.key
        name = snapshot.value!["name"] as! String
        let dateStr = snapshot.value!["date"] as! String
        date = dateStringFormatter.dateFromString(dateStr)
    }
    
    
    init(snapshot: Dictionary<String,AnyObject>) {
        let dateStringFormatter = NSDateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZZ"
        dateStringFormatter.timeZone = NSTimeZone(name: "UTC")
        
        
        //key = snapshot.key
        name = snapshot["name"] as! String
        let dateStr = snapshot["date"] as! String
        date = dateStringFormatter.dateFromString(dateStr)
    }
    
    
    func toAnyObject() -> AnyObject {
        return [
            "name": name,
            "date": date.description,
        ]
    }
    
    
}