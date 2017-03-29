//
//  UITable.swift
//  MEDDIC
//
//  Created by Tanakorn on 1/17/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import Foundation
import UIKit
class UITable{
    func shadow(vw_layout:UIView){
        //        let shadowPath = UIBezierPath(rect: vw_layout.frame)
        //        vw_layout.layer.masksToBounds = false
        //        vw_layout.layer.shadowColor = UIColor.black.cgColor
        //        vw_layout.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        //        vw_layout.layer.shadowOpacity = 0.5
        //        vw_layout.layer.shadowPath = shadowPath.cgPath
//        vw_layout.layer.borderWidth = 0.25
//        vw_layout.layer.borderColor = UIColor(netHex: 0x98999B).cgColor
        vw_layout.layer.shadowColor = UIColor(netHex:0x98999B).cgColor
        vw_layout.layer.shadowOffset = CGSize(width: 0, height: 1)
        vw_layout.layer.shadowOpacity = 0.5
        vw_layout.layer.shadowRadius = 1.0
        vw_layout.clipsToBounds = false
        vw_layout.layer.masksToBounds = false
    }
}
