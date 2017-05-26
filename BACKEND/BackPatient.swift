//
//  BackPatient.swift
//  MEDDIC
//
//  Created by Tanakorn on 1/17/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import Foundation
import SwiftyJSON
import Realm
import RealmSwift
class BackPatient{
    var album = CustomPhotoAlbum()
    var physician = try! Realm().objects(RealmPhysician.self).first
    var helper = Helper()
    var color = Color()
    let realm = try! Realm()
    let stack = BackStack()
    var group = try! Realm().objects(RealmGroup.self)
    var patients = try! Realm().objects(RealmPatient.self)
    func recentPatientJSON(dic:NSDictionary){
        let json : JSON = JSON(dic)
        let string : String = json.rawString()!
        try! realm.write {
            let realmJSON = RealmJSON()
            realmJSON.recentJSON = string
            realm.add(realmJSON)
        }
    }
    func updateRecentPatientJSON(dic:NSDictionary){
        let json : JSON = JSON(dic)
        let string : String = json.rawString()!
        try! realm.write {
            let realmJSON = realm.objects(RealmJSON.self).first
            realmJSON?.recentJSON = string
        }
    }
    func isUpdatedRecentPatient(dic:NSDictionary) -> Bool{
        if let array = dic.value(forKey: "content") as? NSArray{
            if array.count > 0 {
                return true
            }else{
                return false
            }
        }
        return false
    }
    func getRecentString() -> String{
        let json = realm.objects(RealmJSON.self)
        if json.count == 0 {
            return ""
        }else{
            return (realm.objects(RealmJSON.self).first?.recentJSON)!
        }
    }
    func getRecentDic(jsonString:String) -> JSON{
        if let dataFromString = jsonString.data(using: .utf8, allowLossyConversion: false) {
            let json = JSON(data: dataFromString)
            return json
        }
        return nil
    }
    func setIsDwonloaded(patient:RealmPatient){
        try! realm.write {
            patient.isDownload = true
        }
    }
    func getLastFuDate(json:JSON) -> String{
        let array = json["content"].arrayValue
        let json = realm.objects(RealmJSON.self)
        if json.count == 0 {
            let patients = self.sortPatientByFuDate()
            if self.patients.count == 0 {
                return ""
            }else{
                return self.helper.dateToString(date: self.patients[0].lastfudate)
            }
        }else{
            if let lastfudate =  array[0]["lastfuupdatetime"].rawValue as? String{
                return lastfudate
            }else{
                return ""
            }
        }
    }
    func getRecentPatientArray(json:JSON) -> [RealmPatient]{
        var patients = [RealmPatient]()
        let array = json["content"].arrayValue
        for content in array{
            let p = RealmPatient()
            
            if let medpayment =  content["medpayment"].rawValue as? String{
                p.medpayment = medpayment
            }else{
                print("medpayment error")
            }
            if let firstname =  content["firstname"].rawValue as? String{
                p.name = firstname
            }else{
                print("firstname error")
            }
            if let middlename =  content["middlename"].rawValue as? String{
                p.name = p.name+" "+middlename
            }else{
                print("middlename error")
            }
            if let lastname = content["lastname"].rawValue as? String{
                p.name = p.name+" "+lastname
            }else{
                print("lastname error")
            }
            if let dob =  content["dob"].rawValue as? String{
                if dob != "00-00-0000" && dob != "-0001-11"{
                    p.dob = self.helper.StringtoDOB(date: dob)
                }else{
                    //p.dob = self.helper.minimumDate()
                }
            }else{
                //p.dob = self.helper.minimumDate()
                print("dob error")
            }
            if let picurl =  content["picurl"].rawValue as? String{
                p.picurl = picurl
            }else{
                print("picurl error")
            }
            if let updatetime =  content["updatetime"].rawValue as? String{
                if updatetime != "0000-00-00 00:00:00" && updatetime != ""{
                    p.updatetime = self.helper.StringToDate(date: updatetime)
                }else{
                    //p.updatetime = self.helper.minimumDate()
                }
            }else{
                //p.updatetime = self.helper.minimumDate()
                print("updatetime error")
            }
            if let _id = content["_id"].rawValue as? NSDictionary{
                if let id = _id.value(forKey: "$id") as? String{
                    p.id = id
                }else{
                    print("id error")
                }
            }else{
                print("_id error")
            }
            if let wardid =  content["wardid"].rawValue as? String{
                p.wardid = wardid
            }else{
                print("wardid error")
            }
            if let lastfudate =  content["lastfudate"].rawValue as? String{
                if lastfudate != "0000-00-00 00:00:00" && lastfudate != ""{
                    p.lastfudate = self.helper.StringToDate(date: lastfudate)
                }else{
                    // p.lastfudate = self.helper.minimumDate()
                }
            }else{
                //p.lastfudate = self.helper.minimumDate()
                print("lastfuupdatetime error")
            }
            if let lastfuupdatetime =  content["lastfuupdatetime"].rawValue as? String{
                if lastfuupdatetime != "0000-00-00 00:00:00" && lastfuupdatetime != ""{
                    p.lastfuupdatetime = self.helper.StringToDate(date: lastfuupdatetime)
                }else{
                    // p.lastfudate = self.helper.minimumDate()
                }
            }else{
                //p.lastfudate = self.helper.minimumDate()
                print("lastfuupdatetime error")
            }
            if let nationality =  content["nationality"].rawValue as? String{
                p.nationality = nationality
            }else{
                print("nationality error")
            }
            if let gender =  content["gender"].rawValue as? String{
                p.gender = gender
            }else{
                print("gender error")
            }
            if let HN =  content["HN"].rawValue as? String{
                p.HN = HN
            }else{
                print("HN error")
            }
            
            if let docuserid =  content["docuserid"].rawValue as? Int{
                p.docuserid = docuserid
            }else{
                print("docuserid error")
            }
            if let age = content["age"].rawValue as? String{
                p.age = age
            }else{
                print("age error")
            }
            //            if let phoneno = content["phoneno"].rawValue as? String{
            //                p.phoneno = phoneno
            //            }else{
            //                print("phoneno error")
            //            }
            patients.append(p)
            
        }
        return patients
    }
    func loadPatientData(dic:NSDictionary){
        if let array = dic.value(forKey: "content") as? NSArray{
            for i in 0..<array.count{
                try! realm.write {
                    let content = array[i] as! NSDictionary
                    var p = RealmPatient()
                    var idd = ""
                    if let _id = content.value(forKey: "_id") as? NSDictionary{
                        if let id = _id.value(forKey: "$id") as? String{
                            if self.getPatient(id: id) != nil{
                                p = self.getPatient(id: id)!
                            }
                            idd = id
                            p.id = id
                        }else{
                            print("id error")
                        }
                    }else{
                        print("_id error")
                    }
                    if let firstname =  content.value(forKey: "firstname") as? String{
                        p.name = firstname
                    }else{
                        print("firstname error")
                    }
                    if let middlename =  content.value(forKey: "middlename") as? String{
                        p.name = p.name+" "+middlename
                    }else{
                        print("middlename error")
                    }
                    if let lastname = content.value(forKey: "lastname") as? String{
                        p.name = p.name+" "+lastname
                    }else{
                        print("lastname error")
                    }
                    if let medpayment =  content.value(forKey: "medpayment") as? String{
                        p.medpayment = medpayment
                    }else{
                        print("medpayment error")
                    }
                    if let opdtag = content.value(forKey: "opdtag") as? String{
                        p.status = opdtag
                    }
                    if let dob =  content.value(forKey: "dob") as? String{
                        if dob != "00-00-0000" && dob != "-0001-11" && dob != ""{
                            p.dob = self.helper.StringtoDOB(date: dob)
                        }else{
                            // p.dob = self.helper.minimumDate()
                        }
                    }else{
                        // p.dob = self.helper.minimumDate()
                        print("dob error")
                    }
                    
                    if let updatetime =  content.value(forKey: "updatetime") as? String{
                        if updatetime != "0000-00-00 00:00:00" && updatetime != ""{
                            p.updatetime = self.helper.StringToDate(date: updatetime)
                        }else{
                            // p.updatetime = self.helper.minimumDate()
                        }
                    }else{
                        //p.updatetime = self.helper.minimumDate()
                        print("updatetime error")
                    }
                    if let lastfuupdatetime =  content.value(forKey: "lastfuupdatetime") as? String{
                        if lastfuupdatetime != "0000-00-00 00:00:00" && lastfuupdatetime != ""{
                            p.lastfuupdatetime = self.helper.StringToDate(date: lastfuupdatetime)
                        }else{
                            // p.lastfudate = self.helper.minimumDate()
                        }
                    }else{
                        //  p.lastfudate = self.helper.minimumDate()
                        print("lastfuupdatetime error")
                    }
                    if let picurl = content.value(forKey: "picurl") as? String{
                        p.picurl = picurl
                        let gid = self.helper.generateID()
                        if p.localid == ""{
                            p.localid = gid
                        }
                        self.helper.saveLocalProfilePic(picurl: picurl, id: gid)
                    }else{
                        print("picurl error")
                    }
                    if let wardid =  content.value(forKey: "wardid") as? String{
                        p.wardid = wardid
                    }else{
                        print("wardid error")
                    }
                    if let lastfudate =  content.value(forKey: "lastfudate") as? String{
                        if lastfudate != "0000-00-00 00:00:00" && lastfudate != "" && lastfudate != nil && lastfudate != "1970-01-01 "{
                            p.lastfudate = self.helper.StringToDate(date: lastfudate)
                        }else{
                            // p.lastfudate = self.helper.minimumDate()
                        }
                    }else{
                        //  p.lastfudate = self.helper.minimumDate()
                        print("lastfudate error")
                    }
                    if let nationality =  content.value(forKey: "nationality") as? String{
                        p.nationality = nationality
                    }else{
                        print("nationality error")
                    }
                    if let gender =  content.value(forKey: "gender") as? String{
                        p.gender = gender
                    }else{
                        print("gender error")
                    }
                    if let HN =  content.value(forKey: "HN") as? String{
                        p.HN = HN
                    }else{
                        print("HN error")
                    }
                    
                    if let docuserid =  content.value(forKey: "docuserid") as? Int{
                        p.docuserid = docuserid
                    }else{
                        print("docuserid error")
                    }
                    if let age = content.value(forKey: "age") as? String{
                        p.age = age
                    }else{
                        print("age error")
                    }
                    if let phoneno = content.value(forKey: "phoneno") as? NSArray{
                        for i in 0..<phoneno.count{
                            let ph = phoneNo()
                            ph.phoneno = phoneno[i] as! String
                            p.phoneno.append(ph)
                        }
                    }else{
                        print("phoneno error")
                    }
                    if let meshtagname = content.value(forKey: "meshtags") as? NSArray{
                        p.meshtag.removeAll()
                        for j in 0..<meshtagname.count{
                            let me = MeshTag()
                            me.tag = meshtagname[j] as! String
                            p.meshtag.append(me)
                        }
                    }
                    if let idno = content.value(forKey: "idno") as? String{
                        p.nationalID = idno
                    }
                    if let residentaddr = content.value(forKey: "residentaddr") as? String{
                        p.address = residentaddr
                    }
                    if let groupid = content.value(forKey: "groupid") as? String{
                        if self.findGroup(id: groupid).first != nil{
                            p.group = self.findGroup(id: groupid).first!
                        }
                        
                    }
                    if self.getPatient(id: idd) == nil{
                        realm.add(p)
                    }
                }
            }
        }
    }
    func loadPatientDataFromGroup(success:NSDictionary){
        if let dic = success.value(forKey: "content") as? NSDictionary{
            if let array = dic.value(forKey: "patients") as? NSArray{
                for i in 0..<array.count{
                    try! realm.write {
                        let content = array[i] as! NSDictionary
                        var p = RealmPatient()
                        var idd = ""
                        if let _id = content.value(forKey: "_id") as? NSDictionary{
                            if let id = _id.value(forKey: "$id") as? String{
                                if self.getPatient(id: id) != nil{
                                    p = self.getPatient(id: id)!
                                }
                                idd = id
                                p.id = id
                            }else{
                                print("id error")
                            }
                        }else{
                            print("_id error")
                        }
                        if let firstname =  content.value(forKey: "firstname") as? String{
                            p.name = firstname
                        }else{
                            print("firstname error")
                        }
                        if let middlename =  content.value(forKey: "middlename") as? String{
                            p.name = p.name+" "+middlename
                        }else{
                            print("middlename error")
                        }
                        if let lastname = content.value(forKey: "lastname") as? String{
                            p.name = p.name+" "+lastname
                        }else{
                            print("lastname error")
                        }
                        if let medpayment =  content.value(forKey: "medpayment") as? String{
                            p.medpayment = medpayment
                        }else{
                            print("medpayment error")
                        }
                        if let opdtag = content.value(forKey: "opdtag") as? String{
                            p.status = opdtag
                        }
                        if let dob =  content.value(forKey: "dob") as? String{
                            if dob != "00-00-0000" && dob != "-0001-11" && dob != ""{
                                p.dob = self.helper.StringtoDOB(date: dob)
                            }else{
                                // p.dob = self.helper.minimumDate()
                            }
                        }else{
                            // p.dob = self.helper.minimumDate()
                            print("dob error")
                        }
                        
                        if let updatetime =  content.value(forKey: "updatetime") as? String{
                            if updatetime != "0000-00-00 00:00:00" && updatetime != ""{
                                p.updatetime = self.helper.StringToDate(date: updatetime)
                            }else{
                                // p.updatetime = self.helper.minimumDate()
                            }
                        }else{
                            //p.updatetime = self.helper.minimumDate()
                            print("updatetime error")
                        }
                        if let lastfuupdatetime =  content.value(forKey: "lastfuupdatetime") as? String{
                            if lastfuupdatetime != "0000-00-00 00:00:00" && lastfuupdatetime != ""{
                                
                                p.lastfuupdatetime = self.helper.StringToDate(date: lastfuupdatetime)
                            }else{
                                // p.lastfudate = self.helper.minimumDate()
                            }
                        }else{
                            //  p.lastfudate = self.helper.minimumDate()
                            print("lastfuupdatetime error")
                        }
                        if let picurl = content.value(forKey: "picurl") as? String{
                            p.picurl = picurl
                            self.helper.saveLocalProfilePic(picurl: picurl, id: p.id)
                        }else{
                            print("picurl error")
                        }
                        if let wardid =  content.value(forKey: "wardid") as? String{
                            p.wardid = wardid
                        }else{
                            print("wardid error")
                        }
                        if let lastfudate =  content.value(forKey: "lastfudate") as? String{
                            if lastfudate != "0000-00-00 00:00:00" && lastfudate != ""{
                                p.lastfudate = self.helper.StringToDate(date: lastfudate)
                            }else{
                                // p.lastfudate = self.helper.minimumDate()
                            }
                        }else{
                            //  p.lastfudate = self.helper.minimumDate()
                            print("lastfudate error")
                        }
                        if let nationality =  content.value(forKey: "nationality") as? String{
                            p.nationality = nationality
                        }else{
                            print("nationality error")
                        }
                        if let gender =  content.value(forKey: "gender") as? String{
                            p.gender = gender
                        }else{
                            print("gender error")
                        }
                        if let HN =  content.value(forKey: "HN") as? String{
                            p.HN = HN
                        }else{
                            print("HN error")
                        }
                        if let meshtagname = content.value(forKey: "meshtags") as? NSArray{
                            p.meshtag.removeAll()
                            for j in 0..<meshtagname.count{
                                let me = MeshTag()
                                me.tag = meshtagname[j] as! String
                                p.meshtag.append(me)
                            }
                        }
                        if let docuserid =  content.value(forKey: "docuserid") as? Int{
                            p.docuserid = docuserid
                        }else{
                            print("docuserid error")
                        }
                        if let age = content.value(forKey: "age") as? String{
                            p.age = age
                        }else{
                            print("age error")
                        }
                        if let phoneno = content.value(forKey: "phoneno") as? NSArray{
                            for i in 0..<phoneno.count{
                                let ph = phoneNo()
                                ph.phoneno = phoneno[i] as! String
                                p.phoneno.append(ph)
                            }
                        }else{
                            print("phoneno error")
                        }
                        if let idno = content.value(forKey: "idno") as? String{
                            p.nationalID = idno
                        }
                        if let residentaddr = content.value(forKey: "residentaddr") as? String{
                            p.address = residentaddr
                        }
                        if let groupid = content.value(forKey: "groupid") as? String{
                            if self.findGroup(id: groupid).first != nil{
                                p.group = self.findGroup(id: groupid).first!
                            }
                            
                        }
                        if self.getPatient(id: idd) == nil{
                            realm.add(p)
                        }
                    }
                }
            }
        }
    }
    func downloadFollowUp(dic:NSDictionary,patient:RealmPatient,isUpdate:Bool){
        try! realm.write {
            if let array = dic.value(forKey: "content") as? NSArray{
                for i in 0..<array.count{
                    var idd = ""
                    if let fu = array[i] as? NSDictionary{
                        var listFollowup = RealmListFollowup()
                        var ckDate : String!
                        if let date = fu.value(forKey: "date") as? String{
                            if self.getListFollowup(date: date,id:patient.id) != nil{
                                listFollowup = self.getListFollowup(date: date,id:patient.id)!
                            }
                            ckDate = date
                            listFollowup.date = self.helper.StringtoDOB(date: date)
                        }
                        let pt = RealmPatient()
                        pt.id = patient.id
                        listFollowup.patient = pt
                        if let list = fu.value(forKey: "followups") as? NSArray{
                            for j in 0..<list.count{
                                if let content = list[j] as? NSDictionary{
                                    var followup = RealmFollowup()
                                    if let _id = content.value(forKey: "_id") as? NSDictionary{
                                        if let id = _id.value(forKey: "$id") as? String{
                                            if self.getFollowup(id: id) != nil{
                                                followup = self.getFollowup(id: id)!
                                            }
                                            idd = id
                                            followup.id = id
                                        }else{
                                            print("id error")
                                        }
                                    }else{
                                        print("id error")
                                    }
                                    if let diseasestatus = content.value(forKey: "diseasestatus") as? Int{
                                        followup.diseasestatus = diseasestatus
                                    }else{
                                        print("diseasestatus error")
                                    }
                                    if let docuserid = content.value(forKey: "docuserid") as? Int{
                                        followup.docuserid = docuserid
                                    }else{
                                        print("docuserid error")
                                    }
                                    if let followtime = content.value(forKey: "followtime") as? String{
                                        followup.followtime = followtime
                                    }
                                    if let followdate = content.value(forKey: "followdate") as? String{
                                        if followdate != nil{
                                            followup.followdate = self.helper.StringToDate(date: followdate)
                                        }
                                    }else{
                                        print("followdate error")
                                    }
                                    if j == 0 && i == 0{
                                        
                                        if let meshtagname = content.value(forKey: "meshtagname") as? NSArray{
                                            //patient.meshtag.removeAll()
                                            followup.meshtag.removeAll()
                                            for j in 0..<meshtagname.count{
                                                let me = MeshTag()
                                                me.tag = meshtagname[j] as! String
                                                me.followupid = followup.id
                                                //patient.meshtag.append(me)
                                                followup.meshtag.append(me)
                                            }
                                        }
                                    }
                                    if let followupnote = content.value(forKey: "followupnote") as? String{
                                        followup.followupnote = followupnote
                                    }else{
                                        print("followupnote error")
                                    }
                                    //                    if let meshtagid = content.value(forKey: "meshtagid") as? String{
                                    //                        followup.meshtagid = meshtagid
                                    //                    }else{
                                    //                        print("meshtagid error")
                                    //                    }
                                    if let patientid = content.value(forKey: "patientid") as? String{
                                        followup.patientid = patientid
                                    }else{
                                        print("patientid error")
                                    }
                                    if let updatetime = content.value(forKey: "updatetime") as? String{
                                        followup.updatetime = self.helper.StringToDate(date: updatetime)
                                        if j == 0 && i == 0{
                                            patient.lastfuupdatetime = self.helper.StringToDate(date: updatetime)
                                        }
                                    }else{
                                        print("updatetime error")
                                        
                                    }
                                    if let array_cusforms = content.value(forKey: "cusforms") as? NSArray{
                                        var iddd = ""
                                        for k in 0..<array_cusforms.count{
                                            var form = CustomFormListAnswer()
                                            if let cusforms = array_cusforms[k] as? NSDictionary{
                                                if let cfansid = cusforms.value(forKey: "cfansid") as? String{
                                                    if self.getCusformAns(id: cfansid) != nil{
                                                        form = self.getCusformAns(id: cfansid)!
                                                    }
                                                    iddd = cfansid
                                                    form.cfansid = cfansid
                                                }
                                                if let color = cusforms.value(forKey: "color") as? String{
                                                    form.color = self.color.frontEndColor(color: color)
                                                }
                                                if let cusformname = cusforms.value(forKey: "cusformname") as? String{
                                                    form.cusfomrname = cusformname
                                                }
                                                if let picurl = cusforms.value(forKey: "picurl") as? String{
                                                    form.picurl = picurl
                                                }
                                                if let score = cusforms.value(forKey: "score") as? Double{
                                                    form.score = score
                                                }
                                                if self.getCusformAns(id: iddd) == nil{
                                                    followup.cusforms.append(form)
                                                }
                                            }
                                        }
                                    }
                                    if followup.picurl.count == 0 {
                                        if let picurl = content.value(forKey: "picurl") as? NSArray{
                                            if let picid = content.value(forKey: "picid") as? NSArray{
                                                for k in 0..<picurl.count{
                                                    let pic = Picture()
                                                    if let id = picid[k] as? String{
                                                        pic.id = id
                                                    }
                                                    if let url = picurl[k] as? String{
                                                        pic.picurl = url
                                                        self.helper.saveLocalProfilePic(picurl: url, id: pic.id)
                                                    }
                                                    followup.picurl.append(pic)
                                                    
                                                }
                                            }
                                        }
                                    }
                                    if let physician = content.value(forKey: "physician") as? NSDictionary{
                                        var physicians = RealmPhysician()
                                        if let name = physician.value(forKey: "name") as? String{
                                            physicians.name = name
                                        }
                                        if let picurl = physician.value(forKey: "picurl") as? String{
                                            physicians.picurl = picurl
                                        }
                                        followup.physician = physicians
                                    }
                                    if self.getFollowup(id: idd) == nil{
                                        if isUpdate{
                                            listFollowup.followup.insert(followup,at:0)
                                        }else{
                                            listFollowup.followup.append(followup)
                                        }
                                    }
                                }
                            }
                        }
                        if self.getListFollowup(date: ckDate,id:patient.id) == nil{
                            patient.listFollowUp.append(listFollowup)
                            
                        }
                    }
                }
            }
        }
    }
    func downloadLastFollowUp(dic:NSDictionary,patient:RealmPatient){
        var followup = RealmFollowup()
        var idd = ""
        try! realm.write {
            if let content = dic.value(forKey: "content") as? NSDictionary{
                if let _id = content.value(forKey: "_id") as? NSDictionary{
                    if let id = _id.value(forKey: "$id") as? String{
                        if self.getFollowup(id: id) != nil{
                            followup = self.getFollowup(id: id)!
                        }
                        followup.id = id
                        idd = id
                    }else{
                        print("id error")
                    }
                }else{
                    print("id error")
                }
                if let diseasestatus = content.value(forKey: "diseasestatus") as? Int{
                    followup.diseasestatus = diseasestatus
                }else{
                    print("diseasestatus error")
                }
                if let docuserid = content.value(forKey: "docuserid") as? Int{
                    followup.docuserid = docuserid
                }else{
                    print("docuserid error")
                }
                if let followdate = content.value(forKey: "followdate") as? String{
                    followup.followdate = self.helper.StringToDate(date: followdate)
                }else{
                    print("followdate error")
                }
                if let meshtagname = content.value(forKey: "meshtagname") as? NSArray{
                    patient.meshtag.removeAll()
                    for j in 0..<meshtagname.count{
                        let me = MeshTag()
                        me.tag = meshtagname[j] as! String
                        patient.meshtag.append(me)
                    }
                }
                if let followupnote = content.value(forKey: "followupnote") as? String{
                    followup.followupnote = followupnote
                }else{
                    print("followupnote error")
                }
                //                    if let meshtagid = content.value(forKey: "meshtagid") as? String{
                //                        followup.meshtagid = meshtagid
                //                    }else{
                //                        print("meshtagid error")
                //                    }
                if let patientid = content.value(forKey: "patientid") as? String{
                    followup.patientid = patientid
                }else{
                    print("patientid error")
                }
                if let updatetime = content.value(forKey: "updatetime") as? String{
                    followup.updatetime = self.helper.StringToDate(date: updatetime)
                }else{
                    print("updatetime error")
                }
                followup.picurl.removeAll()
                if let picurl = content.value(forKey: "picurl") as? NSArray{
                    if let picid = content.value(forKey: "picid") as? NSArray{
                        for j in 0..<picurl.count{
                            let pic = Picture()
                            if let id = picid[j] as? String{
                                pic.id = id
                            }
                            if let url = picurl[j] as? String{
                                pic.picurl = url
                                self.helper.saveLocalProfilePic(picurl: url, id: pic.id)
                            }
                            
                            followup.picurl.append(pic)
                            
                        }
                    }
                }
                if self.getFollowup(id: idd) == nil{
                    patient.followup.append(followup)
                }
            }
        }
    }
    func updatePatientProfile(name:String,HN:String,gender:String,DOB:String,passport:String,nation:String,address:String,telephone:String,payment:String,group:RealmGroup,patient:RealmPatient,isCreate:Bool,id:String,localid:String,isContianPic:Bool){
        try! realm.write {
            let pt = RealmStackPatient()
            patient.name = name
            pt.name = name
            patient.HN = HN
            pt.HN = HN
            patient.gender = gender
            pt.gender = gender
            if DOB == ""{
            }else{
                patient.dob = self.helper.FormatStringToDate(date: DOB)
                pt.dob = self.helper.FormatStringToDate(date: DOB)
                patient.age = String(Date().years(from: patient.dob))+" Y"//+String(Date().months(from: patient.dob))+" M"+String(Date().days(from: patient.dob))+" D"
                pt.age = String(Date().years(from: patient.dob))+" Y"
            }
            patient.nationalID = passport
            pt.nationalID = passport
            patient.nationality = nation
            pt.nationality = nation
            patient.address = address
            pt.address = address
            patient.group = group
            var gr = RealmGroup()
            gr.id = group.id
            pt.group = gr
            var ph = phoneNo()
            if pt.phoneno.count == 0 {
                pt.phoneno.append(ph)
            }
            ph.phoneno = telephone
            if patient.phoneno.count > 0 {
                patient.phoneno[0] = ph
                pt.phoneno[0] = ph
            }else{
                patient.phoneno.append(ph)
                pt.phoneno.append(ph)
            }
            patient.medpayment = payment
            pt.medpayment = payment
            patient.id = id
            pt.id = id
            patient.localid = localid
            pt.localid = localid
            pt.isUpdate = true
            if isContianPic{
                pt.isPic = true
            }else{
                pt.isPic = false
            }
            if isCreate{
                pt.isUpdate = false
                try! Realm().add(patient)
            }
            try! Realm().add(pt)
        }
    }
    func saveProfilePic(image:UIImage,id:String){
        try! realm.write{
            self.helper.saveLocalProfilePicFromImage(image: image, id: id)
        }
    }
    func updateStatus(patient:RealmPatient,status:String){
        try! realm.write {
            patient.status = status
        }
    }
    func createDentFollowUp(date:Date,note:String,extra_image:[DentistClinicalViewController.Image],intra_image:[DentistClinicalViewController.Image],film_image:[DentistClinicalViewController.Image],lime_image:[DentistClinicalViewController.Image],patient:RealmPatient,pic:[DentistClinicalViewController.Image]){
        try! realm.write{
            var lf = RealmListFollowup()
            //if self.findFuByDate(date: self.helper.dateToStringOnlyDate(date: date), patient: patient) != nil
            if self.findFuByDate(date: self.helper.dateToStringOnlyDate(date: date), patient: patient) != nil{
                lf = self.getListFollowup(date: self.helper.dateToStringOnlyDateInFormat(date: date), id: patient.localid)!
            }else{
                lf.patient = RealmPatient()
            }
            lf.patient.id = patient.id
            lf.patient.localid = patient.localid
            lf.date = self.helper.stringToDateOnlyDate(date: self.helper.dateToStringOnlyDate(date: date))
            let fu = RealmFollowup()
            let stackFU = RealmFollowup()
            let idd = self.helper.generateID()
            fu.localid = idd
            stackFU.localid = idd
            stackFU.patientid = patient.id
            fu.followdate = date
            stackFU.followdate = date
            fu.physician = self.physician
            fu.followtime = self.helper.dateToStringOnlyTime(date: date)
            stackFU.followtime = self.helper.dateToStringOnlyTime(date: date)
            fu.followupnote = note
            stackFU.followupnote = note
            fu.patientid = patient.localid
            for i in 0..<pic.count{
                let picurl = Picture()
                picurl.id = pic[i].id
                picurl.picurl = pic[i].id
                picurl.fulocalid = fu.localid
                picurl.fudocid = fu.id
                picurl.patientid = patient.id
                self.helper.saveLocalProfilePicFromImage(image: pic[i].img, id: picurl.id)
                self.album.save(image: pic[i].img)
                fu.picurl.append(picurl)
            }
            for i in 0..<extra_image.count{
                let picurl = Picture()
                picurl.id = self.helper.generateID()
                picurl.picurl = picurl.id
                picurl.fudocid = fu.id
                picurl.patientid = patient.localid
                if extra_image[i].isSet{
                    picurl.type = "image"
                }
                self.helper.saveLocalProfilePicFromImage(image: extra_image[i].img, id: picurl.id)
                if extra_image[i].isSet{
                    picurl.isUpdate = true
                    fu.picurl.append(picurl)
                    self.album.save(image: extra_image[i].img)
                }
                fu.ExternalImage.append(picurl)
                stackFU.ExternalImage.append(picurl)
            }
            for i in 0..<intra_image.count{
                let picurl = Picture()
                picurl.id = self.helper.generateID()
                picurl.picurl = picurl.id
                picurl.fudocid = fu.id
                picurl.patientid = patient.localid
                self.helper.saveLocalProfilePicFromImage(image: intra_image[i].img, id: picurl.id)
                if intra_image[i].isSet{
                    picurl.isUpdate = true
                    fu.picurl.append(picurl)
                    self.album.save(image: intra_image[i].img)
                }
                fu.InternalImage.append(picurl)
                stackFU.InternalImage.append(picurl)
            }
            for i in 0..<film_image.count{
                let picurl = Picture()
                picurl.id = self.helper.generateID()
                picurl.picurl = picurl.id
                picurl.fudocid = fu.id
                picurl.patientid = patient.localid
                self.helper.saveLocalProfilePicFromImage(image: film_image[i].img, id: picurl.id)
                if film_image[i].isSet{
                    picurl.isUpdate = true
                    fu.picurl.append(picurl)
                    self.album.save(image: film_image[i].img)
                }
                fu.Film.append(picurl)
                stackFU.Film.append(picurl)
            }
            for i in 0..<lime_image.count{
                let picurl = Picture()
                picurl.id = self.helper.generateID()
                picurl.picurl = picurl.id
                picurl.fudocid = fu.id
                picurl.patientid = patient.localid
                self.helper.saveLocalProfilePicFromImage(image: lime_image[i].img, id: picurl.id)
                if lime_image[i].isSet{
                    picurl.isUpdate = true
                    fu.picurl.append(picurl)
                    self.album.save(image: lime_image[i].img)
                }
                fu.Lime.append(picurl)
                stackFU.Lime.append(picurl)
            }
            let stack = RealmStackFollowup()
            stack.followup = stackFU
            stack.isUpdate = false
            stack.patientid = stackFU.patientid
            try realm.add(stack)
            lf.followup.insert(fu, at: 0)
            if self.findFuByDate(date: self.helper.dateToStringOnlyDate(date: date), patient: patient) == nil{
                patient.listFollowUp.append(lf)
            }
            if patient.lastfuupdatetime != nil {
                if date > patient.lastfuupdatetime{
                    patient.lastfuupdatetime = date
                }
            }else{
                patient.lastfuupdatetime = date
            }
        }
    }
    func updateFollowUp(date:Date,note:String,hashtag:[String],pic:[ClinicalViewController.Image],followup:RealmFollowup,patient:RealmPatient,status:String,picture:[Picture],listFollowup:RealmListFollowup){
        try! realm.write {
            followup.followtime = self.helper.dateToStringOnlyTime(date: date)
            followup.opdtag = status
            followup.followdate = date
            followup.followupnote = note
            if followup.localid == ""{
                followup.localid = self.helper.generateID()
            }
            patient.meshtag.removeAll()
            for i in 0..<hashtag.count{
                let h = MeshTag()
                h.followupid = followup.id
                h.tag = hashtag[i]
                patient.meshtag.append(h)
                followup.meshtag.append(h)
            }
            followup.picurl.removeAll()
            for i in 0..<pic.count{
                let picurl = Picture()
                picurl.id = pic[i].id
                picurl.picurl = pic[i].id
                picurl.fulocalid = followup.localid
                picurl.fudocid = followup.id
                picurl.patientid = patient.id
                self.helper.saveLocalProfilePicFromImage(image: pic[i].img, id: picurl.id)
                followup.picurl.append(picurl)
            }
            self.stack.stackPictures(pic:followup.picurl)
            if patient.lastfudate != nil{
                if date > patient.lastfudate{
                    patient.lastfudate = date
                    patient.lastfuupdatetime = date
                }
            }else{
                patient.lastfudate = date
                patient.lastfuupdatetime = date
            }
            if !followup.isCreate{
                self.stack.stackFollowup(meshtag: hashtag, followup: followup,patientid:patient.id,isUpdate:true)
            }
            followup.physician = self.physician
            listFollowup.followup.insert(followup, at: 0)
        }
    }
    func createFollowup(date:Date,note:String,hashtag:[String],pic:[ClinicalViewController.Image],patient:RealmPatient,status:String,picture:[Picture],id:String,updatetime:Date){
        try! realm.write {
            var followup = RealmFollowup()
            if patient.lastfudate != nil{
                if date > patient.lastfudate{
                    patient.lastfudate = date
                    patient.lastfuupdatetime = date
                }
            }else{
                patient.lastfudate = date
                patient.lastfuupdatetime = date
            }
            followup.patientid = patient.id
            followup.id = id
            followup.updatetime = updatetime
            followup.localid = self.helper.generateID()
            followup.isCreate = true
            followup.opdtag = status
            followup.followdate = date
            followup.followupnote = note
            followup.followtime = self.helper.dateToStringOnlyTime(date: date)
            patient.meshtag.removeAll()
            for i in 0..<hashtag.count{
                let h = MeshTag()
                h.followupid = followup.id
                h.tag = hashtag[i]
                patient.meshtag.append(h)
                followup.meshtag.append(h)
            }
            followup.picurl.removeAll()
            for i in 0..<pic.count{
                let picurl = Picture()
                picurl.id = pic[i].id
                picurl.picurl = pic[i].id
                picurl.fulocalid = followup.localid
                picurl.fudocid = followup.id
                picurl.patientid = patient.id
                followup.picurl.append(picurl)
                self.helper.saveLocalProfilePicFromImage(image: pic[i].img, id: picurl.id)
            }
            followup.physician = self.physician
            self.stack.stackPictures(pic:followup.picurl)
            self.stack.stackFollowup(meshtag: hashtag, followup: followup,patientid:patient.id,isUpdate:false)
            let listFollowup = RealmListFollowup()
            var pt = RealmPatient()
            pt.id = patient.id
            listFollowup.patient = pt
            listFollowup.date = self.helper.stringToDateOnlyDate(date: self.helper.dateToStringOnlyDate(date: date))
            listFollowup.followup.append(followup)
            patient.listFollowUp.append(listFollowup)
        }
    }
    func enumMeshtag(success:NSDictionary) ->[String]{
        var meshtag = [String]()
        return meshtag
    }
    //    func getLastFollowUp(followUp:List<RealmFollowup>) ->RealmFollowup{
    //        let fu = self.sortFollowup(followUp: followUp)
    //        return fu.first!
    //    }
    //Query
    func searchPatient(name:String) ->[RealmPatient]{
        var patient = [RealmPatient]()
        let patients = try! Realm().objects(RealmPatient.self)
        for i in 0..<patients.count{
            if patients[i].name.uppercased().contains(name.uppercased()) || patients[i].HN.uppercased().contains(name.uppercased()){
                patient.append(patients[i])
            }
        }
        return patient
    }
    
