//
//  NetworkClient+Questions.swift
//  Bliss-Assignement
//
//  Created by Jorge Mendes on 13/10/16.
//  Copyright © 2016 Jorge Mendes. All rights reserved.
//

import Foundation

extension NetworkClient {

    // MARK: - Questions
    
    internal func getQuestions(page: UInt, filter: String, completion: (response: AnyObject, error: NSError?) -> Void) {
        self.httpManager.GET(NetworkClient.baseUrl + "questions?limit=\(NetworkClient.pageSize)&offset=\((page - 1) * NetworkClient.pageSize)" + (filter != "" ? "&filter=\(filter)" : ""))
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
                    
                    completion(response: "", error: NSError(domain: NetworkClient.domain + ".Questions", code: errorCode, userInfo: nil))
                    break
                }
        }
    }
    
}
