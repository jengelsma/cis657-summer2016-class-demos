//
//  VideoAPI.swift
//  PuppyFlix
//
//  Created by Jonathan Engelsma on 11/20/15.
//  Copyright © 2015 Jonathan Engelsma. All rights reserved.
//

import Foundation

enum VideoAPIError:ErrorType {
    
    case StatusCodeError(code: Int)
    case ParseError
    case ResponseError(error:NSError)
}

protocol VideoAPI {
    //func getVideos() -> (NSError?, [VideoInfo]?)
    func getVideos(qStr: String?, completion: ((inner: () throws -> [VideoInfo]?) -> ()));
}
