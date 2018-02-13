//  Utilities.swift
//  FlickrSwift
//
//  Created by Frederick C. Lee on 10/14/14.
//  Copyright (c) 2014 Frederick C. Lee. All rights reserved.
// -----------------------------------------------------------------------------------------------------

import Foundation

// MARK: - URL Escaped Strings

public func FKEscapedURLString(_ string:NSString) -> String {
    string.addingPercentEscapes(using: String.Encoding.utf8.rawValue)
    return string as String
}

// -----------------------------------------------------------------------------------------------------

public func FKEscapedURLStringPlus(_ string:String) -> String {
    let str = CFURLCreateStringByAddingPercentEscapes(
        nil,
        string as CFString,
        nil,
        "`~!@#$^&*()=+[]\\{}|;':\",/<>?" as CFString,
        CFStringBuiltInEncodings.UTF8.rawValue
    )
    return str as! String
}

// -----------------------------------------------------------------------------------------------------
// MARK: - Unique ID

func FKGenerateUUID() -> String {
    let uuidString = UUID().uuidString
    return uuidString
}


// -----------------------------------------------------------------------------------------------------
// MARK: - OAuthExtraction

public func FKQueryParamDictionaryFromURL(_ url:URL) -> [String:String]? {
    let x:String? = url.query
    if let urlString = x {
        let params = FKQueryParamDictionaryFromQueryString(urlString as NSString)
    } else {
        return nil
    }
    
    return ["key":"value"]
}


// -----------------------------------------------------------------------------------------------------

func FKQueryParamDictionaryFromQueryString(_ queryString:NSString) -> NSDictionary {
    let vars = queryString.components(separatedBy: "&") as [String]
    print("vars= \(vars)")
    let keyValues = NSMutableDictionary()
    for (val) in vars {
        let kv = val.components(separatedBy: "=")
        if (kv.count == 2) {
            keyValues[kv[0]] = kv[1]
        }
    }
    return keyValues
}

// -----------------------------------------------------------------------------------------------------




