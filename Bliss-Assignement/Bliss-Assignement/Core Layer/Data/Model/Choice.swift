//
//  Choice.swift
//  Bliss-Assignement
//
//  Created by Jorge Mendes on 13/10/16.
//  Copyright © 2016 Jorge Mendes. All rights reserved.
//

import Foundation

class Choice: NSObject {

    internal var choice: String!
    internal var votes: Int!
    
    override init() {
        super.init()
        
        self.choice = ""
        self.votes = 0
    }
    
    convenience init(withDictionary dictionary: [String: AnyObject]) {
        self.init()
        
        if let choice: String = dictionary["choice"] as? String {
            self.choice = choice
        }
        
        if let votes: Int = dictionary["votes"] as? Int {
            self.votes = votes
        }
    }
}
