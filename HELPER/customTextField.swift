//
//  customTextField.swift
//  MEDDIC
//
//  Created by Tanakorn on 3/21/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import Foundation
import UIKit
class customTextField: UITextField{
    func textRectForBounds(bounds: CGRect) -> CGRect {
        return super.textRect(forBounds: UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(10, 5, 10, 10)))
    }
    func editingRectForBounds(bounds: CGRect) -> CGRect {
        return super.editingRect(forBounds: UIEdgeInsetsInsetRect(bounds,  UIEdgeInsetsMake(10, 5, 10, 10)))
    }
}
