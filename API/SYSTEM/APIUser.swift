//
//  APIUser.swift
//  MEDDIC
//
//  Created by Tanakorn on 1/16/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//
import Alamofire
import Foundation
class APIUser{
    //var url = "https://smr.cp.eng.chula.ac.th/dev/detnarong/service.php?q=api/"
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
    func passwd(password:String,pass1:String,pass2:String,success: @escaping (_ response: NSDictionary) -> Void,failure: @escaping  (_ error: NSError?) -> Void){
        let code = "\(self.url)passwd"
        let parameter = ["oldpasswd":password,"passwd1":pass1,"passwd2":pass2] as [String : Any]
        self.setTimeout()
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
                    failure(NSError(domain: "Slow Internet Connection", code: 401, userInfo: nil))
                }
                
        }
    }
    func signup(email:String,pass1:String,pass2:String,success: @escaping (_ response: NSDictionary) -> Void,failure: @escaping  (_ error: NSError?) -> Void){
        let code = "\(self.url)signup"
        let header =  ["deeappid":appID(),"deeappsecret":appSecret()]
        let parameter = ["email":email,"pass1":pass1,"pass2":pass2] as [String : Any]
        self.setTimeout()
        sessionManager.request(code, method: .post, parameters: parameter, encoding: URLEncoding.default, headers: header)
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
    func login(username:String,password:String,success: @escaping (_ response: NSDictionary) -> Void,failure: @escaping  (_ error: NSError?) -> Void){
        let code = "\(self.url)login"
        let header =  ["deeappid":appID(),"deeappsecret":appSecret()]
        let parameter = ["username":username,"password":password] as [String : Any]
        self.setTimeout()
        sessionManager.request(code, method: .post, parameters: parameter, encoding: URLEncoding.default, headers: header)
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

}
