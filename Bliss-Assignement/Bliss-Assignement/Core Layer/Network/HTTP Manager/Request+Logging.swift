//
//  Request+Logging.swift
//  Bliss-Assignement
//
//  Created by Jorge Mendes on 12/10/16.
//  Copyright © 2016 Jorge Mendes. All rights reserved.
//

import Alamofire

extension Request {
    
    public func debugLog() -> Self {
        #if DEBUG
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                print("Request details:")
                debugPrint(self)
                print("")
            })
        #endif
        return self
    }
    
}
