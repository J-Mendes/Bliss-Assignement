//
//  NetworkClient+HealthStatus.swift
//  Bliss-Assignement
//
//  Created by Jorge Mendes on 12/10/16.
//  Copyright © 2016 Jorge Mendes. All rights reserved.
//

import Foundation

extension NetworkClient {

    // MARK: - Server Health Status
    
    internal func getServerHealth(completion: (response: AnyObject, error: NSError?) -> Void) {
        self.httpManager.GET(NetworkClient.baseUrl + "health")
            .responseJSON { (response) -> Void in
                self.httpManager.manager?.session.invalidateAndCancel()
                
                let jsonParse: (json: AnyObject?, error: NSError?) = NetworkClient.jsonObjectFromData(response.data)
                
                switch response.result {
                case .Success:
                    if let json: AnyObject = jsonParse.json {
                        completion(response: json, error: nil)
                    } else {
                        completion(response: "", error: jsonParse.error)
                    }
                    break
                case .Failure:
                    var errorCode: Int = -1
                    if let httpResponse: NSHTTPURLResponse = response.response {
                        errorCode = httpResponse.statusCode
                    }
                    
                    completion(response: "", error: NSError(domain: NetworkClient.domain + ".ServerHealth", code: errorCode, userInfo: nil))
                    break
                }
        }
    }
    
}
