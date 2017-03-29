//
//  UILoading.swift
//  MEDDIC
//
//  Created by Tanakorn on 1/16/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import Foundation
import UIKit

class UILoading{
    var view = UIView()
    func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
    func showError(error:String,view:UIView){
        self.view = view
        let vw_error = UIView(frame: CGRect(x: view.frame.origin.x, y: 0, width: view.frame.width, height: 30))
        vw_error.backgroundColor = UIColor.black
        let lb = UILabel(frame: CGRect(x: view.frame.origin.x, y: 0, width: view.frame.width, height: vw_error.frame.height))
        let btn = UIButton(frame: CGRect(x: view.frame.width-30, y: 0, width: 30, height: vw_error.frame.height))
        btn.setTitle("x", for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        btn.addTarget(self, action: #selector(close), for: .touchUpInside)
        lb.text = error
        lb.font = UIFont.systemFont(ofSize: 13)
        vw_error.alpha = 0.85
        lb.textAlignment = .center
        lb.textColor = UIColor.white
        view.addSubview(vw_error)
        view.addSubview(lb)
        view.addSubview(btn)
        vw_error.tag = 10
        lb.tag = 11
        btn.tag = 12
        self.delay(2){
            lb.text = "Please connect the internet"
            self.delay(2){
                lb.text = "You can still record the clinical note offline"
            }
        }
        
    }
    func showErrorNav(error:String,view:UIView){
        self.view = view
        let vw_error = UIView(frame: CGRect(x: view.frame.origin.x, y: 0, width: view.frame.width, height: 30))
        vw_error.backgroundColor = UIColor.black
        let lb = UILabel(frame: CGRect(x: view.frame.origin.x, y: 0, width: view.frame.width, height: vw_error.frame.height))
        let btn = UIButton(frame: CGRect(x: view.frame.width-30, y: 0, width: 30, height: vw_error.frame.height))
        btn.setTitle("x", for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        btn.addTarget(self, action: #selector(close), for: .touchUpInside)
        lb.text = error
        lb.font = UIFont.systemFont(ofSize: 13)
        vw_error.alpha = 0.85
        lb.textAlignment = .center
        lb.textColor = UIColor.white
        view.addSubview(vw_error)
        view.addSubview(lb)
        view.addSubview(btn)
        vw_error.tag = 10
        lb.tag = 11
        btn.tag = 12
        self.delay(2){
            lb.text = "Please connect the internet"
            self.delay(2){
                lb.text = "You can still record the clinical note offline"
            }
        }
        
        
    }
    func animateForOpening(vw:UIView){
        vw.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        UIView.animate(withDuration: 1, delay: 0.2, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
            vw.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: nil)
    }
    public func animateForEnding(vw:UIView?,bg:UIView?){
        vw?.transform = CGAffineTransform(scaleX: 1, y: 1)
        UIView.animate(withDuration: 0.7, delay: 0.2, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.curveEaseOut, animations: {
            vw?.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
        }, completion: {
            (finished: Bool) -> Void in
            vw?.removeFromSuperview()
            bg?.removeFromSuperview()
            // On main thread
            DispatchQueue.main.async {
                () -> Void in
                
            }
        })
    }
    @objc func close(sender:UIButton){
        let vw1 = self.view.viewWithTag(10)
        vw1?.removeFromSuperview()
        let vw2 = self.view.viewWithTag(11)
        vw2?.removeFromSuperview()
        let vw3 = self.view.viewWithTag(12)
        vw3?.removeFromSuperview()
    }
    func loadFromNibNamed(nibNamed: String) -> UIView? {
        return Bundle.main.loadNibNamed(nibNamed, owner: nil, options: nil)?.first as? UIView
    }
    
}
