//  Session.swift
//  FlickrSwift
//
//  Created by Frederick C. Lee on 9/30/14.
//  Copyright (c) 2014 Frederick C. Lee. All rights reserved.
// -----------------------------------------------------------------------------------------------------

import Foundation

public enum FKHttpMethod:Int {
    case fkHttpMethodGET = 0
    case fkHttpMethodPOST
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
    case fkPhotoSizeUnknown = 0
    case fkPhotoSizeCollectionIconLarge
    case fkPhotoSizeBuddyIcon
    case fkPhotoSizeSmallSquare75
    case fkPhotoSizeLargeSquare150
    case fkPhotoSizeThumbnail100
    case fkPhotoSizeSmall240
    case fkPhotoSizeSmall320
    case fkPhotoSizeMedium500
    case fkPhotoSizeMedium640
    case fkPhotoSizeMedium800
    case fkPhotoSizeLarge1024
    case fkPhotoSizeLarge1600
    case fkPhotoSizeLarge2048
    case fkPhotoSizeOriginal
    case fkPhotoSizeVideoOriginal
    case fkPhotoSizeVideoHDMP4
    case fkPhotoSizeVideoSiteMP4
    case fkPhotoSizeVideoMobileMP4
    case fkPhotoSizeVideoPlayer
}

// -----------------------------------------------------------------------------------------------------
// MARK:- URL Encryption

public func oauthURLFromBaseURL(_ inURL:URL, method:FKHttpMethod, params:[String:String]) -> URL {
    let newArgs:Dictionary = signedOAuthHTTPQueryParameters(params, baseURL: inURL, method: method)
    var queryArray = NSMutableArray()
    for (key,value) in newArgs {
        let y = FKEscapedURLStringPlus(value)
        queryArray.add("\(key)=\(y)")
    }
    
    let x = "hello";let y = "world"
    let newURLStringWithQuery = "\(x)?\(y)"
    
    let urlString = URL(string: newURLStringWithQuery)
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

private func signedOAuthHTTPQueryParameters(_ params:[String:String], baseURL:URL, method:FKHttpMethod) -> [String:String] {
    let x = ["Hello":"World"]
    return x
}



// -----------------------------------------------------------------------------------------------------
// MARK: - Create query string from args and sign it

func signedQueryStringFromParameters(_ params:[String:String]) -> String {
    let x = "hello"
    return x
}

// -----------------------------------------------------------------------------------------------------
// MARK: - Args as array

func signedArgsFromParameters(_ params:[String:String], method:FKHttpMethod, url:URL) -> [String:String] {
    let x = ["key":"value"]
    return x
}



// -----------------------------------------------------------------------------------------------------
// MARK: -
// (1)...counterpart to (2) ref-to-func() "callback"
func fetchResponseForRequest(_ url:URL, completion:@escaping (_ statusCode:Int?, _ string:String?, _ error:NSError?) ->Void) {
    
    let task = URLSession.shared.dataTask(with: url, completionHandler: {(data, response, error) in
        if let httpRes = response as? HTTPURLResponse {
            if httpRes.statusCode == 200 {
                let result = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) as String?
                DispatchQueue.main.async(execute: {
                    completion(httpRes.statusCode, result, nil)
                })
            } else {
                let statusCode = "Status Code: \(httpRes.statusCode)"
                completion(httpRes.statusCode, statusCode,error as! NSError)
            }
        } else {
            completion(nil, "*** session Errror ***",error as! NSError)
        }
    }) 
    
    task.resume()
    
}
