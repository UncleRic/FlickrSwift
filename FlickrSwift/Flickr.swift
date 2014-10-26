//  Flickr.swift
//  FlickrSwift
//
//  Created by Frederick C. Lee on 9/29/14.
//  Copyright (c) 2014 Frederick C. Lee. All rights reserved.
// -----------------------------------------------------------------------------------------------------

import Foundation

var gPermission:FKPermission?

public enum FKPermission:Int {
    case FKPermissionRead
    case FKPermissionWrite
    case FKPermissionDelete
    func description() ->String {
        switch self {
        case .FKPermissionRead:
            return "READ"
        case .FKPermissionWrite:
            return "WRITE"
        case .FKPermissionDelete:
            return "DELETE"
        }
    }
}

// =======================================================================================================================

class FlickrKit:NSObject {
    var apiKey:NSString?
    var sharedSecret:NSString?
    init(apiKey:NSString, sharedSecret:NSString) {
        //TODO: assert(apiKey.length == 5 || sharedSecret.length == 10, "Unable to Continue: Missing a key and/or secret.")
        self.apiKey = apiKey; self.sharedSecret = sharedSecret
    }
}

// =======================================================================================================================

extension FlickrKit {
    func userAuthorizationURLWithRequestToken(inRequestToken:NSString!, requestedPermission:FKPermission) -> NSURL {
        gPermission = requestedPermission
        let perms = "&perms=\(requestedPermission.description())"
        let urlString = "http://www.flickr.com/services/oauth/authorize?oauth_token=\(inRequestToken)\(perms)" as NSString
        return NSURL(string: urlString)!
    }
}
