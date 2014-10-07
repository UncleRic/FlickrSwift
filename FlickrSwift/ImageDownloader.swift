//  ImageDownloader.swift
//  FlickrSwift
//
//  Created by Frederick C. Lee on 10/1/14.
//  Copyright (c) 2014 Frederick C. Lee. All rights reserved.
// -----------------------------------------------------------------------------------------------------

import Foundation
import UIKit

class ImageDownloader {
    var image:UIImage?
    var bigImage:UIImage?
    var dict:Dictionary<String,AnyObject>?
    var descString:String?
    
    init(dict:Dictionary<String,AnyObject>) {
        self.dict = dict
    }
    
    func debugDescription() -> NSString {
        let myString = NSString(format:"{ImageDownloader} desc: %@", descString!)
        return myString
    }
    
    func downloadImageAtURL(url:NSURL, completion:(image:UIImage?, error:NSError?) ->Void) {
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) {(data, response, error) in
            if let httpRes = response as? NSHTTPURLResponse {
                if httpRes.statusCode == 200 {
                    var myImage = UIImage(data:data)
                    dispatch_async(dispatch_get_main_queue(), {
                        completion(image:myImage,error:nil)
                    })
                    
                } else {
                    completion(image:nil,error:error)
                }
                
            }
        }
        
        task.resume()
    }
}





