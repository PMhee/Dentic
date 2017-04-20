//
//  RealmHistory.swift
//  MEDDIC
//
//  Created by Tanakorn on 1/17/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import Foundation
import Realm
import RealmSwift
class RealmFollowup:Object{
    dynamic var localid : String = ""
    dynamic var id : String = ""
    dynamic var diseasestatus : Int = 0
    dynamic var docuserid : Int = 0
    dynamic var patientid : String = ""
    dynamic var followdate : Date!
    dynamic var followupnote : String = ""
    dynamic var updatetime : Date!
    dynamic var followtime : String = ""
    dynamic var physician : RealmPhysician!
    var picurl = List<Picture>()
    dynamic var isUpdate : Bool = false
    dynamic var opdtag : String = ""
    dynamic var isCreate = false
    var meshtag = List<MeshTag>()
    var cusforms = List<CustomFormListAnswer>()
    
    //DENTIST
    var ExternalImage = List<Picture>()
    var InternalImage = List<Picture>()
    var Film = List<Picture>()
    var Lime = List<Picture>()
}
class MeshTag:Object{
    dynamic var tag : String = ""
    dynamic var followupid : String = ""
}
class Picture:Object{
    dynamic var id : String = ""
    dynamic var type : String = ""
    dynamic var patientid : String = "K"
    dynamic var fudocid : String = ""
    dynamic var fulocalid : String = ""
    dynamic var picurl : String = ""
    dynamic var isUpdate : Bool = false
}
