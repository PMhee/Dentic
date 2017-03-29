//
//  CustomForm.swift
//  MEDLOG
//
//  Created by Tanakorn on 11/5/2559 BE.
//  Copyright © 2559 Tanakorn. All rights reserved.
//

import Foundation
import RealmSwift
class CustomForm:Object{
    dynamic var id  : String = ""
    dynamic var title : String = ""
    dynamic var des : String = ""
    dynamic var ward : String = ""
    dynamic var color : Int = 0
    dynamic var icon : String = ""
    dynamic var category : String = ""
    var formula = List<CustomFormFormula>()
    var section = List<CustomFormSection>()
    dynamic var updateTime : Date!
    dynamic var owneruserid : String = ""
    dynamic var star : Double = 0.0
    var shared = List<CustomFormShare>()
    dynamic var frequent : Int = 0
    dynamic var isDownload = false
    dynamic var perm : String = ""
    dynamic var isAnswer : Bool = false
}
