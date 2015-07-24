//  Session.swift
//  FlickrSwift
//
//  Created by Frederick C. Lee on 9/30/14.
//  Copyright (c) 2014 Frederick C. Lee. All rights reserved.
// -----------------------------------------------------------------------------------------------------

import Foundation

public enum FKHttpMethod:Int {
    case FKHttpMethodGET = 0
    case FKHttpMethodPOST
}

//public enum FKPermission:Int {
//    case FKPermissionRead
//    case FKPermissionWrite
//    case FKPermissionDelete
//    func description() ->String {
//        switch self {
//        case .FKPermissionRead:
//            return "READ"
//        case .FKPermissionWrite:
//            return "WRITE"
//        case .FKPermissionDelete:
//            return "DELETE"
//        }
//    }
//}

public enum FKPhotoSize:Int {
    case FKPhotoSizeUnknown = 0
    case FKPhotoSizeCollectionIconLarge
    case FKPhotoSizeBuddyIcon
    case FKPhotoSizeSmallSquare75
    case FKPhotoSizeLargeSquare150
    case FKPhotoSizeThumbnail100
    case FKPhotoSizeSmall240
    case FKPhotoSizeSmall320
    case FKPhotoSizeMedium500
    case FKPhotoSizeMedium640
    case FKPhotoSizeMedium800
    case FKPhotoSizeLarge1024
    case FKPhotoSizeLarge1600
    case FKPhotoSizeLarge2048
    case FKPhotoSizeOriginal
    case FKPhotoSizeVideoOriginal
    case FKPhotoSizeVideoHDMP4
    case FKPhotoSizeVideoSiteMP4
    case FKPhotoSizeVideoMobileMP4
    case FKPhotoSizeVideoPlayer
}

// -----------------------------------------------------------------------------------------------------
// MARK:- URL Encryption

public func oauthURLFromBaseURL(inURL:NSURL, method:FKHttpMethod, params:[String:String]) -> NSURL {
    let newArgs:Dictionary = signedOAuthHTTPQueryParameters(params, baseURL: inURL, method: method)
    var queryArray = NSMutableArray()
    for (key,value) in newArgs {
        let y = FKEscapedURLStringPlus(value)
        queryArray.addObject("\(key)=\(y)")
    }
    
    let x = "hello";let y = "world"
    let newURLStringWithQuery = "\(x)?\(y)"
    
    let urlString = NSURL(string: newURLStringWithQuery)
    return inURL
    
//    NSDictionary *newArgs = [self signedOAuthHTTPQueryParameters:params baseURL:inURL method:method];
//    NSMutableArray *queryArray = [NSMutableArray array];
//    
//    for (NSString *key in newArgs) {
//        [queryArray addObject:[NSString stringWithFormat:@"%@=%@", key, FKEscapedURLStringPlus(newArgs[key])]];
//    }
//    
//    NSString *newURLStringWithQuery = [NSString stringWithFormat:@"%@?%@", [inURL absoluteString], [queryArray componentsJoinedByString:@"&"]];
//    
//    return [NSURL URLWithString:newURLStringWithQuery];

}

private func signedOAuthHTTPQueryParameters(params:[String:String], baseURL:NSURL, method:FKHttpMethod) -> [String:String] {
    let x = ["Hello":"World"]
    return x
}



// -----------------------------------------------------------------------------------------------------
// MARK: - Create query string from args and sign it

func signedQueryStringFromParameters(params:[String:String]) -> String {
    let x = "hello"
    return x
}

// -----------------------------------------------------------------------------------------------------
// MARK: - Args as array

func signedArgsFromParameters(params:[String:String], method:FKHttpMethod, url:NSURL) -> [String:String] {
    let x = ["key":"value"]
    return x
}



// -----------------------------------------------------------------------------------------------------
// MARK: -
// (1)...counterpart to (2) ref-to-func() "callback"
func fetchResponseForRequest(url:NSURL, completion:(statusCode:Int?, string:String?, error:NSError?) ->Void) {
    
    let task = NSURLSession.sharedSession().dataTaskWithURL(url) {(data, response, error) in
        if let httpRes = response as? NSHTTPURLResponse {
            if httpRes.statusCode == 200 {
                let result = NSString(data: data!, encoding: NSUTF8StringEncoding) as String?
                dispatch_async(dispatch_get_main_queue(), {
                    completion(statusCode: httpRes.statusCode, string:result, error: nil)
                })
            } else {
                let statusCode = "Status Code: \(httpRes.statusCode)"
                completion(statusCode:httpRes.statusCode, string:statusCode,error:error)
            }
        } else {
            completion(statusCode:nil, string:"*** session Errror ***",error:error)
        }
    }
    
    task.resume()
    
}
