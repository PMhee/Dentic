//
//  APIPatient.swift
//  MEDDIC
//
//  Created by Tanakorn on 1/17/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import Foundation
import Alamofire
class APIPatient{
    //var url = "https://smr.cp.eng.chula.ac.th/dev/detnarong/service.php?q=api/"
    var url = "https://smr.cp.eng.chula.ac.th/service.php?q=api/"
    var url_rest = "https://smr.cp.eng.chula.ac.th/rest.php/"
    //var url_rest = "https://smr.cp.eng.chula.ac.th/dev/detnarong/rest.php/"
    func appID() -> String{
        return "ea5aeea931986e0b82eaaefa9131d777736ac50a"
    }
    func appSecret() -> String{
        return "c51feaa7ecb2a1c61ef9648a5b84ab05"
    }
    let system = BackSystem()
    func genHeader() -> [String:String]{
        return ["deeappid":appID(),"deeappsecret":appSecret(),"deesessionid":self.system.getSessionid()]
    }
    let config = URLSessionConfiguration.background(withIdentifier: "com.example.app.background")
    var sessionManager = Alamofire.SessionManager.default
    func setTimeout(){
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource = 7 // seconds
        sessionManager = Alamofire.SessionManager(configuration: configuration)
    }

    func searchRecents(sessionid:String,success: @escaping (_ response: NSDictionary) -> Void,failure: @escaping  (_ error: String) -> Void){
        let code = "\(self.url)searchRecents"
        let parameter = ["data":"true"] as [String : Any]
        self.setTimeout()
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
                    failure("searchRecents error")
                }
        }
    }
    func listUpdatedRecents(sessionid:String,updatetime:String,success: @escaping (_ response: NSDictionary) -> Void,failure: @escaping  (_ error: String) -> Void){
        self.setTimeout()
        let parameter = ["updatetime":updatetime,"data":"true"] as [String : Any]
        let code = "\(self.url)listUpdatedRecents"
        Alamofire.request(code, method: .get, parameters: parameter, encoding: URLEncoding.default, headers: self.genHeader())
            .responseString { response in
                print("Success: \(response.result.isSuccess)")
                var statusCode = response.response?.statusCode
                if response.result.isSuccess{
                    
                }else{
                if let error = response.result.error as? AFError {
                    statusCode = error._code // statusCode private
                    switch error {
                    case .invalidURL(let url):
                        print("Invalid URL: \(url) - \(error.localizedDescription)")
                    case .parameterEncodingFailed(let reason):
                        print("Parameter encoding failed: \(error.localizedDescription)")
                        print("Failure Reason: \(reason)")
                    case .multipartEncodingFailed(let reason):
                        print("Multipart encoding failed: \(error.localizedDescription)")
                        print("Failure Reason: \(reason)")
                    case .responseValidationFailed(let reason):
                        print("Response validation failed: \(error.localizedDescription)")
                        print("Failure Reason: \(reason)")
                        switch reason {
                        case .dataFileNil, .dataFileReadFailed:
                            print("Downloaded file could not be read")
                        case .missingContentType(let acceptableContentTypes):
                            print("Content Type Missing: \(acceptableContentTypes)")
                        case .unacceptableContentType(let acceptableContentTypes, let responseContentType):
                            print("Response content type: \(responseContentType) was unacceptable: \(acceptableContentTypes)")
                        case .unacceptableStatusCode(let code):
                            print("Response status code was unacceptable: \(code)")
                            statusCode = code
                        }
                    case .responseSerializationFailed(let reason):
                        print("Response serialization failed: \(error.localizedDescription)")
                        print("Failure Reason: \(reason)")
                        // statusCode = 3840 ???? maybe..
                    }
                }else{
                    failure("internet error")
                    }
                }
            }
            .responseJSON { response in
                //debugPrint(response.result.value)
                if response.result.isSuccess{
                    success((response.result.value as? NSDictionary)!)
                }
                
        }
    }
    func listUpdatedPatient(sessionid:String,updatetime:String,offset:String,limit:String,data:String,success: @escaping (_ response: NSDictionary) -> Void,failure: @escaping  (_ error: String) -> Void){
        self.setTimeout()
        let parameter = ["updatetime":updatetime,"data":data,"offset":offset,"limit":limit,"sort":"updatetime:-1"] as [String : Any]
        let code = "\(self.url)listUpdatedPatient"
        Alamofire.request(code, method: .get, parameters: parameter, encoding: URLEncoding.default, headers: self.genHeader())
            .responseString { response in
                print("Success: \(response.result.isSuccess)")
                var statusCode = response.response?.statusCode
                if response.result.isSuccess{
                    
                }else{
                    if let error = response.result.error as? AFError {
                        statusCode = error._code // statusCode private
                        switch error {
                        case .invalidURL(let url):
                            print("Invalid URL: \(url) - \(error.localizedDescription)")
                        case .parameterEncodingFailed(let reason):
                            print("Parameter encoding failed: \(error.localizedDescription)")
                            print("Failure Reason: \(reason)")
                        case .multipartEncodingFailed(let reason):
                            print("Multipart encoding failed: \(error.localizedDescription)")
                            print("Failure Reason: \(reason)")
                        case .responseValidationFailed(let reason):
                            print("Response validation failed: \(error.localizedDescription)")
                            print("Failure Reason: \(reason)")
                            switch reason {
                            case .dataFileNil, .dataFileReadFailed:
                                print("Downloaded file could not be read")
                            case .missingContentType(let acceptableContentTypes):
                                print("Content Type Missing: \(acceptableContentTypes)")
                            case .unacceptableContentType(let acceptableContentTypes, let responseContentType):
                                print("Response content type: \(responseContentType) was unacceptable: \(acceptableContentTypes)")
                            case .unacceptableStatusCode(let code):
                                print("Response status code was unacceptable: \(code)")
                                statusCode = code
                            }
                        case .responseSerializationFailed(let reason):
                            print("Response serialization failed: \(error.localizedDescription)")
                            print("Failure Reason: \(reason)")
                            // statusCode = 3840 ???? maybe..
                        }
                    }else{
                        failure("internet error")
                    }
                }
            }
            .responseJSON { response in
                //debugPrint(response.result.value)
                if response.result.isSuccess{
                    success((response.result.value as? NSDictionary)!)
                }
                
        }
    }
    func getFollowUp(sessionid:String,patientid:String,success: @escaping (_ response: NSDictionary) -> Void,failure: @escaping  (_ error: String) -> Void){
        self.setTimeout()
        let parameter = ["patientid":patientid,"data":"true"] as [String : Any]
        let code = "\(self.url)getFollowUp"
        Alamofire.request(code, method: .get, parameters: parameter, encoding: URLEncoding.default, headers: self.genHeader())
            .responseString { response in
                print("Success: \(response.result.isSuccess)")
                var statusCode = response.response?.statusCode
                if response.result.isSuccess{
                    
                }else{
                    if let error = response.result.error as? AFError {
                        statusCode = error._code // statusCode private
                        switch error {
                        case .invalidURL(let url):
                            print("Invalid URL: \(url) - \(error.localizedDescription)")
                        case .parameterEncodingFailed(let reason):
                            print("Parameter encoding failed: \(error.localizedDescription)")
                            print("Failure Reason: \(reason)")
                        case .multipartEncodingFailed(let reason):
                            print("Multipart encoding failed: \(error.localizedDescription)")
                            print("Failure Reason: \(reason)")
                        case .responseValidationFailed(let reason):
                            print("Response validation failed: \(error.localizedDescription)")
                            print("Failure Reason: \(reason)")
                            switch reason {
                            case .dataFileNil, .dataFileReadFailed:
                                print("Downloaded file could not be read")
                            case .missingContentType(let acceptableContentTypes):
                                print("Content Type Missing: \(acceptableContentTypes)")
                            case .unacceptableContentType(let acceptableContentTypes, let responseContentType):
                                print("Response content type: \(responseContentType) was unacceptable: \(acceptableContentTypes)")
                            case .unacceptableStatusCode(let code):
                                print("Response status code was unacceptable: \(code)")
                                statusCode = code
                            }
                        case .responseSerializationFailed(let reason):
                            print("Response serialization failed: \(error.localizedDescription)")
                            print("Failure Reason: \(reason)")
                            // statusCode = 3840 ???? maybe..
                        }
                    }else{
                        failure("internet error")
                    }
                }
            }
            .responseJSON { response in
                //debugPrint(response.result.value)
                if response.result.isSuccess{
                    success((response.result.value as? NSDictionary)!)
                }
                
        }
    }
    func searchPatient(sessionid:String,keyword:String,limit:String,offset:String,data:String,success: @escaping (_ response: NSDictionary) -> Void,failure: @escaping (_ error: String) -> Void){
        self.setTimeout()
        let code = "\(self.url)searchPatient"
        let parameter = ["keyword":keyword,"limit":limit,"offset":offset,"data":data] as [String : Any]
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
                    failure("searchPatient error")
                }
                
        }
    }
    func searchMeshTag(sessionID:String,keyword:String,success: @escaping (_ response: NSDictionary) -> Void,failure: (_ error: NSError?) -> Void){
        let code = "\(self.url)searchMeshTag"
        let parameter = ["data":"true","keyword":keyword] as [String : Any]
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
                }
        }
    }
    
    func updateFollowUp(sessionID:String,patientid:String,followupid:String,followupnote:String,meshtag:[String],opdtag:String,followupdate:String,success: @escaping (_ response: NSDictionary) -> Void,failure: @escaping (_ error: String) -> Void){
        let code = "\(self.url)updateFollowUp"
        let parameter = ["data":"true","post[patientid]":patientid,"key":followupid,"post[followupnote]":followupnote,"post[followdate]":followupdate,"post[meshtagid]":meshtag.description,"post[opdtag]":opdtag] as [String : Any]
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
                    failure("")
                }
        }
    }
    func createFollowup(sessionID:String,patientid:String,followupnote:String,meshtag:[String],opdtag:String,followupdate:String,success: @escaping (_ response: NSDictionary) -> Void,failure: @escaping (_ error: String) -> Void){
        let code = "\(self.url)updateFollowUp"
        let parameter = ["data":"true","post[patientid]":patientid,"post[followupnote]":followupnote,"post[followdate]":followupdate,"post[meshtagid]":meshtag.description] as [String : Any]
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
                    failure("")
                }
        }
    }
    func updatePatient(sessionID:String,patientid:String,HN:String,name:String,gender:String,nationality:String,residentaddr:String,idno:String,dob:String,phoneno:[String],medpayment:String,groupid:String,success: @escaping (_ response: NSDictionary) -> Void,failure: @escaping (_ error: String) -> Void){
        let code = "\(self.url)updatePatient"
        let parameter = ["data":"true","key":patientid,"post[HN]":HN,"post[firstname]":name,"post[gender]":gender,"post[middlename]":"","post[lastname]":"","post[nationality]":nationality,"post[residentaddr]":residentaddr,"post[idno]":idno,"post[dob]":dob,"post[phoneno]":phoneno.description,"post[medpayment]":medpayment,"post[groupid]":groupid] as [String : Any]
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
                    failure("")
                }
        }
    }
    func updatePatientMeshtag(meshtag:[String],patientid:String,success: @escaping (_ response: NSDictionary) -> Void,failure: @escaping (_ error: String) -> Void){
        let code = "\(self.url)updatePatient"
        let parameter = ["data":"true","post[meshtags]":meshtag.description,"keyt":patientid] as [String : Any]
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
                    failure("")
                }
        }
    }
    func newPatient(sessionID:String,success: @escaping (_ response: NSDictionary) -> Void,failure: @escaping (_ error: String) -> Void){
        let code = "\(self.url)newPatient"
        Alamofire.request(code, method: .post, parameters: nil, encoding: URLEncoding.default, headers: self.genHeader())
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
                    failure("")
                }
        }
    }
    func uploadPatientPic(sessionID:String,patientid:String,image:UIImage,success: @escaping (_ response: NSDictionary) -> Void,failure: @escaping (_ error: String) -> Void){
        let code = "\(self.url)uploadPatientPic"
        
        let parameters = ["appid":appID(),"appsecret":appSecret(),"sessionid":sessionID,"data":"true","key":patientid] as [String : String]
        Alamofire.upload(multipartFormData: {(multiple) in
            if let data = UIImageJPEGRepresentation(image,1.0) {
                multiple.append(data, withName: "picfile", fileName: "profile.jpg", mimeType: "image/jpeg")
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
    func uploadOPDPictureWithUIImage(sessionID:String,patientid:String,fudocid:String,image:UIImage,success: @escaping (_ response: NSDictionary) -> Void,failure: @escaping (_ error: String) -> Void){
        let code = "\(self.url)uploadOPDPic"
        
        let parameters = ["appid":appID(),"appsecret":appSecret(),"sessionid":sessionID,"data":"true","patientid":patientid,"fudocid":fudocid] as [String : String]
        Alamofire.upload(multipartFormData: {(multiple) in
            if let data = UIImageJPEGRepresentation(image,1.0) {
                multiple.append(data, withName: "image", fileName: "image.jpg", mimeType: "image/jpeg")
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
    func listUpdatedFollowUp(sessionid:String,updatetime:String,patientid:String,data:String,success: @escaping (_ response: NSDictionary) -> Void,failure: @escaping (_ error: String) -> Void){
        self.setTimeout()
        let header = ["deeappid":appID(),"deeappsecret":appSecret(),"Content-Type":"application/json","deesessionid":sessionid]
        let parameter = ["updatetime":updatetime,"data":data,"patientid":patientid] as [String : Any]
        let code = "\(self.url_rest)opd/history/"
        Alamofire.request(code, method: .get, parameters: parameter, encoding: URLEncoding.default, headers: header)
            .responseString { response in
                print("Success: \(response.result.isSuccess)")
                var statusCode = response.response?.statusCode
                if response.result.isSuccess{
                }else{
                    if let error = response.result.error as? AFError {
                        statusCode = error._code // statusCode private
                        switch error {
                        case .invalidURL(let url):
                            print("Invalid URL: \(url) - \(error.localizedDescription)")
                        case .parameterEncodingFailed(let reason):
                            print("Parameter encoding failed: \(error.localizedDescription)")
                            print("Failure Reason: \(reason)")
                        case .multipartEncodingFailed(let reason):
                            print("Multipart encoding failed: \(error.localizedDescription)")
                            print("Failure Reason: \(reason)")
                        case .responseValidationFailed(let reason):
                            print("Response validation failed: \(error.localizedDescription)")
                            print("Failure Reason: \(reason)")
                            switch reason {
                            case .dataFileNil, .dataFileReadFailed:
                                print("Downloaded file could not be read")
                            case .missingContentType(let acceptableContentTypes):
                                print("Content Type Missing: \(acceptableContentTypes)")
                            case .unacceptableContentType(let acceptableContentTypes, let responseContentType):
                                print("Response content type: \(responseContentType) was unacceptable: \(acceptableContentTypes)")
                            case .unacceptableStatusCode(let code):
                                print("Response status code was unacceptable: \(code)")
                                statusCode = code
                            }
                        case .responseSerializationFailed(let reason):
                            print("Response serialization failed: \(error.localizedDescription)")
                            print("Failure Reason: \(reason)")
                            // statusCode = 3840 ???? maybe..
                        }
                    }else{
                        failure("internet error")
                    }
                }
                
            }
            .responseJSON { response in
                //debugPrint(response.result.value)
                if response.result.isSuccess{
                    success((response.result.value as? NSDictionary)!)
                }
                
        }
    }
//    func listUpdatedFollowUp(sessionid:String,updatetime:String,patientid:String,data:String,success: @escaping (_ response: NSDictionary) -> Void,failure: @escaping (_ error: String) -> Void){
//        self.setTimeout()
//        let parameter = ["updatetime":updatetime,"data":data,"patientid":patientid] as [String : Any]
//        let code = "\(self.url)listUpdatedFollowUp"
//        sessionManager.request(code, method: .get, parameters: parameter, encoding: URLEncoding.default, headers: self.genHeader())
//            .responseString { response in
//                
//                print("Success: \(response.result.isSuccess)")
//                var statusCode = response.response?.statusCode
//                if response.result.isSuccess{
//                    
//                }else{
//                    if let error = response.result.error as? AFError {
//                        statusCode = error._code // statusCode private
//                        switch error {
//                        case .invalidURL(let url):
//                            print("Invalid URL: \(url) - \(error.localizedDescription)")
//                        case .parameterEncodingFailed(let reason):
//                            print("Parameter encoding failed: \(error.localizedDescription)")
//                            print("Failure Reason: \(reason)")
//                        case .multipartEncodingFailed(let reason):
//                            print("Multipart encoding failed: \(error.localizedDescription)")
//                            print("Failure Reason: \(reason)")
//                        case .responseValidationFailed(let reason):
//                            print("Response validation failed: \(error.localizedDescription)")
//                            print("Failure Reason: \(reason)")
//                            switch reason {
//                            case .dataFileNil, .dataFileReadFailed:
//                                print("Downloaded file could not be read")
//                            case .missingContentType(let acceptableContentTypes):
//                                print("Content Type Missing: \(acceptableContentTypes)")
//                            case .unacceptableContentType(let acceptableContentTypes, let responseContentType):
//                                print("Response content type: \(responseContentType) was unacceptable: \(acceptableContentTypes)")
//                            case .unacceptableStatusCode(let code):
//                                print("Response status code was unacceptable: \(code)")
//                                statusCode = code
//                            }
//                        case .responseSerializationFailed(let reason):
//                            print("Response serialization failed: \(error.localizedDescription)")
//                            print("Failure Reason: \(reason)")
//                            // statusCode = 3840 ???? maybe..
//                        }
//                    }else{
//                        failure("internet error")
//                    }
//                }
//
//            }
//            .responseJSON { response in
//                //debugPrint(response.result.value)
//                if response.result.isSuccess{
//                    success((response.result.value as? NSDictionary)!)
//                }
//                
//        }
//    }
}
