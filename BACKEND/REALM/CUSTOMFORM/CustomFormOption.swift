//
//  CustomFormOption.swift
//  MEDLOG
//
//  Created by Tanakorn on 11/5/2559 BE.
//  Copyright © 2559 Tanakorn. All rights reserved.
//

import Foundation
import RealmSwift
class CustomFormOption:Object{
    dynamic var id:String = ""
    dynamic var question:String = ""
    dynamic var point:String = ""
    dynamic var checked : Bool  = false
}
