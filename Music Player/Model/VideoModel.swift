//
//  Video.swift
//  Music Player
//
//  Created by Eugene Lu on 2018-05-17.
//  Copyright © 2018 Eugene Lu. All rights reserved.
//

import UIKit

struct Video {
    let title: String
    let thumbnailURL: String
}

class VideoModel : NSObject {
    let apiKey = "AIzaSyCKx6f39vFN84qnGM6x2s_tyPzLwoN2cnA"
    var videos = [Video]()
    
    func getTrendingSongs() {
        //Fetch trending music videos from Youtube API
        //Parameters
        let part = "snippet"
        let chart = "mostPopular"
        let videoCategoryId = "10"
        let regionCode = "US"
        
        let youtubeApi = "https://www.googleapis.com/youtube/v3/videos?part=\(part)&chart=\(chart)&videoCategoryId=\(videoCategoryId)&regionCode=\(regionCode)&key=\(apiKey)"
        guard let url = URL(string: youtubeApi) else {return}
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {return}
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String : AnyObject] {
                    for videoObject in json["items"] as! NSArray {
                        let videoInfo = videoObject as! [String: AnyObject]
                        let snippet = videoInfo["snippet"] as! [String: AnyObject]
                        let videoTitle = snippet["title"] as! String
                        let thumbnails = snippet["thumbnails"] as! [String: AnyObject]
                        let defaultSizeThumbnail = thumbnails["default"] as! [String: AnyObject]
                        let thumbnailURL = defaultSizeThumbnail["url"] as! String
                        let video = Video(title: videoTitle, thumbnailURL: thumbnailURL)
                        self.videos.append(video)
                    }
                }
            }
            catch {
                print("json error: \(error)")
            }
            
        }.resume()
    }
}