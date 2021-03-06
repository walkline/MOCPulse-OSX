//
//  API.swift
//  MOCPulse
//
//  Created by Anton on 04.07.15.
//  Copyright (c) 2015 MOC. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


let kDevServer : String = "http://localhost:3000/"
let kProductionServer : String = "https://pulse.masterofcode.com/"
let kAuthorizationServer : String = "https://id.masterofcode.com/"

class API : NSObject {
    
    var host : String?
    var token : String?
    
    static var userToken : String?
    
    static var isRunAuthorization: Bool = false;
    
    class var sharedInstance : API {
        struct singleton {
            static let instance = API(host:kProductionServer)
        }
        return singleton.instance
    }
    
    init(host _host:String) {
        super.init()
        self.host = _host
    }
    
    // MARK: Authorization
    static func oauthAuthorization()
    {
    }
    
    // MARK: API Call
    static func request(_method: Alamofire.Method, path _path: URLStringConvertible, parameters _parameters: [String: AnyObject]? = nil, headers: [NSObject : AnyObject]? = nil) -> Request {
        
        //        if _parameters != nil {
        //            println(JSON(_parameters!))
        //        }
        
        // FIXME: need to add Authorization Token to headers
        Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders = headers;
        var request: Request = Manager.sharedInstance.request(_method, _path, parameters: _parameters, encoding: ParameterEncoding.JSON)
        
        println("request.headers:\n\(Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders!)")
        
        return request;
    }
    
    static func response(_request:Request, completionHandler: (NSURLRequest, NSHTTPURLResponse?, SwiftyJSON.JSON, NSError?) -> Void) -> Request {
        
        return _request.responseSwiftyJSON(completionHandler);
    }
    
    static func response(_request:Request, success _success: (SwiftyJSON.JSON) -> Void, failure _failure: (NSError?) -> Void) -> Request {
        
        return self.response(_request, completionHandler: { (request, response, json, error) -> Void in
            if ((error) != nil) {
                _failure(error)
            }
            else {
                //                if json != nil {
                //                    println("\(json)")
                //                }
                _success(json)
            }
        });
    }
}