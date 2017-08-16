//
//  VideoModelAllVideos.swift
//  RonaldYule
//
//  Created by Matthew Frankland on 23/07/2017.
//  Copyright © 2017 Matthew Frankland. All rights reserved.
//

import UIKit
import Alamofire

protocol videoModelDelegateOne {
    func dataReady()
}
class VideoModelAllVideos: NSObject {
    
    let API_KEY = "AIzaSyAgFNHAzAqSAvuD5_xngFw4ksL_l-I83vU"
    let UPLOAD_PLAYLIST_ID = "PLfwD-lW7ORMAEwJ9iKlhJRWyKnCFZIqAH"
    
    var videoArray = [Video]()
    
    var delegate: videoModelDelegateOne?
    
    func getFeedVideo(){
        //Fetch the videos dynamically through the YouTube API
        
        Alamofire.request("https://www.googleapis.com/youtube/v3/playlistItems", method: .get, parameters: ["part":"snippet","playlistId":UPLOAD_PLAYLIST_ID, "key":API_KEY, "maxResults":25], encoding: URLEncoding.default, headers: nil).responseJSON { (response) -> Void in
            if let JSON = response.result.value as? [String: Any]{
                
                var arrayOfVideos = [Video]()
                
                for video in JSON["items"] as! NSArray{
                    
                    //Create an object off of the JSON response
                    let videoObj = Video()
                    videoObj.videoID = (video as AnyObject).value(forKeyPath: "snippet.resourceId.videoId") as! String
                    videoObj.videoTitle = (video as AnyObject).value(forKeyPath: "snippet.title") as! String
                    videoObj.videoDescription = (video as AnyObject).value(forKeyPath: "snippet.description") as! String
                    videoObj.videoThumbnailURL = (video as AnyObject).value(forKeyPath: "snippet.thumbnails.maxres.url") as! String
                    
                    arrayOfVideos.append(videoObj)
                }
                
                //When all the video objects have been constructed, assign the array to the VideoModel property
                self.videoArray = arrayOfVideos
                
                //Notify the delegate that the videos are ready
                if self.delegate != nil{
                    self.delegate!.dataReady()
                }
            }
        }
    }
}
