//
//  RealmStackPatient.swift
//  Dentic
//
//  Created by Tanakorn on 4/26/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import Foundation
import RealmSwift
class RealmStackPatient:Object{
    dynamic var isUpdate : Bool = false
    dynamic var isPic : Bool = false
    dynamic var id : String = ""
    dynamic var localid = ""
    dynamic var HN :String = ""
    dynamic var name:String = ""
    dynamic var gender:String = ""
    dynamic var dob : Date!
    var phoneno = List<phoneNo>()
    dynamic var wardid:String = ""
    dynamic var age:String = ""
    dynamic var picurl:String = ""
    dynamic var lastfudate : Date!
    dynamic var keyindex:String = ""
    dynamic var updatetime : Date!
    dynamic var medpayment : String = ""
    dynamic var nationality :String = ""
    dynamic var nationalID : String = ""
    dynamic var docuserid : Int = 0
    dynamic var address : String = ""
    dynamic var group : RealmGroup? = nil
    var listFollowUp = List<RealmListFollowup>()
    var followup = List<RealmFollowup>()
    dynamic var isCreate : Bool = false
    dynamic var isDownload : Bool = false
    dynamic var status : String = ""
    var meshtag = List<MeshTag>()
    dynamic var lastfuupdatetime : Date!
}
