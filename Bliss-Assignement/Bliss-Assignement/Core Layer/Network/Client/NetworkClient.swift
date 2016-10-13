//
//  YSWSClient.swift
//  Bliss-Assignement
//
//  Created by Jorge Mendes on 12/10/16.
//  Copyright © 2016 Jorge Mendes. All rights reserved.
//

import UIKit
import Alamofire

class NetworkClient: NSObject {

    static let domain: String = "com.jm.Bliss-Assignement.NetworkClient"
    static let baseUrl: String = "https://private-anon-dd905fc611-blissrecruitmentapi.apiary-mock.com/"
    static let pageSize: UInt = 10
    
    internal var httpManager: BaseHTTPManager!
    
    class func sharedManager() -> NetworkClient {
        var instance: NetworkClient? = nil
        var onceToken: dispatch_once_t = dispatch_once_t()
        dispatch_once(&onceToken, { () -> Void in
            let sessionManager: BaseHTTPManager = BaseHTTPManager()
            
            let configuration: NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
            configuration.requestCachePolicy = .ReloadIgnoringLocalAndRemoteCacheData
            var headers: [String: String] = Alamofire.Manager.defaultHTTPHeaders
            headers.updateValue("no-cache", forKey: "Cache-Control")
            configuration.HTTPAdditionalHeaders = headers
            
            sessionManager.manager = Manager(configuration: configuration, delegate: Manager.SessionDelegate(), serverTrustPolicyManager: nil)
            instance = NetworkClient(sessionManager: sessionManager)
        })
        return instance!
    }
    
    private init(sessionManager: BaseHTTPManager?) {
        super.init()
        
        guard sessionManager != nil else {
            fatalError("sessionManager is nil")
        }
        self.httpManager = sessionManager
    }
    
    deinit {
        self.httpManager = nil
    }
    
    class func jsonObjectFromData(data: NSData?) -> (json: AnyObject?, error: NSError?) {
        var jsonObject: AnyObject? = nil
        var error: NSError? = nil
        do {
            jsonObject = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
        } catch let err {
            #if DEBUG
                print(err)
            #endif
            jsonObject = nil
            error = NSError(domain: NetworkClient.domain, code: -2, userInfo: nil)
        }
        return (jsonObject, error)
    }
    
}
