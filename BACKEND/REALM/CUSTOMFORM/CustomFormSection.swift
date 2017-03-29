//
//  CustomFormSection.swift
//  MEDLOG
//
//  Created by Tanakorn on 11/5/2559 BE.
//  Copyright © 2559 Tanakorn. All rights reserved.
//

import Foundation
import RealmSwift
class CustomFormSection:Object{
    dynamic var id : String = ""
    dynamic var colorMain : Int = 0
    dynamic var colorSub : Int = 0
    dynamic var sectionName : String = ""
    dynamic var des : String = ""
    var formula = List<CustomFormFormula>()
    var form = List<CustomFormForm>()
    //dynamic var answer = RLMArray(objectClassName: CustomFormAnswer.className())
}
