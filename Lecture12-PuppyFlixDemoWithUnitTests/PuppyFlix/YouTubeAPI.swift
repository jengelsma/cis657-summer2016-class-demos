//
//  YouTubeAPI.swift
//  PuppyFlix
//
//  Created by Jonathan Engelsma on 11/20/15.
//  Copyright © 2015 Jonathan Engelsma. All rights reserved.
//

import Foundation


class YouTubeAPI : VideoAPI {
    
    //singleton variable for YouTubeAPI
    static let sharedInstance : VideoAPI = YouTubeAPI()
    
    init() {}
    
    static let url : String = "https://www.googleapis.com/youtube/v3/search?part=snippet&maxResults=30&type=youtube%23video&key=\(YOUTUBE_API_KEY_GOES_HERE)"
    
    private var videos = [VideoInfo]()
    
    func getVideos(qStr: String?, completion: ((inner: () throws -> [VideoInfo]?) -> ())) {
        
        
        let urlStr = YouTubeAPI.url + "&q=" + qStr!
        print(urlStr)
        if let ytUrl = NSURL(string: urlStr) {
            let request = NSURLRequest(URL: ytUrl)
            let session = NSURLSession.sharedSession()
            
            //send request to get earthquake data asynchronously with completion
            session.dataTaskWithRequest(request, completionHandler: { [weak self] (data, response, error) -> Void in
                
                if let strongSelf = self {
                    
                    //throw error in completion upon error
                    if let error = error {
                        completion(inner: {throw VideoAPIError.ResponseError(error: error)})
                        return
                    }
                    
                    //check for status error in response and throw error if found
                    if let response = response, httpResponse = response as? NSHTTPURLResponse {
                        if httpResponse.statusCode < 200 || httpResponse.statusCode > 399 {
                            completion(inner: {throw VideoAPIError.StatusCodeError(code: httpResponse.statusCode)})
                            return
                        }
                    }
                    
                    //parse video data
                    if let data = data {
                        
                        //reset video list
                        strongSelf.videos = [VideoInfo]()
                        
                        print("got data")
                        //let datastring = NSString(data: data, encoding: NSUTF8StringEncoding)
                        //print(datastring)
                        let parsedObject: AnyObject?
                        do {
                            parsedObject = try NSJSONSerialization.JSONObjectWithData(data,
                                options: NSJSONReadingOptions.AllowFragments)
                            
                            if let topLevelObj = parsedObject as? NSDictionary {
                                if let items = topLevelObj.objectForKey("items") as? NSArray {
                                    for i in items {
                                        var id : String? = nil;
                                        
                                        // extract the video id.
                                        if let ytId = i["id"] as? NSDictionary {
                                            if let videoId = ytId["videoId"] as? String {
                                                id = videoId
                                            }
                                        }
                                        
                                        let snippet = i["snippet"] as! NSDictionary
                                        let title = snippet["title"] as? String
                                        let desc = snippet["description"] as? String
                                        
                                        var sImgUrl : String? = nil
                                        var mImgUrl : String? = nil
                                        if let images = snippet["thumbnails"] as? NSDictionary {
                                            if let firstImage = images["default"] as? NSDictionary {
                                                if let imageUrl = firstImage["url"] as? String {
                                                    sImgUrl = imageUrl;
                                                }
                                            }
                                            if let mediumImage = images["medium"] as? NSDictionary {
                                                if let imageUrl = mediumImage["url"] as? String {
                                                    mImgUrl = imageUrl;
                                                }
                                            }
                                            
                                        }
                                        
                                        
                                        strongSelf.videos.append( VideoInfo(id: id!, title: title!, description: desc!, smallImageUrl: sImgUrl, mediumImageUrl: mImgUrl))
                                    }
                                }
                            }
                            
                            
                        } catch let error as NSError {
                            print(error)
                            completion(inner: {throw VideoAPIError.ParseError})
                            return
                        } catch {
                            //fatalError()
                            completion(inner: {throw VideoAPIError.ParseError})
                            return
                        }
                        
                    }
                    //call completion
                    completion(inner: {return strongSelf.videos})
                }
            }).resume()
        }
    }
    
}