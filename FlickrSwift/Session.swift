//  Session.swift
//  FlickrSwift
//
//  Created by Frederick C. Lee on 9/30/14.
//  Copyright (c) 2014 Frederick C. Lee. All rights reserved.
// -----------------------------------------------------------------------------------------------------

import Foundation
import Alamofire

func fetchFlickrPhotoWithSearchString(searchString:String) {
    
    let url = getURLForString("Ric")
    
    Alamofire.request(.GET,url)
        .responseString {(request, response, string, error) in
            // Need to remove some flickr garbage from the result:
            let string = stringByRemovingFlickrJavaScriptFromString(string!)
            let data = string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
            let JSON: AnyObject? = NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments, error: nil)
            
            let smirf = JSON as Dictionary<String,AnyObject>!
            let photos: AnyObject? = smirf["photos"]
            gPhotoData = (photos!["photo"] as Array<Dictionary<String,AnyObject>>)
            
            dispatch_async(dispatch_get_main_queue(), {
                collectionView.reloadData()
            })

    }
}

