//
//  UIViewAnimation.swift
//  MEDDIC
//
//  Created by Tanakorn on 5/11/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import Foundation
import UIKit
class UIViewAnimation{
    func animateResizeSize(view:UIView,dx:CGFloat,dy:CGFloat,duration:Double,success: @escaping (_ response: String) -> Void){
        view.isHidden = false
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 3, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            view.frame.size.width += dx
            view.frame.size.height += dy
            view.alpha = 1
        }, completion: {(complete) in
            success("")
        })
    }
    func animateTopToBot(view:UIView,y:CGFloat,duration:Double,success: @escaping (_ response: String) -> Void){
        view.isHidden = false
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            view.frame.origin.y = y
            view.alpha = 1
        }, completion: {(complete) in
            success("")
        })
    }
    func animateBotToTop(view:UIView,y:CGFloat,duration:Double,success: @escaping (_ response: String) -> Void){
        UIView.animate(withDuration: duration, animations: {
            view.frame.origin.y = y
        }, completion: {(complete) in
            view.isHidden = true
            success("")
            
        })
    }
}
