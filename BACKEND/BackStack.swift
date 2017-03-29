

//
//  BackStactk.swift
//  MEDDIC
//
//  Created by Tanakorn on 2/7/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import Foundation
import Alamofire
import RealmSwift
class BackStack{
    var api = APIPatient()
    var helper = Helper()
    var stackFollowup = try! Realm().objects(RealmStackFollowup.self)
    var stackPicture = try! Realm().objects(RealmStackPicture.self)
    var sessionManager = Alamofire.SessionManager.default
    func setTimeout(){
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource = 7 // seconds
        sessionManager = Alamofire.SessionManager(configuration: configuration)
    }
    var system = BackSystem()
    func stackFollowup(meshtag:[String],followup:RealmFollowup,patientid:String,isUpdate:Bool){
        var stack = RealmStackFollowup()
        var mt = List<MeshTag>()
        for i in 0..<meshtag.count{
            var m = MeshTag()
            m.tag = meshtag[i]
            mt.append(m)
        }
        stack.meshtag = mt
        stack.followup = followup
        stack.patientid = patientid
        stack.isUpdate = isUpdate
        try! Realm().add(stack)
    }
    func stackPictures(pic:List<Picture>){
        for i in 0..<pic.count{
            let rp = RealmStackPicture()
            rp.id = pic[i].id
            rp.fulocalid = pic[i].fulocalid
            rp.fudocid = pic[i].fudocid
            rp.patientid = pic[i].patientid
            try! Realm().add(rp)
        }
    }
    func sendStackPicture(){
//        var unknownList = List<RealmStackPicture>()
//        for i in 0..<self.stackPicture.count{
//            if self.findFollowup(id: self.stackPicture[i].fulocalid) != nil{
//                let fu = self.findFollowup(id: self.stackPicture[i].fulocalid)!
//                if fu.id != ""{
//                    let img = self.helper.loadLocalImage(id: self.stackPicture[i].id)
//                    self.api.uploadOPDPictureWithUIImage(sessionID: self.system.getSessionid(), patientid: self.stackPicture[i].patientid, fudocid: self.stackPicture[i].fudocid, image:img , success: {(success) in
//                        if i == self.stackPicture.count-1{
//                            try! Realm().write {
//                                try! Realm().delete(Realm().objects(RealmStackPicture.self))
//                            }
//                            for i in 0..<unknownList.count{
//                                try! Realm().write {
//                                    try! Realm().add(unknownList[i])
//                                }
//                            }
//                        }
//                    }, failure: {(error) in
//                        unknownList.append(self.stackPicture[i])
//                        if i == self.stackPicture.count-1{
//                            try! Realm().write {
//                                try! Realm().delete(Realm().objects(RealmStackPicture.self))
//                            }
//                            for i in 0..<unknownList.count{
//                                try! Realm().write {
//                                    try! Realm().add(unknownList[i])
//                                }
//                            }
//                        }
//                    })
//                }else{
//                    unknownList.append(self.stackPicture[i])
//                    if i == self.stackPicture.count-1{
//                        try! Realm().write {
//                            try! Realm().delete(Realm().objects(RealmStackPicture.self))
//                        }
//                        for i in 0..<unknownList.count{
//                            try! Realm().write {
//                                try! Realm().add(unknownList[i])
//                            }
//                        }
//                    }
//                }
//            }else{
//                
//            }
//        }
    }
    func sendStackFollowup(){
//        for i in 0..<self.stackFollowup.count{
//            var mt = [String]()
//            for j in 0..<self.stackFollowup[i].meshtag.count{
//                mt.append(self.stackFollowup[i].meshtag[j].tag)
//            }
//            if self.stackFollowup[i].isUpdate{
//                self.api.updateFollowUp(sessionID: self.system.getSessionid(), patientid:self.stackFollowup[i].patientid , followupid: self.stackFollowup[i].followup.id, followupnote: self.stackFollowup[i].followup.followupnote, meshtag: mt, opdtag: self.stackFollowup[i].followup.opdtag, followupdate: self.helper.dateToServer(date: self.stackFollowup[i].followup.followdate) , success: {(success) in
//                    print(success)
//                    try! Realm().write{
//                        if let content = success.value(forKey: "content") as? NSDictionary{
//                            if let updatetime = content.value(forKey: "updatetime") as? String{
//                                self.stackFollowup[i].followup.updatetime = self.helper.StringToDate(date: updatetime)
//                            }
//                            if let ID = content.value(forKey: "_id") as? NSDictionary{
//                                if let id = ID.value(forKey: "$id") as? String{
//                                    self.stackFollowup[i].followup.id = id
//                                }
//                            }
//                        }
//                        if i == self.stackFollowup.count-1{
//                            try! Realm().delete(self.stackFollowup)
//                        }
//                    }
//                }, failure: {(error) in
//                    print("Error in "+String(i))
//                })
//            }else{
//                self.api.createFollowup(sessionID: self.system.getSessionid(), patientid: self.stackFollowup[i].patientid, followupnote: self.stackFollowup[i].followup.followupnote, meshtag: mt, opdtag: self.stackFollowup[i].followup.opdtag, followupdate: self.helper.dateToServer(date: self.stackFollowup[i].followup.followdate), success: {(success) in
//                    try! Realm().write{
//                        self.stackFollowup[i].followup.isCreate = false
//                        if let content = success.value(forKey: "content") as? NSDictionary{
//                            if let updatetime = content.value(forKey: "updatetime") as? String{
//                                self.stackFollowup[i].followup.updatetime = self.helper.StringToDate(date: updatetime)
//                            }
//                            if let ID = content.value(forKey: "_id") as? NSDictionary{
//                                if let id = ID.value(forKey: "$id") as? String{
//                                    self.stackFollowup[i].followup.id = id
//                                    print(self.stackFollowup[i].followup.id)
//                                }
//                            }
//                        }
//                        if i == self.stackFollowup.count-1{
//                            try! Realm().delete(self.stackFollowup)
//                        }
//                    }
//                    
//                }, failure: {(error) in
//                    print("Error in "+String(i))
//                })
//            }
//            
//        }
    }
    func findFollowup(id:String) ->RealmFollowup?{
        return try! Realm().objects(RealmFollowup.self).filter(NSPredicate(format: "localid == %@", id)).first
    }
}
