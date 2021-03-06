//
//  YoutubeModel.swift
//  MakeUp App
//
//  Created by Raquel Rahmey on 4/5/17.
//  Copyright © 2017 Raquel Rahmey. All rights reserved.
//

import Foundation
import SwiftyJSON

class Youtube {
    var eTag: String
    var videoID: String
    var channelID: String
    var channelTitle: String
    var title: String
    var thumbnailURL: String
    var thumbnailWidth: Int
    var thumbnailHeight: Int
    var videoType: String
    var publishedAt: String
    var savedAt: String

    
    init(dictionary:JSON, videoType:String) {
        eTag = dictionary["etag"].stringValue
        
        // account for two methods of retrieving youtube, maybe there's a better way to do this but probably not
        videoID = dictionary["id"]["videoId"].stringValue
        if videoID == "" {
            videoID = dictionary["id"].stringValue
        }
        
        channelID = dictionary["snippet"]["channelId"].stringValue
        channelTitle = dictionary["snippet"]["channelTitle"].stringValue
        title = dictionary["snippet"]["title"].stringValue
        thumbnailURL = dictionary["snippet"]["thumbnails"]["high"]["url"].stringValue
        thumbnailWidth = dictionary["snippet"]["thumbnails"]["default"]["width"].intValue
        thumbnailHeight = dictionary["snippet"]["thumbnails"]["default"]["height"].intValue
        publishedAt = dictionary["snippet"]["publishedAt"].stringValue
        self.videoType = videoType
        
        savedAt = "Never Saved"
    }
    
    
    
}
 
