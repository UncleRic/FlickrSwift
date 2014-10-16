//  Flickr.swift
//  FlickrSwift
//
//  Created by Frederick C. Lee on 9/29/14.
//  Copyright (c) 2014 Frederick C. Lee. All rights reserved.
// -----------------------------------------------------------------------------------------------------

import Foundation

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
    
    
//    func userAuthorizationURLWithRequestToken(inRequestToken:NSString!, requestedPermission:FKPermission!) -> NSURL {
//
////        let perms = "&perms=\(requestedPermission.description())"
////        let urlString = "http://www.flickr.com/services/oauth/authorize?oauth_token=\(inRequestToken)\(perms)" as NSString
////        return NSURL(string: urlString)
//    }
}


//- (NSURL *)userAuthorizationURLWithRequestToken:(NSString *)inRequestToken requestedPermission:(FKPermission)permission {
//    NSString *perms = @"";FKPermission
//    
//    NSString *permissionString = nil;
//    switch (permission) {
//    case FKPermissionRead:
//        permissionString = @"read";
//        break;
//    case FKPermissionWrite:
//        permissionString = @"write";
//        break;
//    case FKPermissionDelete:
//        permissionString = @"delete";
//        break;
//    }
//    
//    self.permissionGranted = permission;
//    
//    perms = [NSString stringWithFormat:@"&perms=%@", permissionString];
//    
//    ///http://www.flickr.com/services/oauth/authorize
//    NSString *URLString = [NSString stringWithFormat:@"http://www.flickr.com/services/oauth/authorize?oauth_token=%@%@", inRequestToken, perms];
//    return [NSURL URLWithString:URLString];
//}
