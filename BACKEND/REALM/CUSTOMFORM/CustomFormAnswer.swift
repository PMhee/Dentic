//
//  CustomFormAnswer.swift
//  MEDDIC
//
//  Created by Tanakorn on 2/5/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import Foundation
import RealmSwift
class CustomFormAnswer:Object{
    dynamic var answer : String = ""
    dynamic var img : String = ""
    var checked = List<Checked>()
    dynamic var requiredChecked : Bool = false
    var answerGrid = List<CustomFormAnswer>()
    dynamic var type : String = ""
}
class Checked:Object{
    dynamic var answer : String = ""
}
