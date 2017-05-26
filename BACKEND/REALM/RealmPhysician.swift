//
//  File.swift
//  MEDDIC
//
//  Created by Tanakorn on 1/16/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import Foundation
import Realm
import RealmSwift
class RealmPhysician:Object{
    dynamic var sessionid : String = ""
    dynamic var id : String = ""
    dynamic var des : String = ""
    dynamic var email : String = ""
    dynamic var name : String = ""
    dynamic var gender : String = ""
    dynamic var phoneno : String = ""
    dynamic var picurl : String = ""
    dynamic var userid : Int = 0
    dynamic var wardid : String = ""
    dynamic var facebook : String = ""
    dynamic var telephone : String = ""
    dynamic var nickname : String = ""
    dynamic var isUpdate : Bool = false
    dynamic var passcode : String = ""
    dynamic var role : String = "Doctor"
    dynamic var major : String = ""
    dynamic var institute : String = ""
    dynamic var institutePic : String = ""
    var groupid = List<RealmGroupArray>()
}
