//
//  OAuthLoader.swift
//  MOCPulse OSX
//
//  Created by Admin on 18.07.15.
//  Copyright (c) 2015 Master of Code. All rights reserved.
//

import Foundation
import p2_OAuth2

class OAuthLoader {
    static var sharedInstance = OAuthLoader()
    
    func handleRedirectURL(url: NSURL) {
        OAuthLoader.sharedInstance.oauth2.handleRedirectURL(url)
    }
    
    // MARK: - Instance
    
    let baseURL = NSURL(string: kAuthorizationServer)!
    
    lazy var oauth2 = OAuth2CodeGrant(settings: [
        "client_id": "288c7689f3eb0d5426c434413a8711534cc781751a545e431af6f7f3aa8650ee",                         // yes, this client-id and secret will work!
        "client_secret": "0d88640d7e479c01cb37bff27cc08843e97d4b3d021e3d13449a377afeeec5f3",
        "authorize_uri": "\(kAuthorizationServer)oauth/authorize",
        "token_uri": "\(kAuthorizationServer)oauth/token",
        "scope": "public",
        "redirect_uris": ["oauth-swift://oauth-callback/MOCPulse"],
        "verbose": true,
        "keychain": false,
        ])
    
    
    /** Start the OAuth dance. */
    func authorize(callback: (wasFailure: Bool, error: NSError?) -> Void) {
        oauth2.onAuthorize = { parameters in
            println("Did authorize with parameters: \(parameters)")
//            OAuthLoader.getUser(_userToken: parameters["access_token"] as! String)
            OAuthLoader.putPushToken(_pushToken: "unk", _userToken: parameters["access_token"] as! String)
//            kHardCodedToken =
            

        }
        oauth2.afterAuthorizeOrFailure = callback
        oauth2.authorize()
    }
    
    static func putPushToken(_pushToken pushToken : String, _userToken userToken : String) {
        NSUserDefaults.standardUserDefaults().removeObjectForKey("user_tmp_token")
        NSUserDefaults.standardUserDefaults().synchronize()
        UserModel.updatePushToken(_userToken: userToken, _deviceToken: pushToken, _completion: { () -> Void in
            self.getUser(_userToken: userToken)
        })
    }
    
    static func getUser(_userToken userToken : String) {
        UserModel.user(userToken, _completion: { (user:UserModel?) -> Void in
            var manager : LocalObjectsManager = LocalObjectsManager.sharedInstance
            manager.user = user
            
            kHardCodedToken = user!.apiToken!
            TcpSocket.sharedInstance.connect(host, port: port)
            API.isRunAuthorization = false
            
            //            println(user)
            
            NSNotificationCenter.defaultCenter().postNotificationName("GET_ALL_VOTES", object: nil)
        })
    }
    
    /** Perform a request against the GitHub API and return decoded JSON or an NSError. */
    func request(path: String, callback: ((dict: NSDictionary?, error: NSError?) -> Void)) {
        
        let url = baseURL.URLByAppendingPathComponent(path)
        let req = oauth2.request(forURL: url)
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(req) { data, response, error in
            if nil != error {
                dispatch_async(dispatch_get_main_queue()) {
                    callback(dict: nil, error: error)
                }
            }
            else {
                var err: NSError?
                let dict = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &err) as? NSDictionary
                dispatch_async(dispatch_get_main_queue()) {
                    callback(dict: dict, error: err)
                }
            }
        }
        task.resume()
    }
    
    
    // MARK: - Convenience
    
    func requestUserdata(callback: ((dict: NSDictionary?, error: NSError?) -> Void)) {
        request("user", callback: callback)
    }
}
