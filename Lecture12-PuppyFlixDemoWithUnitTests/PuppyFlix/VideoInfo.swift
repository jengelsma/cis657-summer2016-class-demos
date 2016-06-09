//
//  VideoInfo.swift
//  PuppyFlix
//
//  Created by Jonathan Engelsma on 11/20/15.
//  Copyright © 2015 Jonathan Engelsma. All rights reserved.
//

import Foundation

class VideoInfo : Equatable {
    let id:String
    let title:String
    let description:String
    let smallImageUrl:String?
    let mediumImageUrl:String?
    
    init(id: String, title: String, description: String, smallImageUrl: String?, mediumImageUrl: String?) {
        self.id = id;
        self.title = title;
        self.description = description
        self.smallImageUrl = smallImageUrl
        self.mediumImageUrl = mediumImageUrl
    }
    
}

func ==(lhs: VideoInfo, rhs: VideoInfo) -> Bool {
    
    return lhs.id == rhs.id &&
        lhs.title == rhs.title &&
        lhs.description == rhs.description &&
        lhs.smallImageUrl == rhs.smallImageUrl &&
        lhs.mediumImageUrl == rhs.mediumImageUrl
}


