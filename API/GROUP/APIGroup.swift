//
//  APIGroup.swift
//  MEDDIC
//
//  Created by Tanakorn on 2/6/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import Foundation
import Alamofire
class APIGroup{
    var backSystem = BackSystem()
    //var url = "https://smr.cp.eng.chula.ac.th/dev/detnarong/service.php?q=api/"
    //var url_rest = "https://smr.cp.eng.chula.ac.th/dev/detnarong/rest.php/"
    var url_rest = "https://smr.cp.eng.chula.ac.th/rest.php/"
    var url = "https://smr.cp.eng.chula.ac.th/service.php?q=api/"
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
    var sessionManager = Alamofire.SessionManager.default
    func setTimeout(){
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource = 7 // seconds
        sessionManager = Alamofire.SessionManager(configuration: configuration)
    }
    func listPhysician(keyword:String,sessionid:String,success: @escaping (_ response: NSDictionary) -> Void,failure: @escaping (_ error: String) -> Void){
        self.setTimeout()
        let header = ["deeappid":appID(),"deeappsecret":appSecret(),"Content-Type":"application/json","deesessionid":sessionid]
        let parameter = ["data":"1","keyword":keyword] as [String : Any]
        let code = "\(self.url_rest)physician"
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
    func listMyGroup(sessionid:String,success: @escaping (_ response: NSDictionary) -> Void,failure: @escaping (_ error: String) -> Void){
        self.setTimeout()
        let header = ["deeappid":appID(),"deeappsecret":appSecret(),"Content-Type":"application/json","deesessionid":sessionid]
        let parameter = ["data":"1"] as [String : Any]
        let code = "\(self.url_rest)groups/list/all"
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
    func listMemberInGroup(sessionid:String,groupid:String,success: @escaping (_ response: NSDictionary) -> Void,failure: @escaping (_ error: String) -> Void){
        self.setTimeout()
        let header = ["deeappid":appID(),"deeappsecret":appSecret(),"Content-Type":"application/json","deesessionid":sessionid]
        let code = "\(self.url_rest)groups/\(groupid)?filter=members"
        Alamofire.request(code, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header)
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
    func listPatientInGroup(sessionid:String,groupid:String,success: @escaping (_ response: NSDictionary) -> Void,failure: @escaping (_ error: String) -> Void){
        self.setTimeout()
        let header = ["deeappid":appID(),"deeappsecret":appSecret(),"Content-Type":"application/json","deesessionid":sessionid]
        let code = "\(self.url_rest)groups/\(groupid)?filter=patients"
        Alamofire.request(code, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header)
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
    func addCustomFormToGroup(sessionid:String,groupid:String,cusformid:String,success: @escaping (_ response: NSDictionary) -> Void,failure: @escaping (_ error: String) -> Void){
        self.setTimeout()
        let header = ["deeappid":appID(),"deeappsecret":appSecret(),"Content-Type":"application/json","deesessionid":sessionid]
        let parameter = ["cusformid":cusformid]
        let code = "\(self.url_rest)cusformgroup/\(groupid)"
        Alamofire.request(code, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: header)
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
    func listCustomFormInGroup(sessionid:String,groupid:String,success: @escaping (_ response: NSDictionary) -> Void,failure: @escaping (_ error: String) -> Void){
        self.setTimeout()
        let header = ["deeappid":appID(),"deeappsecret":appSecret(),"Content-Type":"application/json","deesessionid":sessionid]
        let code = "\(self.url_rest)\(groupid)/cusforms"
        Alamofire.request(code, method: .get, parameters: nil, encoding: URLEncoding.default, headers: header)
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
    func editGroupName(groupname:String,groupdescription:String,groupid:String,success: @escaping (_ response: NSDictionary) -> Void,failure: @escaping (_ error: String) -> Void){
        self.setTimeout()
        let header = ["deeappid":appID(),"deeappsecret":appSecret(),"Content-Type":"application/json","deesessionid":self.backSystem.getSessionid()]
        let parameter = ["groupname":groupname,"groupdescription":groupdescription] as [String : Any]
        let code = "\(self.url_rest)groups/\(groupid)"
        Alamofire.request(code, method: .put, parameters: parameter, encoding: JSONEncoding.default, headers: header)
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
    func uploadGrPic(groupdocid:String,image:UIImage,success: @escaping (_ response: NSDictionary) -> Void,failure: @escaping (_ error: String) -> Void){
        let code = "\(self.url)uploadGrPic"
        
        let parameters = ["appid":appID(),"appsecret":appSecret(),"sessionid":self.backSystem.getSessionid(),"data":"true","key":groupdocid] as [String : String]
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
    func createGroup(sessionid:String,groupname:String,groupdescription:String,success: @escaping (_ response: NSDictionary) -> Void,failure: @escaping (_ error: String) -> Void){
        self.setTimeout()
        let header = ["deeappid":appID(),"deeappsecret":appSecret(),"Content-Type":"application/json","deesessionid":sessionid]
        let parameter = ["groupname":groupname,"groupdescription":groupdescription] as [String : Any]
        let code = "\(self.url_rest)groups"
        sessionManager.request(code, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: header)
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
    func deleteGroup(sessionid:String,groupid:String,success: @escaping (_ response: NSDictionary) -> Void,failure: @escaping (_ error: String) -> Void){
        self.setTimeout()
        let header = ["deeappid":appID(),"deeappsecret":appSecret(),"Content-Type":"application/json","deesessionid":sessionid]
        let parameter = ["id":groupid] as [String : Any]
        let code = "\(self.url_rest)groups"
        sessionManager.request(code, method: .delete, parameters: parameter, encoding: JSONEncoding.default, headers: header)
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
    
    func addMember(sessionid:String,groupid:String,userid:Int,role:String,success: @escaping (_ response: NSDictionary) -> Void,failure: @escaping (_ error: String) -> Void){
        self.setTimeout()
        let header = ["deeappid":appID(),"deeappsecret":appSecret(),"Content-Type":"application/json","deesessionid":sessionid]
        let parameter = ["userid":userid,"role":role] as [String : Any]
        let code = "\(self.url_rest)groups/invite/\(groupid)"
        Alamofire.request(code, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: header)
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
    func deleteMember(sessionid:String,groupid:String,userid:Int,success: @escaping (_ response: NSDictionary) -> Void,failure: @escaping (_ error: String) -> Void){
        self.setTimeout()
        let header = ["deeappid":appID(),"deeappsecret":appSecret(),"Content-Type":"application/json","deesessionid":sessionid]
        let parameter = ["userid":userid] as [String : Any]
        let code = "\(self.url_rest)groups/invite/\(groupid)"
        Alamofire.request(code, method: .delete, parameters: parameter, encoding: JSONEncoding.default, headers: header)
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
    func listOPDTag(sessionid:String,id:String,success: @escaping (_ response: NSDictionary) -> Void,failure: @escaping (_ error: String) -> Void){
        self.setTimeout()
        let code = "\(self.url_rest)groups/\(id)/opdtag"
        Alamofire.request(code, method: .get, parameters: nil, encoding: URLEncoding.default, headers: self.genHeader())
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
