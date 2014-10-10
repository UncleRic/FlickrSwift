//  Flickr.swift
//  FlickrSwift
//
//  Created by Frederick C. Lee on 9/29/14.
//  Copyright (c) 2014 Frederick C. Lee. All rights reserved.
// -----------------------------------------------------------------------------------------------------

import Foundation

let flickrAPIKey = "ebbefd0c0a07c996f7867f014778adf7"
let flickrAPISecret = "bf823c361bc6f09e"

let flickrBaseURL = "https://api.flickr.com/services/rest/?format=json&"

// ------------------------------------------------------------------------------------
// The Flickr API uses different parameter names.
// Instead of the Flickr API parameter names being hard-coded throughout, they are defined here as macros.
// The Flickr API parameters are defined as query string parameters on the HTTP GET request.

let flickrParamMethod = "method"
let flickrParamAppKey = "api_key"
let flickrParamUsername = "username"
let flickrParamUserid = "user_id"
let flickrParamPhotoSetId = "photoset_id"
let flickrParamExtras = "extras"
let flickrParamText = "text"
// ------------------------------------------------------------------------------------
//The Flickr API includes a parameter named method.
// This parameter defines which API method is called.
// The API methods supported by this simple wrapper are defined here as macros.

let flickrMethodFindByUsername = "flickr.people.findByUsername"
let flickrMethodGetPhotoSetList = "flickr.photosets.getList"
let flickrMethodGetPhotosWithPhotoSetId = "flickr.photosets.getPhotos"
let flickrMethodSearchPhotos = "flickr.photos.search"

// =======================================================================================================================


public func getURLForString(str:String) -> NSURL {
    let parameters = [flickrParamMethod : flickrMethodSearchPhotos,
        flickrParamAppKey : flickrAPIKey,
        flickrParamText : str, flickrParamExtras : "url_t, url_s, url_m, url_sq"]
    
    let url = buildFlickrURLWithParameters(parameters)
    
    return url
}


// -----------------------------------------------------------------------------------------------------

func buildFlickrURLWithParameters(parameters:Dictionary<String,String>) -> NSURL {
    var urlString = flickrBaseURL
    for (key,value) in parameters {
        urlString += key+"="+value+"&"
    }
    
    urlString = urlString.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
    var url = NSURL(string:urlString)
    
    return url!
}

// -----------------------------------------------------------------------------------------------------

func stringWithData(data:NSData) -> String {
    let result = NSString(data:data, encoding:NSUTF8StringEncoding)
    return result!
}

// -----------------------------------------------------------------------------------------------------

func stringByRemovingFlickrJavaScriptFromData(data:NSData) -> String {
    let myRange = NSMakeRange(0, 100)
    let myString = stringWithData(data) as NSString
    var mutableString = NSMutableString(string: myString)
    var range = NSMakeRange(0, "jsonFlickrApi(".length)
    mutableString.deleteCharactersInRange(range)
    
    // -------------------------------------------------
    // ...every so often, a remaining '(' screws up the JSON parser.  So test again & remove it:
    range = NSMakeRange(0, 1)
    if mutableString.substringWithRange(range) == "(" {
        mutableString.deleteCharactersInRange(range)
    }
    
    // -------------------------------------------------
    // ...delete the trailing ')' character
    range = NSMakeRange(mutableString.length - 1,1)
    mutableString.deleteCharactersInRange(range)
    
    return mutableString
}

// -----------------------------------------------------------------------------------------------------

func stringByRemovingFlickrJavaScriptFromString(str:String) -> String {
    var mutableString = NSMutableString(format: str)
    var range = NSMakeRange(0, "jsonFlickrApi(".length)
    mutableString.deleteCharactersInRange(range)
    range = NSMakeRange(mutableString.length - 1,1)
    mutableString.deleteCharactersInRange(range)
    return mutableString
}


// -----------------------------------------------------------------------------------------------------







