//
//  CustomFormForm.swift
//  MEDLOG
//
//  Created by Tanakorn on 11/5/2559 BE.
//  Copyright © 2559 Tanakorn. All rights reserved.
//

import Foundation
import RealmSwift
class CustomFormForm:Object{
    dynamic var id : String = ""
    dynamic var required : Bool = false
    dynamic var fontColor : Int = 0
    dynamic var fontSize : String = ""
    dynamic var type : String = ""
    dynamic var question : String = ""
    dynamic var formula : String = ""
    var option = List<CustomFormOption>()
    var choice = List<CustomFormGridOption>()
}    
