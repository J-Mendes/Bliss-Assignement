//
//  ShareView.swift
//  Bliss-Assignement
//
//  Created by Jorge Mendes on 13/10/16.
//  Copyright © 2016 Jorge Mendes. All rights reserved.
//

import UIKit

class ShareView: UIView, UITextFieldDelegate {

    internal var shareUrl: String!
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var sharePopupView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    private var email: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.frame = UIScreen.mainScreen().bounds
        
        self.sharePopupView.layer.cornerRadius = 4.0
        self.sharePopupView.layer.masksToBounds = true
        
        self.titleLabel.text = "Share this screen"
        self.emailLabel.text = "Email"
        self.emailTextField.delegate = self
        self.emailTextField.placeholder = "Insert email"
        self.cancelButton.setTitle("Cancel", forState: .Normal)
        self.shareButton.setTitle("Share", forState: .Normal)
        self.shareButton.enabled = false
    }
    
    internal func show() {
        self.alpha = 0.0
        UIApplication.sharedApplication().keyWindow!.addSubview(self)
        self.emailTextField.becomeFirstResponder()
        UIView.animateWithDuration(0.3) { 
            self.alpha = 1.0
        }
    }
    
    internal func dismiss() {
        self.endEditing(true)
        UIView.animateWithDuration(0.3, animations: { 
            self.alpha = 0.0
        }) { (success: Bool) in
            self.removeFromSuperview()
        }
    }
    
    
    // MARK: - UITextField delegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func textDidChange(sender: AnyObject) {
        self.email = (sender as! UITextField).text!
        self.shareButton.enabled = NSPredicate(format: "SELF MATCHES %@", "^[a-zA-Z+-._0-9]+@[a-z0-9-.]+\\.[a-z]+$").evaluateWithObject(self.email)
    }
    
    
    // MARK: - UIButton actions
    
    @IBAction func cancelAction(sender: AnyObject) {
        self.dismiss()
    }
    
    @IBAction func shareAction(sender: AnyObject) {
        self.endEditing(true)
        ProgressHUD.showProgressHUD(self)
        NetworkClient.sharedManager().shareViaEmail(self.email, url: self.shareUrl) { (response, error) in
            if error == nil {
                ProgressHUD.dismissAllHuds(self)
                self.dismiss()
            } else {
                ProgressHUD.showErrorHUD(self, text: "An error was occurred\nwhile sharing.")
            }
        }
    }

}
