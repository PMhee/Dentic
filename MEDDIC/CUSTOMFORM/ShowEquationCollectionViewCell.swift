//
//  ShowEquationCollectionViewCell.swift
//  MEDLOG
//
//  Created by Tanakorn on 12/1/2559 BE.
//  Copyright © 2559 Tanakorn. All rights reserved.
//

import UIKit

class ShowEquationCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var vw_background: UIView!
    @IBOutlet weak var lb_curser: UILabel!
    @IBOutlet weak var lb_text: UILabel!
    @IBOutlet weak var cons_width: NSLayoutConstraint!
    public func setWidth(){
        if self.lb_text.text != nil{
            var count = self.lb_text.text!.characters.count
            self.cons_width.constant = CGFloat(((count-1)*10)+40)
        }else{
            self.cons_width.constant = 40
        }
    }
}
