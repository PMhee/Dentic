//
//  APIAddCustomForm.swift
//  MEDDIC
//
//  Created by Tanakorn on 1/23/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import Foundation
import Alamofire
import RealmSwift
class APIAddCustomForm{
    //var url = "https://smr.cp.eng.chula.ac.th/dev/detnarong/service.php?q=api/"
    var url = "https://smr.cp.eng.chula.ac.th/service.php?q=api/"
    func appID() -> String{
        return "ea5aeea931986e0b82eaaefa9131d777736ac50a"
    }
    func appSecret() -> String{
        return "c51feaa7ecb2a1c61ef9648a5b84ab05"
    }
    struct Row{
        var rowno : Int!
        var question : String!
        var reverse : Bool!
    }
    struct Column{
        var choiceno : Int!
        var name : String!
        var score : String!
    }
    struct  Questions {
        var color : String!
        var rowno : Int!
        var formula : String!
        var questiontype : Int!
        var question : String!
        var required : Bool!
        var row = [Row]()
        var column = [Column]()
    }
    var helper = Helper()
    let system = BackSystem()
    func genHeader() -> [String:String]{
        return ["deeappid":appID(),"deeappsecret":appSecret(),"deesessionid":self.system.getSessionid()]
    }
    var sessionManager = Alamofire.SessionManager.default
    func setTimeout(){
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource = 7 // seconds
        sessionManager = Alamofire.SessionManager(configuration: configuration)
    }
    var color = Color()
    func getYoutubeMeta(sessionid:String,videoid:String,success: @escaping (_ response: NSDictionary) -> Void,failure: @escaping (_ error: NSError?) -> Void){
        self.setTimeout()
        let code = "https://www.youtube.com/oembed?url=\(videoid)&format=json"
        Alamofire.request(code, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil)
            .responseString { response in
                print("Success: \(response.result.isSuccess)")
                //print("Response String: \(response.result.value)")
                if response.result.isSuccess{
                }
            }
            .responseJSON { response in
                //debugPrint(response.result.value)
                if response.result.isSuccess{
                    success((response.result.value as? NSDictionary)!)
                }else{
                    failure(NSError(domain: "Slow Internet Connection", code: 401, userInfo: nil))
                }
                
        }
    }
    func createCFCover(sessionid:String,name:String,description:String,meshtagid:[String],formula:[String],color:Int,picurl:String,success: @escaping (_ response: NSDictionary) -> Void,failure: @escaping (_ error: NSError?) -> Void){
        self.setTimeout()
        let code = "\(self.url)updateCfCover"
        let parameter = ["post[name]":name,"post[description]":description,"post[meshtagid]":meshtagid,"post[formula]":formula.description,"post[color]":self.color.backEndColor(color: color),"post[picurl]":picurl] as [String : Any]
        Alamofire.request(code, method: .post, parameters: parameter, encoding: URLEncoding.default, headers: self.genHeader())
            .responseString { response in
                print("Success: \(response.result.isSuccess)")
                //print("Response String: \(response.result.value)")
                if response.result.isSuccess{
                }
            }
            .responseJSON { response in
                
                //debugPrint(response.result.value)
                if response.result.isSuccess{
                    success((response.result.value as? NSDictionary)!)
                }else{
                    
                    failure(NSError(domain: "Slow Internet Connection", code: 401, userInfo: nil))
                }
                
        }
    }
    func updateCFCover(sessionid:String,cusformid:String,name:String,description:String,meshtagid:[String],color:Int,picurl:String,success: @escaping (_ response: NSDictionary) -> Void,failure: @escaping (_ error: NSError?) -> Void){
        self.setTimeout()
        let code = "\(self.url)updateCfCover"
        let parameter = ["cusformid":cusformid,"post[name]":name,"post[description]":description,"post[meshtagid]":meshtagid.description,"post[color]":self.color.backEndColor(color: color),"post[picurl]":picurl] as [String : Any]
        Alamofire.request(code, method: .post, parameters: parameter, encoding: URLEncoding.default, headers: self.genHeader())
            .responseString { response in
                print("Success: \(response.result.isSuccess)")
                //print("Response String: \(response.result.value)")
                if response.result.isSuccess{
                }
            }
            .responseJSON { response in
                //debugPrint(response.result.value)
                if response.result.isSuccess{
                    success((response.result.value as? NSDictionary)!)
                }else{
                    failure(NSError(domain: "Slow Internet Connection", code: 401, userInfo: nil))
                }
                
                
        }
    }
    func updateCFCoverFormula(sessionid:String,cusformid:String,formula:[String],success: @escaping (_ response: NSDictionary) -> Void,failure: @escaping (_ error: NSError?) -> Void){
        self.setTimeout()
        let code = "\(self.url)updateCfCover"
        let parameter = ["cusformid":cusformid,"post[formula]":formula.description] as [String : Any]
        Alamofire.request(code, method: .post, parameters: parameter, encoding: URLEncoding.default, headers: self.genHeader())
            .responseString { response in
                print("Success: \(response.result.isSuccess)")
                //print("Response String: \(response.result.value)")
                if response.result.isSuccess{
                }
            }
            .responseJSON { response in
                //debugPrint(response.result.value)
                if response.result.isSuccess{
                    success((response.result.value as? NSDictionary)!)
                }else{
                    failure(NSError(domain: "Slow Internet Connection", code: 401, userInfo: nil))
                }
                
                
        }
    }
    func createCFSection(sessionid:String,cusformid:String, sectionno:String, name:String, description:String,formula:[String], color:String,success: @escaping (_ response: NSDictionary) -> Void,failure: @escaping (_ error: NSError?) -> Void){
        self.setTimeout()
        let code = "\(self.url)updateCfSection"
        let parameter = ["post[cusformid]":cusformid,"post[sectionno]":sectionno,"post[name]":name,"post[description]":description,"post[color]":color,"post[formula]":formula] as [String : Any]
        
        Alamofire.request(code, method: .post, parameters: parameter, encoding: URLEncoding.default, headers: self.genHeader())
            .responseString { response in
                print("Success: \(response.result.isSuccess)")
                //print("Response String: \(response.result.value)")
                if response.result.isSuccess{
                }
            }
            .responseJSON { response in
                //debugPrint(response.result.value)
                if response.result.isSuccess{
                    success((response.result.value as? NSDictionary)!)
                }else{
                    failure(NSError(domain: "Slow Internet Connection", code: 401, userInfo: nil))
                }
        }
    }
    func listCfPresetIcon(sessionid:String,success: @escaping (_ response: NSDictionary) -> Void,failure: @escaping (_ error: NSError?) -> Void){
        self.setTimeout()
        let code = "\(self.url)listCfPresetIcon&data=true"
        Alamofire.request(code, method: .get, parameters: nil, encoding: URLEncoding.default, headers: self.genHeader())
            .responseString { response in
                print("Success: \(response.result.isSuccess)")
                //print("Response String: \(response.result.value)")
                if response.result.isSuccess{
                }
            }
            .responseJSON { response in
                // debugPrint(response.result.value)
                if response.result.isSuccess{
                    success((response.result.value as? NSDictionary)!)
                }else{
                    failure(NSError(domain: "Slow Internet Connection", code: 401, userInfo: nil))
                }
                
        }
    }
    func getCusform(sessionid:String,cusformid:String,success: @escaping (_ response: NSDictionary) -> Void,failure: @escaping (_ error: NSError?) -> Void){
        self.setTimeout()
        let code = "\(self.url)getCusform&cusformid=\(cusformid)&data=true"
        Alamofire.request(code, method: .get, parameters: nil, encoding: URLEncoding.default, headers: self.genHeader())
            .responseString { response in
                print("Success: \(response.result.isSuccess)")
                //print("Response String: \(response.result.value)")
                if response.result.isSuccess{
                }
            }
            .responseJSON { response in
                //debugPrint(response.result.value)
                if response.result.isSuccess{
                    success((response.result.value as? NSDictionary)!)
                }else{
                    failure(NSError(domain: "Slow Internet Connection", code: 401, userInfo: nil))
                }
                
        }
    }
    func updateCFSection(sessionid:String,sectionid:String,cusformid:String, sectionno:String, name:String, description:String, color:Int,success: @escaping (_ response: NSDictionary) -> Void,failure: @escaping (_ error: NSError?) -> Void){
        self.setTimeout()
        let code = "\(self.url)updateCfSection"
        let parameter = ["sectionid":sectionid,"post[cusformid]":cusformid,"post[sectionno]":sectionno,"post[name]":name,"post[description]":description,"post[color]":self.color.backEndColor(color: color)] as [String : Any]
        Alamofire.request(code, method: .post, parameters: parameter, encoding: URLEncoding.default, headers: self.genHeader())
            .responseString { response in
                print("Success: \(response.result.isSuccess)")
                //print("Response String: \(response.result.value)")
                if response.result.isSuccess{
                }
            }
            .responseJSON { response in
                //debugPrint(response.result.value)
                if response.result.isSuccess{
                    success((response.result.value as? NSDictionary)!)
                }else{
                    failure(NSError(domain: "Slow Internet Connection", code: 401, userInfo: nil))
                }
        }
    }
    func updateCFSectionFormula(sessionid:String,sectionid:String,cusformid:String,formula:[String],success: @escaping (_ response: NSDictionary) -> Void,failure: @escaping (_ error: NSError?) -> Void){
        self.setTimeout()
        let code = "\(self.url)updateCfSection"
        let parameter = ["sectionid":sectionid,"post[cusformid]":cusformid,"post[formula]":formula.description] as [String : Any]
        Alamofire.request(code, method: .post, parameters: parameter, encoding: URLEncoding.default, headers: self.genHeader())
            .responseString { response in
                print("Success: \(response.result.isSuccess)")
                //print("Response String: \(response.result.value)")
                if response.result.isSuccess{
                }
            }
            .responseJSON { response in
                //debugPrint(response.result.value)
                if response.result.isSuccess{
                    success((response.result.value as? NSDictionary)!)
                }else{
                    failure(NSError(domain: "Slow Internet Connection", code: 401, userInfo: nil))
                }
        }
    }
    func createCFQuestion(sessionid:String,sectionid:String,questiontype:String,questionno:String,question:String,rows:[CustomFormGridOption],columns:[CustomFormOption],required:Bool,success: @escaping (_ response: NSDictionary) -> Void,failure: @escaping (_ error: NSError?) -> Void){
        self.setTimeout()
        var qt = 0
        switch questiontype {
        case "checkbox":
            qt = 1
        case "drop":
            qt = 2
        case "multiple":
            qt = 3
        case "slider":
            qt = 4
        case "grid":
            qt = 5
        case "text":
            qt = 6
        case "number":
            qt = 7
        case "calendar":
            qt = 8
        case "pictures":
            qt = 9
        case "video":
            qt = 10
        default:
            print("error")
        }
        var q = Questions()
        if qt == 5 {
            for j in 0..<rows.count{
                var row = Row()
                row.question = rows[j].question
                row.reverse = rows[j].reverse
                row.rowno = Int(j)
                q.row.append(row)
            }
        }
        for j in 0..<columns.count{
            var column = Column()
            column.choiceno = Int(j)
            column.name = columns[j].question
            column.score = columns[j].point
            q.column.append(column)
        }
        var ch = [[String:Any]]()
        for j in 0..<q.column.count{
            let c : [String:Any] = ["choiceno":q.column[j].choiceno,"name":q.column[j].name,"score":q.column[j].score]
            ch.append(c)
        }
        var qr = [[String:Any]]()
        for j in 0..<q.row.count{
            let r : [String:Any] = ["rowno":q.row[j].rowno,"question":q.row[j].question,"inversescore":q.row[j].reverse]
            qr.append(r)
        }
        let code = "\(self.url)updateCfQuestion"
        var parameter = [String:Any]()
        if qt == 5 {
            parameter = ["post[sectionid]":sectionid,"post[questionno]":questionno,"post[question]":question,"post[questionrows]":self.jsonEncoding(dic: qr),"post[questiontype]":qt,"post[choices]":self.jsonEncoding(dic: ch),"post[required]":required] as [String : Any]
        }else{
            if columns.count == 0 {
                parameter = ["post[sectionid]":sectionid,"post[questionno]":questionno,"post[question]":question,"post[questiontype]":qt,"post[required]":required] as [String : Any]
            }else{
                parameter = ["post[sectionid]":sectionid,"post[questionno]":questionno,"post[question]":question,"post[questiontype]":qt,"post[choices]":self.jsonEncoding(dic: ch),"post[required]":required] as [String : Any]
            }
            
        }
        Alamofire.request(code, method: .post, parameters: parameter, encoding: URLEncoding.default, headers: self.genHeader())
            .responseString { response in
                
                print("Success: \(response.result.isSuccess)")
                //print("Response String: \(response.result.value)")
                if response.result.isSuccess{
                }
            }
            
            .responseJSON { response in
                //debugPrint(response.result.value)
                if response.result.isSuccess{
                    success((response.result.value as? NSDictionary)!)
                }else{
                    failure(NSError(domain: "Slow Internet Connection", code: 401, userInfo: nil))
                }
                
        }
    }
    func updateCFQuestion(sessionid:String,questionid:String,sectionid:String,questiontype:String,questionno:String,question:String,rows:[CustomFormGridOption],columns:[CustomFormOption],required:Bool,color:Int,success: @escaping (_ response: NSDictionary) -> Void,failure: @escaping (_ error: NSError?) -> Void){
        self.setTimeout()
        var qt = 0
        switch questiontype {
        case "checkbox":
            qt = 1
        case "drop":
            qt = 2
        case "multiple":
            qt = 3
        case "slider":
            qt = 4
        case "grid":
            qt = 5
        case "text":
            qt = 6
        case "number":
            qt = 7
        case "calendar":
            qt = 8
        case "pictures":
            qt = 9
        case "video":
            qt = 10
        default:
            print("error")
        }
        var q = Questions()
        if qt == 5 {
            for j in 0..<rows.count{
                var row = Row()
                row.question = rows[j].question
                row.reverse = rows[j].reverse
                row.rowno = Int(j)
                q.row.append(row)
            }
        }
        for j in 0..<columns.count{
            var column = Column()
            column.choiceno = Int(j)
            column.name = columns[j].question
            column.score = columns[j].point
            q.column.append(column)
        }
        var ch = [[String:Any]]()
        for j in 0..<q.column.count{
            let c : [String:Any] = ["choiceno":q.column[j].choiceno,"name":q.column[j].name,"score":q.column[j].score]
            ch.append(c)
        }
        var qr = [[String:Any]]()
        for j in 0..<q.row.count{
            let r : [String:Any] = ["rowno":q.row[j].rowno,"question":q.row[j].question,"inversescore":q.row[j].reverse]
            qr.append(r)
        }
        let code = "\(self.url)updateCfQuestion"
        var parameter = [String:Any]()
        if qt == 5 {
            parameter = ["questionid":questionid,"post[sectionid]":sectionid,"post[questionno]":questionno,"post[question]":question,"post[questionrows]":self.jsonEncoding(dic: qr),"post[choices]":self.jsonEncoding(dic: ch),"post[questiontype]":qt,"post[required]":required,"post[color]":self.color.backEndColor(color: color)] as [String : Any]
        }else{
            if columns.count == 0 {
                parameter = ["questionid":questionid,"post[sectionid]":sectionid,"post[questionno]":questionno,"post[question]":question,"post[questiontype]":qt,"post[required]":required,"post[color]":self.color.backEndColor(color: color)] as [String : Any]
            }else{
                parameter = ["questionid":questionid,"post[sectionid]":sectionid,"post[questionno]":questionno,"post[question]":question,"post[choices]":self.jsonEncoding(dic: ch),"post[required]":required,"post[questiontype]":qt,"post[color]":self.color.backEndColor(color: color)] as [String : Any]
            }
        }
        Alamofire.request(code, method: .post, parameters: parameter, encoding: URLEncoding.default, headers: self.genHeader())
            .responseString { response in
                print("Success: \(response.result.isSuccess)")
                //print("Response String: \(response.result.value)")
                if response.result.isSuccess{
                }
            }
            .responseJSON { response in
                //debugPrint(response.result.value)
                if response.result.isSuccess{
                    success((response.result.value as? NSDictionary)!)
                }else{
                    failure(NSError(domain: "Slow Internet Connection", code: 401, userInfo: nil))
                }
        }
    }
    func listUpdatedCusform(sessionid:String,updatetime:String,success: @escaping (_ response: NSDictionary) -> Void,failure: @escaping (_ error: NSError?) -> Void){
        self.setTimeout()
        let code = "\(self.url)listUpdatedCusform"
        let parameter = ["updatetime":updatetime,"data":"true"] as [String : Any]
        Alamofire.request(code, method: .post, parameters: parameter, encoding: URLEncoding.default, headers: self.genHeader())
            .responseString { response in
                print("Success: \(response.result.isSuccess)")
                //print("Response String: \(response.result.value)")
                if response.result.isSuccess{
                }
            }
            .responseJSON { response in
                //debugPrint(response.result.value)
                if response.result.isSuccess{
                    success((response.result.value as? NSDictionary)!)
                }else{
                    failure(NSError(domain: "Slow Internet Connection", code: 401, userInfo: nil))
                }
        }
    }
    //Answer
    func updateCfAnswer(sessionid:String,cfanswerid:String,form:CustomForm,answer:List<CustomFormSectionAns>,pictures:[ShowCustomFormViewController.Pic],eflag:String,patientid:String,fudocid:String,success: @escaping (_ response: NSDictionary) -> Void,failure: @escaping (_ error: NSError?) -> Void){
        self.setTimeout()
        var answers = [[String:Any]]()
        for i in 0..<answer.count{
            var a = [[String:Any]]()
            for j in 0..<answer[i].answer.count{
                var ans = [String:Any]()
                
                if answer[i].answer[j].type == "checkbox"{
                    var cb = [String]()
                    for k in 0..<answer[i].answer[j].checked.count{
                        cb.append(answer[i].answer[j].checked[k].answer)
                    }
                    ans = ["questionid":form.section[i].form[j].id,"answer": cb]
                }else if answer[i].answer[j].type == "multiple"{
                    for k in 0..<answer[i].answer[j].checked.count{
                        ans = ["questionid":form.section[i].form[j].id,"answer":answer[i].answer[j].checked[k].answer]
                    }
                }else if answer[i].answer[j].type == "grid"{
                    var g = [[String:Any]]()
                    for k in 0..<answer[i].answer[j].answerGrid.count{
                        var gr = [String:Any]()
                        for l in 0..<answer[i].answer[j].answerGrid[k].checked.count{
                            gr = ["rowno":k,"ans":answer[i].answer[j].answerGrid[k].checked[l].answer] as [String:Any]
                        }
                        g.append(gr)
                    }
                     ans = ["questionid":form.section[i].form[j].id,"answer": g]
                }else if answer[i].answer[j].type == "calendar"{
                    ans = ["questionid":form.section[i].form[j].id,"answer":self.helper.MediumDateStringToString(date: answer[i].answer[j].answer)]
                }else if answer[i].answer[j].type == "drop"{
                    for k in 0..<form.section[i].form[j].option.count{
                        if form.section[i].form[j].option[k].question == answer[i].answer[j].answer{
                            ans = ["questionid":form.section[i].form[j].id,"answer": String(k)]
                            break
                        }
                    }
                }else{
                    ans = ["questionid":form.section[i].form[j].id,"answer":answer[i].answer[j].answer]
                }
                a.append(ans)
            }
            let ans : [String:Any] = ["sectionid":form.section[i].id,"answers":a]
            answers.append(ans)
        }
                let code = "\(self.url)updateCfAnswer"
        let parameter = ["patientid":patientid,"cusformid":form.id,"cfanswerid":cfanswerid,"anssections":self.jsonEncoding(dic: answers),"eflag":eflag,"fudocid":fudocid] as [String : Any]
                Alamofire.request(code, method: .post, parameters: parameter, encoding: URLEncoding.default, headers: self.genHeader())
                    .responseString { response in
                        print("Success: \(response.result.isSuccess)")
                        //print("Response String: \(response.result.value)")
                        if response.result.isSuccess{
                        }
                    }
                    .responseJSON { response in
                        //debugPrint(response.result.value)
                        if response.result.isSuccess{
                            success((response.result.value as? NSDictionary)!)
                        }else{
                            failure(NSError(domain: "Slow Internet Connection", code: 401, userInfo: nil))
                        }
                }
    }
    func answerQuestion(sessionid:String,cfanswerid:String,eflag:String,image:ShowCustomFormViewController.Pic,cusform:CustomForm,success: @escaping (_ response: NSDictionary) -> Void,failure: @escaping (_ error: String) -> Void){
        let code = "\(self.url)answerQuestion"
        let parameters = ["appid":appID(),"appsecret":appSecret(),"sessionid":sessionid,"cfanswerid":cfanswerid,"questionid":cusform.section[image.section].form[image.question].id,"eflag":eflag] as [String : String]
        Alamofire.upload(multipartFormData: {(multiple) in
            if let data = UIImageJPEGRepresentation(image.img,1.0) {
                multiple.append(data, withName: "picfile", fileName: "picfile.jpg", mimeType: "image/jpeg")
            }
            for (key, value) in parameters {
                multiple.append(value.data(using: String.Encoding.utf8)!, withName: key)
                //multiple.append(data: value.data(using: String.Encoding.utf8)! , name: key)
            }
        }, to: code, encodingCompletion: {(complete) in
            switch complete {
            case .success(let upload, _, _):
                upload.responseJSON {
                    response in
                    print(response.request)  // original URL request
                    print(response.response) // URL response
                    print(response.data)     // server data
                    print(response.result)   // result of response serialization
                    if let JSON = response.result.value {
                        success(JSON as! NSDictionary)
                        print("JSON: \(JSON)")
                    }
                }
            case .failure(let encodingError):
                print(encodingError)
            }
        })
    }
    func commitCusform(sessionid:String,cfanswerid:String,success: @escaping (_ response: NSDictionary) -> Void,failure: @escaping (_ error: NSError?) -> Void){
        self.setTimeout()
        let code = "\(self.url)commitCusform"
        let parameter = ["appid":appID(),"appsecret":appSecret(),"sessionid":sessionid,"cfanswerid":cfanswerid] as [String : Any]
        Alamofire.request(code, method: .post, parameters: parameter, encoding: URLEncoding.default, headers: nil)
            .responseString { response in
                print("Success: \(response.result.isSuccess)")
                //print("Response String: \(response.result.value)")
                if response.result.isSuccess{
                }
            }
            .responseJSON { response in
                //debugPrint(response.result.value)
                if response.result.isSuccess{
                    success((response.result.value as? NSDictionary)!)
                }else{
                    failure(NSError(domain: "Slow Internet Connection", code: 401, userInfo: nil))
                }
        }
    }
    func getAnswerWithDetail(cfanswerid:String,success: @escaping (_ response: NSDictionary) -> Void,failure: @escaping (_ error: NSError?) -> Void){
        self.setTimeout()
        let code = "\(self.url)getAnswerWithDetail"
        let parameter = ["cfanswerid":cfanswerid,"data":"true"] as [String : Any]
        Alamofire.request(code, method: .get, parameters: parameter, encoding: URLEncoding.default, headers: self.genHeader())
            .responseString { response in
                print("Success: \(response.result.isSuccess)")
                //print("Response String: \(response.result.value)")
                if response.result.isSuccess{
                }
            }
            .responseJSON { response in
                //debugPrint(response.result.value)
                if response.result.isSuccess{
                    success((response.result.value as? NSDictionary)!)
                }else{
                    failure(NSError(domain: "Slow Internet Connection", code: 401, userInfo: nil))
                }
        }
    }
    func jsonEncoding(dic:[[String:Any]]) -> String{
        do {
            let jsonData : Data = try JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted)
            return NSString(data: jsonData as Data, encoding: String.Encoding.utf8.rawValue)! as String
        } catch {
            print(error.localizedDescription)
            return "error"
        }
    }
    func jsonStringEncoding(dic:[String]) -> String{
        do {
            let jsonData : Data = try JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted)
            return NSString(data: jsonData as Data, encoding: String.Encoding.utf8.rawValue)! as String
        } catch {
            print(error.localizedDescription)
            return "error"
        }
    }
    func jsonIntEncoding(dic:[Int]) -> String{
        do {
            let jsonData : Data = try JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted)
            return NSString(data: jsonData as Data, encoding: String.Encoding.utf8.rawValue)! as String
        } catch {
            print(error.localizedDescription)
            return "error"
        }
    }
    func jsonArrayEncoding(dic:[String:Any]) -> String{
        do {
            let jsonData : Data = try JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted)
            return NSString(data: jsonData as Data, encoding: String.Encoding.utf8.rawValue)! as String
        } catch {
            print(error.localizedDescription)
            return "error"
        }
    }
}
