//
//  Loading.swift
//  MEDDIC
//
//  Created by Tanakorn on 1/20/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import UIKit

class Loading: UIView {
    public func animateForOpening(){
        self.alpha = 1.0
        self.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        UIView.animate(withDuration: 1, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
            self.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: nil)
    }
    
    public func animateForEnding(){
        UIView.animate(withDuration: 0.2, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.alpha = 0.0
        }, completion: {
            (finished: Bool) -> Void in
            // On main thread
        })
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
