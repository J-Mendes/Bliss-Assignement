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

    internal var manager: Manager?
    
    init() {
        #if DEBUG
            print("\nIs network reachable: \(NetworkReachabilityManager()!.isReachable)")
        #endif
    }
    
    internal func GET(URLString: URLStringConvertible, parameters: [String: AnyObject]? = nil, encoding: ParameterEncoding = .URL, headers: [String: String]? = nil) -> Request {
        return (self.manager?.request(.GET, URLString, parameters: parameters, encoding: encoding, headers: headers))!
            .debugLog().validate()
    }
    
    internal func HEAD(URLString: URLStringConvertible, parameters: [String: AnyObject]? = nil, encoding: ParameterEncoding = .URL, headers: [String: String]? = nil) -> Request {
        return (self.manager?.request(.HEAD, URLString, parameters: parameters, encoding: encoding, headers: headers))!
            .debugLog().validate()
    }
    
    internal func POST(URLString: URLStringConvertible, parameters: [String: AnyObject]? = nil, encoding: ParameterEncoding = .URL, headers: [String: String]? = nil) -> Request {
        return (self.manager?.request(.POST, URLString, parameters: parameters, encoding: encoding, headers: headers))!
            .debugLog().validate()
    }
    
    internal func PUT(URLString: URLStringConvertible, parameters: [String: AnyObject]? = nil, encoding: ParameterEncoding = .URL, headers: [String: String]? = nil) -> Request {
        return (self.manager?.request(.PUT, URLString, parameters: parameters, encoding: encoding, headers: headers))!
            .debugLog().validate()
    }
    
    internal func PATCH(URLString: URLStringConvertible, parameters: [String: AnyObject]? = nil, encoding: ParameterEncoding = .URL, headers: [String: String]? = nil) -> Request {
        return (self.manager?.request(.PATCH, URLString, parameters: parameters, encoding: encoding, headers: headers))!
            .debugLog().validate()
    }
    
    internal func DELETE(URLString: URLStringConvertible, parameters: [String: AnyObject]? = nil, encoding: ParameterEncoding = .URL, headers: [String: String]? = nil) -> Request {
        return (self.manager?.request(.DELETE, URLString, parameters: parameters, encoding: encoding, headers: headers))!
            .debugLog().validate()
    }
    
}
