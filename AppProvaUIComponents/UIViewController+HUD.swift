//
//  UIViewController+HUD.swift
//  AppProvaUIComponents
//
//  Created by Guilherme Castro on 10/11/16.
//  Copyright © 2016 AppProva. All rights reserved.
//

import Foundation

import UIKit
import MBProgressHUD

private var blurImageView: UIImageView?
private var hud: MBProgressHUD?

extension UIViewController {
    
    public func showToast(localizedString: String) {
        self.showToast(text: NSLocalizedString(localizedString, comment: ""))
    }
    
    public func showToast(text: String) {
        
        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        let gestureRecognizer = UITapGestureRecognizer()
        gestureRecognizer.addTarget(self, action: #selector(dissmissHud))
        hud?.addGestureRecognizer(gestureRecognizer)
        
        hud?.mode = .text
        hud?.detailsLabel.text = text
        hud?.offset = CGPoint(x: 0.0, y: MBProgressMaxOffset)
        
        hud?.hide(animated: true, afterDelay: 3.5)
    }
    
    public func dissmissHud() {
        hud?.hide(animated: true)
    }
    
    // MARK: Loading
    
    
    public func showLoading(_ showProgress: Bool = true){
        
        if blurImageView != nil{
            return
        }
        
        let blurImage = self.getBlurScreenShot()
        
        blurImageView = UIImageView(image: blurImage)
        self.view.addSubview(blurImageView!)
        
        if (showProgress) {
            if hud != nil {
                hud?.hide(animated: false)
            }
            hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        }
        
    }
    
    public func hideLoading() {
        if (hud != nil) {
            hud?.hide(animated: false)
            hud = nil
        }
        
        let blurTime = 0.4
        
        UIView.animate(withDuration: blurTime, animations: { () -> Void in
            blurImageView?.alpha = 0.0
        }) { (_) -> Void in
            blurImageView?.removeFromSuperview()
            blurImageView = nil
        }
    }
    
    private func getBlurScreenShot() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, true, 1)
        self.view.drawHierarchy(in: self.view.bounds, afterScreenUpdates: false)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        //let tintColor = UIColor(white: 1.0, alpha: 0.3) // light
        let tintColor = UIColor(white: 0.11, alpha: 0.73)
        //self applyBlurWithRadius:30 tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil
        //return screenshot.applyExtraLightEffect()
        //UIColor *tintColor = [UIColor colorWithWhite:0.11 alpha:0.73];
        return screenshot == nil ? UIImage() :
            screenshot!.applyBlurWithRadius(5, tintColor: tintColor, saturationDeltaFactor: 1.8, maskImage: nil)
    }
    
}