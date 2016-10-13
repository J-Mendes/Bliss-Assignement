//
//  ProgressHUD.swift
//  Bliss-Assignement
//
//  Created by Jorge Mendes on 13/10/16.
//  Copyright © 2016 Jorge Mendes. All rights reserved.
//

import UIKit
import JGProgressHUD

class ProgressHUD: NSObject {

    private class func createProgressHUD() -> JGProgressHUD {
        let hud: JGProgressHUD = JGProgressHUD(style: .Dark)
        hud.interactionType = .BlockAllTouches
        hud.animation = JGProgressHUDFadeZoomAnimation()
        hud.backgroundColor = UIColor.init(white: 0.0, alpha: 0.4)
        hud.textLabel.font = UIFont.systemFontOfSize(14.0)
        hud.HUDView.layer.shadowColor = UIColor.blackColor().CGColor
        hud.HUDView.layer.shadowOffset = CGSizeZero
        hud.HUDView.layer.shadowOpacity = 0.4
        hud.HUDView.layer.shadowRadius = 8.0
        return hud
    }
    
    class func showProgressHUD(view: UIView, text: String = "", isSquared: Bool = true) {
        let allHuds: [JGProgressHUD] = JGProgressHUD.allProgressHUDsInView(view) as! [JGProgressHUD]
        if allHuds.count > 0 {
            let hud: JGProgressHUD = allHuds.first!
            hud.indicatorView = JGProgressHUDIndeterminateIndicatorView(HUDStyle: hud.style)
            hud.textLabel.text = text
            hud.square = isSquared
        } else {
            let newHud: JGProgressHUD = self.createProgressHUD()
            newHud.indicatorView = JGProgressHUDIndeterminateIndicatorView(HUDStyle: newHud.style)
            newHud.textLabel.text = text
            newHud.square = isSquared
            newHud.showInView(view)
        }
    }
    
    class func showSuccessHUD(view: UIView, text: String = "Success") {
        let allHuds: [JGProgressHUD] = JGProgressHUD.allProgressHUDsInView(view) as! [JGProgressHUD]
        if allHuds.count > 0 {
            let hud: JGProgressHUD = allHuds.first!
            hud.indicatorView = JGProgressHUDSuccessIndicatorView()
            hud.textLabel.text = text
            hud.dismissAfterDelay(3.0)
        } else {
            let newHud: JGProgressHUD = self.createProgressHUD()
            newHud.indicatorView = JGProgressHUDSuccessIndicatorView()
            newHud.textLabel.text = text
            newHud.showInView(view)
            newHud.dismissAfterDelay(3.0)
        }
    }
    
    class func showErrorHUD(view: UIView, text: String = "Error") {
        let allHuds: [JGProgressHUD] = JGProgressHUD.allProgressHUDsInView(view) as! [JGProgressHUD]
        if allHuds.count > 0 {
            let hud: JGProgressHUD = allHuds.first!
            hud.indicatorView = JGProgressHUDErrorIndicatorView()
            hud.textLabel.text = text
            hud.dismissAfterDelay(3.0)
        } else {
            let newHud: JGProgressHUD = self.createProgressHUD()
            newHud.indicatorView = JGProgressHUDErrorIndicatorView()
            newHud.textLabel.text = text
            newHud.showInView(view)
            newHud.dismissAfterDelay(3.0)
        }
    }
    
    class func dismissAllHuds(view: UIView) {
        JGProgressHUD.allProgressHUDsInView(view).forEach{ ($0 as! JGProgressHUD).dismiss() }
    }
    
}
