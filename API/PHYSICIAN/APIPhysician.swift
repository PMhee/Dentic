//
//  APIPhysician.swift
//  MEDDIC
//
//  Created by Tanakorn on 2/8/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import Foundation
import Alamofire
import RealmSwift
class APIPhysician{
    //var url = "https://smr.cp.eng.chula.ac.th/dev/detnarong/service.php?q=api/"
    var url = "https://smr.cp.eng.chula.ac.th/service.php?q=api/"
    func appID() -> String{
        return "ea5aeea931986e0b82eaaefa9131d777736ac50a"
    }
    func appSecret() -> String{
        return "c51feaa7ecb2a1c61ef9648a5b84ab05"
    }
    let system = BackSystem()
    let config = URLSessionConfiguration.background(withIdentifier: "com.example.app.background")
    var sessionManager = Alamofire.SessionManager.default
    func setTimeout(){
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource = 7 // seconds
        sessionManager = Alamofire.SessionManager(configuration: configuration)
    }
    func genHeader() -> [String:String]{
        return ["deeappid":appID(),"deeappsecret":appSecret(),"deesessionid":self.system.getSessionid()]
    }
    func updateUserInfo(sessionid:String,physicianid:String,name:String,gender:String,phoneno:String,success: @escaping (_ response: NSDictionary) -> Void,failure: @escaping (_ error: String) -> Void){
        self.setTimeout()
        let code = "\(self.url)updateUserInfo"
        let parameter = ["post[physicianid]":physicianid,"post[firstname]":name,"post[middlename]":"","post[lastname]":"","post[gender]":gender,"post[phoneno]":phoneno] as [String : Any]
        sessionManager.request(code, method: .post, parameters: parameter, encoding: URLEncoding.default, headers: self.genHeader())
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
    func updatePatientGroup(sessionid:String,groupids:[String],success: @escaping (_ response: NSDictionary) -> Void,failure: @escaping (_ error: String) -> Void){
        self.setTimeout()
        var gr = [String]()
        for i in 0..<groupids.count{
            if groupids[i] != "xxx"{
                gr.append(groupids[i])
            }
        }
        let code = "\(self.url)updateUserInfo"
        let parameter = ["post[groupids]":gr.description] as [String : Any]
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
    func uploadProfilePic(sessionID:String,id:String,image:UIImage,success: @escaping (_ response: NSDictionary) -> Void,failure: @escaping (_ error: String) -> Void){
        let code = "\(self.url)uploadProfilePic"
        
        let parameters = ["appid":appID(),"appsecret":appSecret(),"sessionid":sessionID,"data":"true","key":id] as [String : String]
        sessionManager.upload(multipartFormData: {(multiple) in
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

    func userInfo(sessionid:String,success: @escaping (_ response: NSDictionary) -> Void,failure: @escaping  (_ error: String) -> Void){
        self.setTimeout()
        let parameter = ["data":"true"] as [String : Any]
        let code = "\(self.url)userInfo"
        sessionManager.request(code, method: .get, parameters: parameter, encoding: URLEncoding.default, headers: self.genHeader())
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
}
