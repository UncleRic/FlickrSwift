//  Utilities.swift
//  FlickrSwift
//
//  Created by Frederick C. Lee on 10/14/14.
//  Copyright (c) 2014 Frederick C. Lee. All rights reserved.
// -----------------------------------------------------------------------------------------------------

import Foundation

// MARK: - URL Escaped Strings

public func FKEscapedURLString(string:NSString) -> String {
    string.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
    return string
}

// -----------------------------------------------------------------------------------------------------

public func FKEscapedURLStringPlus(string:String) -> String {
    var str = CFURLCreateStringByAddingPercentEscapes(
        nil,
        string,
        nil,
        "`~!@#$^&*()=+[]\\{}|;':\",/<>?",
        CFStringBuiltInEncodings.UTF8.rawValue
    )
    return str
}

// -----------------------------------------------------------------------------------------------------
// MARK: - Unique ID

func FKGenerateUUID() -> String {
    let uuidString = NSUUID().UUIDString
    return uuidString
}


// -----------------------------------------------------------------------------------------------------
// MARK: - OAuthExtraction

public func FKQueryParamDictionaryFromURL(url:NSURL) -> [String:String]? {
    var x:String? = url.query
    if let urlString = x {
        let params = FKQueryParamDictionaryFromQueryString(urlString)
    } else {
        return nil
    }
    
    return ["key":"value"]
}


// -----------------------------------------------------------------------------------------------------

func FKQueryParamDictionaryFromQueryString(queryString:NSString) -> NSDictionary {
    let vars = queryString.componentsSeparatedByString("&") as [String]
    println("vars= \(vars)")
    var keyValues = NSMutableDictionary()
    for (val) in vars {
        let kv = val.componentsSeparatedByString("=")
        if (kv.count == 2) {
            keyValues[kv[0]] = kv[1]
        }
    }
    return keyValues
}

// -----------------------------------------------------------------------------------------------------




