//
//  CustomFormListAnswer.swift
//  MEDDIC
//
//  Created by Tanakorn on 3/2/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import Foundation
import RealmSwift
class CustomFormListAnswer:Object{
    dynamic var cfansid : String = ""
    dynamic var color : Int = 0
    dynamic var cusfomrname : String = ""
    dynamic var picurl : String = ""
    dynamic var score : Double = 0.0
    var customform_section_answer = List<CustomFormSectionAns>()
    dynamic var customform: CustomForm!
}
