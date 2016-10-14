//
//  BaseHTTPManager.swift
//  Bliss-Assignement
//
//  Created by Jorge Mendes on 12/10/16.
//  Copyright © 2016 Jorge Mendes. All rights reserved.
//

import Foundation
import Alamofire

class BaseHTTPManager {

    static let networkReachable: String = "com.jm.Bliss-Assignement.BaseHTTPManager.Reachable"
    static let networkUnreachable: String = "com.jm.Bliss-Assignement.BaseHTTPManager.Unreachable"
    
    internal var manager: Manager?
    
    private var networkManager: NetworkReachabilityManager?
    private var request: Request?
    
    init() {
        self.networkManager = NetworkReachabilityManager()
        
        self.networkManager?.listener = {
            switch $0 {
            case .Reachable:
                NSNotificationCenter.defaultCenter().postNotificationName(BaseHTTPManager.networkReachable, object: self)
                break
                
            default:
                self.request?.cancel()
                NSNotificationCenter.defaultCenter().postNotificationName(BaseHTTPManager.networkUnreachable, object: self)
                break
            }
        }
        
        self.networkManager?.startListening()
    }
    
    internal func GET(URLString: URLStringConvertible, parameters: [String: AnyObject]? = nil, encoding: ParameterEncoding = .URL, headers: [String: String]? = nil) -> Request {
        self.request = self.manager?.request(.GET, URLString, parameters: parameters, encoding: encoding, headers: headers)
        return self.request!.debugLog().validate()
    }
    
    internal func HEAD(URLString: URLStringConvertible, parameters: [String: AnyObject]? = nil, encoding: ParameterEncoding = .URL, headers: [String: String]? = nil) -> Request {
        self.request = self.manager?.request(.HEAD, URLString, parameters: parameters, encoding: encoding, headers: headers)
        return self.request!.debugLog().validate()
    }
    
    internal func POST(URLString: URLStringConvertible, parameters: [String: AnyObject]? = nil, encoding: ParameterEncoding = .URL, headers: [String: String]? = nil) -> Request {
        self.request = self.manager?.request(.POST, URLString, parameters: parameters, encoding: encoding, headers: headers)
        return self.request!.debugLog().validate()
    }
    
    internal func PUT(URLString: URLStringConvertible, parameters: [String: AnyObject]? = nil, encoding: ParameterEncoding = .URL, headers: [String: String]? = nil) -> Request {
        self.request = self.manager?.request(.PUT, URLString, parameters: parameters, encoding: encoding, headers: headers)
        return self.request!.debugLog().validate()
    }
    
    internal func PATCH(URLString: URLStringConvertible, parameters: [String: AnyObject]? = nil, encoding: ParameterEncoding = .URL, headers: [String: String]? = nil) -> Request {
        self.request = self.manager?.request(.PATCH, URLString, parameters: parameters, encoding: encoding, headers: headers)
        return self.request!.debugLog().validate()
    }
    
    internal func DELETE(URLString: URLStringConvertible, parameters: [String: AnyObject]? = nil, encoding: ParameterEncoding = .URL, headers: [String: String]? = nil) -> Request {
        self.request = self.manager?.request(.DELETE, URLString, parameters: parameters, encoding: encoding, headers: headers)
        return self.request!.debugLog().validate()
    }
    
}