    func sortPatientByName() -> Results<RealmPatient>{
        var temp = realm.objects(RealmPatient.self)
        try! realm.write {
            temp = realm.objects(RealmPatient.self).sorted(byProperty: "name",ascending:true).filter(NSPredicate(format: "group.didSelect = true"))
        }
        return temp
        
    }
    
    func sortPatientByFuDate() ->Results<RealmPatient>{
        return realm.objects(RealmPatient.self).sorted(byProperty: "lastfuupdatetime", ascending: false).filter(NSPredicate(format: "group.didSelect = true AND lastfuupdatetime != nil"))
    }
    func getLastUpdate() ->Date?{
        return try! Realm().objects(RealmPatient.self).sorted(byProperty: "updatetime", ascending: false).first?.updatetime
    }
    func getLastFu() ->Date?{
        return try! Realm().objects(RealmPatient.self).sorted(byProperty: "lastfuupdatetime", ascending: false).first?.lastfuupdatetime
    }
    func searchAvailablePatientGroup(id:String) ->Bool{
        if try! Realm().objects(RealmPatient.self).filter(NSPredicate(format: "group.id == %@", id)).first != nil{
            return true
        }else{
            return false
        }
    }
    func getPatientFollowUp(id:String,date:Int) -> RealmFollowup?{
        let fu = realm.objects(RealmListFollowup.self).filter(NSPredicate(format: "patient.localid == %@",id)).sorted(byProperty: "date", ascending: false)
        switch date {
        case 0:
            return fu.first?.followup.first
        case 1:
            if fu.count > 2 {
                return fu[1].followup.first
            }else{
                return nil
            }
        case 2:
            return fu.last?.followup.last
        default:
            return nil
        }
    }
    func getListPatient(name:String,hn:String) ->Results<RealmPatient>{
        return realm.objects(RealmPatient.self).filter(NSPredicate(format: "name contains[c] %@ OR HN contains[c] %@", name,hn))
    }
    func listPatientListFollowUp(id:String) -> Results<RealmListFollowup>{
        return realm.objects(RealmListFollowup.self).filter(NSPredicate(format: "patient.localid == %@",id)).sorted(byProperty: "date", ascending: true)
    }
    func listPatientFollowUp(id:String) -> Results<RealmFollowup>{
        return realm.objects(RealmFollowup.self).filter(NSPredicate(format: "patientid == %@",id)).sorted(byProperty: "followdate", ascending: true)
    }
    func getPatient(id:String) ->RealmPatient?{
        return realm.objects(RealmPatient.self).filter(NSPredicate(format: "id == %@", id)).first
    }
    func findFuByDate(date:String,patient:RealmPatient) -> RealmListFollowup?{
        return realm.objects(RealmListFollowup.self).filter(NSPredicate(format: "date == %@ AND patient.localid == %@", self.helper.stringToDateOnlyDate(date: date) as NSDate,patient.localid)).first
    }
    func getListFollowup(date:String,id:String) ->RealmListFollowup?{
        return realm.objects(RealmListFollowup.self).filter(NSPredicate(format: "date == %@ AND patient.localid == %@", self.helper.StringtoDOB(date: date) as NSDate,id)).first
    }
    func getFollowup(id:String) ->RealmFollowup?{
        return realm.objects(RealmFollowup.self).filter(NSPredicate(format: "localid == %@", id)).first
    }
    func getCusformAns(id:String) ->CustomFormListAnswer?{
        return realm.objects(CustomFormListAnswer.self).filter(NSPredicate(format: "cfansid == %@", id)).first
    }
    func findPatient(id:String) ->Results<RealmPatient>{
        return realm.objects(RealmPatient.self).filter(NSPredicate(format: "localid == %@", id))
    }
    func getPatientFromGroup(id:String) -> Results<RealmPatient>{
        return realm.objects(RealmPatient.self).filter(NSPredicate(format: "group.id == %@", id))
    }
    func findGroup(id:String) ->Results<RealmGroup>{
        return realm.objects(RealmGroup.self).filter(NSPredicate(format: "id == %@", id))
    }
    func sortFollowup(followUp:List<RealmListFollowup>) ->Results<RealmListFollowup>{
        return followUp.sorted(byProperty: "date", ascending: false)
    }
    func colorStatus(name:String) -> Int{
        let status = try! Realm().objects(RealmStatus.self)
        for i in 0..<status.count{
            if status[i].name == name{
                return status[i].color
            }
        }
        return 0
    }
}
