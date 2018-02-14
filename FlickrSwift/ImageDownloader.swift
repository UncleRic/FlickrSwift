//  ImageDownloadItem.swift
//  FlickrSwift
//
//  Created by Frederick C. Lee on 10/1/14.
//  Copyright (c) 2014 Frederick C. Lee. All rights reserved.
// -----------------------------------------------------------------------------------------------------

import Foundation
import UIKit

class ImageDownloadItem {
    var image:UIImage?
    var bigImage:UIImage?
    var dict:Dictionary<String,AnyObject>?
    var descString:String?
    
    init(dict:Dictionary<String,AnyObject>) {
        self.dict = dict
    }
    
    func debugDescription() -> NSString {
        let myString = NSString(format:"{ImageDownloadItem} desc: %@", descString!)
        return myString
    }
    
    func downloadImageAtURL(_ url:URL, completion:@escaping (_ image:UIImage?, _ error:NSError?) ->Void) {
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: {(data, response, error) in
            if let httpRes = response as? HTTPURLResponse {
                if httpRes.statusCode == 200 {
                    let myImage = UIImage(data:data!)
                    DispatchQueue.main.async(execute: {
                        completion(myImage,nil)
                    })
                    
                } else {
                    completion(nil,error as! NSError)
                }
                
            }
        }) 
        
        task.resume()
    }
}

