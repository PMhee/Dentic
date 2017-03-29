//
//  BackPhysician.swift
//  MEDDIC
//
//  Created by Tanakorn on 3/8/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import Foundation
import RealmSwift
class BackPhysician{
    func downloadPhysicianProfile(success:NSDictionary){
        try! Realm().write {
            if let content = success.value(forKey: "content") as? NSDictionary{
                var physician = RealmPhysician()
                if try! Realm().objects(RealmPhysician.self).count == 1{
                    physician = try! Realm().objects(RealmPhysician.self).first!
                }
                var idd = ""
                if let ID = content.value(forKey: "_id") as? NSDictionary{
                    if let id = ID.value(forKey: "$id") as? String{
                        if try! Realm().objects(RealmPhysician.self).count != 1{
                            if self.getPhysician(id: id) != nil{
                                physician = self.getPhysician(id: id)!
                            }
                        }
                        physician.id = id
                        idd = id
                    }
                }
                if let email = content.value(forKey: "email") as? String{
                    physician.email = email
                }
                if let firstname = content.value(forKey: "firstname") as? String{
                    physician.name = firstname
                }
                if let middlename = content.value(forKey: "middlename") as? String{
                    physician.name = physician.name + " " + middlename
                }
                if let lastname = content.value(forKey: "lastname") as? String{
                    physician.name = physician.name + " " + lastname
                }
                if let phoneno = content.value(forKey: "phoneno") as? String{
                    physician.phoneno = phoneno
                }
                if let nickname = content.value(forKey: "nickname") as? String{
                    physician.nickname = nickname
                }
                if let picurl = content.value(forKey: "picurl") as? String{
                    physician.picurl = picurl
                }
                if let userid = content.value(forKey: "userid") as? Int{
                    physician.userid = userid
                }
                if self.getPhysician(id: idd) == nil{
                    try! Realm().add(physician)
                }
            }
        }
    }
    func getPhysician(id:String) ->RealmPhysician?{
        return try! Realm().objects(RealmPhysician.self).filter(NSPredicate(format: "id == %@", id)).first
    }
}
