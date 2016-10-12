//
//  LoadingViewController.swift
//  Bliss-Assignement
//
//  Created by Jorge Mendes on 12/10/16.
//  Copyright © 2016 Jorge Mendes. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet private weak var retryButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initLayout()
        self.checkServerHealth()
    }
    
    private func initLayout() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        self.titleLabel.text = "Checking server health..."
        self.retryButton.setTitle("Check again", forState: .Normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - UIButton actions
    
    @IBAction func retryAction(sender: AnyObject) {
        UIView.animateWithDuration(0.1, animations: {
            self.retryButton.alpha = 0.0
        }) { (success: Bool) in
            self.retryButton.hidden = true
            self.titleLabel.text = "Checking server health..."
            self.activityIndicatorView.startAnimating()
            self.checkServerHealth()
        }
    }
    
    
    // MARK: - Network requests
    
    private func checkServerHealth() {
        NetworkClient.sharedManager().getServerHealth { (result, error) in
            if error == nil {
                if let response: [String: AnyObject] = result as? [String: AnyObject] where (response["status"] as? String) == "OK" {
                    // TODO: goto list screen
                } else {
                    self.showRetry()
                }
            } else {
                self.showRetry()
            }
        }
    }
    
    private func showRetry() {
        self.titleLabel.text = "The server health is not good. Please check again."
        self.activityIndicatorView.stopAnimating()
        self.retryButton.hidden = false
        UIView.animateWithDuration(0.1) {
            self.retryButton.alpha = 1.0
        }
    }

}
