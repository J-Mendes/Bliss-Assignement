//
//  NetworkClient+Share.swift
//  Bliss-Assignement
//
//  Created by Jorge Mendes on 13/10/16.
//  Copyright © 2016 Jorge Mendes. All rights reserved.
//

import Foundation

extension NetworkClient {

    // MARK: - Dhare
    
    internal func shareViaEmail(email: String, url: String, completion: (response: AnyObject, error: NSError?) -> Void) {
        self.httpManager.POST(NetworkClient.baseUrl + "share?destination_email=" + email + "&content_url=" + url)
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
                    
                    completion(response: "", error: NSError(domain: NetworkClient.domain + ".Share", code: errorCode, userInfo: nil))
                    break
                }
        }
    }
    
}
