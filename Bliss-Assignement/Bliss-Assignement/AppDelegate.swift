//
//  AppDelegate.swift
//  Bliss-Assignement
//
//  Created by Jorge Mendes on 12/10/16.
//  Copyright © 2016 Jorge Mendes. All rights reserved.
//

import UIKit
import AlamofireNetworkActivityIndicator

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    private let urlScheme: String = "blissrecruitment"
    
    var window: UIWindow?
    
    private var networkUnreachableView: NetworkUnreachableView?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        
        NetworkActivityIndicatorManager.sharedManager.isEnabled = true
        NetworkActivityIndicatorManager.sharedManager.startDelay = 0.1
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.networkIsReachable), name: BaseHTTPManager.networkReachable, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.networkIsUnreachable), name: BaseHTTPManager.networkUnreachable, object: nil)
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        if url.scheme != nil && url.scheme! == self.urlScheme {
            if url.query != nil {
                if url.host! == "questions" {
                    url.query!.componentsSeparatedByString("&").forEach {
                        let components: [String] = $0.componentsSeparatedByString("=")
                        if components.count == 2 && components.first != nil {
                            if components.first! == "question_filter" {
                                NSUserDefaults.standardUserDefaults().setObject(components.last == nil ? "" : components.last!, forKey: "filter")
                                NSUserDefaults.standardUserDefaults().synchronize()
                            } else if components.first! == "question_id" && components.last != nil {
                                NSUserDefaults.standardUserDefaults().setObject(components.last!, forKey: "id")
                                NSUserDefaults.standardUserDefaults().synchronize()
                            }
                        }
                    }
                }
            }
        }
        
        return true
    }
    
    
    // MARK: - Network reachability methods
    
    internal func networkIsReachable() {
        if self.networkUnreachableView != nil && (self.networkUnreachableView?.isShowing)! {
            self.networkUnreachableView?.dismiss()
        }
    }
    
    internal func networkIsUnreachable() {
        if self.networkUnreachableView == nil || !(self.networkUnreachableView?.isShowing)! {
            self.networkUnreachableView = NSBundle.mainBundle().loadNibNamed(String(NetworkUnreachableView), owner: self, options: nil)?.first as? NetworkUnreachableView
            self.networkUnreachableView?.show()
        }
    }

}
