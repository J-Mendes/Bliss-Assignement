//
//  NetworkUnreachableView.swift
//  Bliss-Assignement
//
//  Created by Jorge Mendes on 13/10/16.
//  Copyright © 2016 Jorge Mendes. All rights reserved.
//

import UIKit

class NetworkUnreachableView: UIView {

    private(set) var isShowing: Bool = false
    
    @IBOutlet weak var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.frame = UIScreen.mainScreen().bounds
        
        self.messageLabel.text = "Your network connection is disabled.\nPlease enable it!"
    }
    
    internal func show() {
        self.endEditing(true)
        self.alpha = 0.0
        UIApplication.sharedApplication().keyWindow!.addSubview(self)
        UIView.animateWithDuration(0.3) {
            self.alpha = 1.0
        }
        self.isShowing = true
    }
    
    internal func dismiss() {
        UIView.animateWithDuration(0.3, animations: {
            self.alpha = 0.0
        }) { (success: Bool) in
            self.isShowing = false
            self.removeFromSuperview()
        }
    }
    
}
