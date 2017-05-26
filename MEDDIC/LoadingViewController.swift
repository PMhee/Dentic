//
//  LoadingViewController.swift
//  MEDDIC
//
//  Created by Tanakorn on 1/20/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import UIKit
import RealmSwift
class LoadingViewController: UIViewController {
    var apiGroup = APIGroup()
    var api = APIPatient()
    var apiPhysicain = APIPhysician()
    var back = BackPatient()
    var uiLoading = UILoading()
    var backSystem = BackSystem()
    var stack = try! Realm().objects(RealmStackFollowup.self)
    var customForm = try! Realm().objects(CustomForm.self)
    var patient = try! Realm().objects(RealmPatient.self)
    var backStack = BackStack()
    var helper = Helper()
    var backGroup = BackGroup()
    var checkupdate = false
    var patientNumber = 0
    var counting = 0
    
    @IBOutlet weak var progress: UIProgressView!
    @IBOutlet weak var act: UIActivityIndicatorView!
    var backPhysicain = BackPhysician()
    @IBOutlet weak var lb_loading: UILabel!
    
    @IBAction func btn_skip_action(_ sender: UIButton) {
        self.performSegue(withIdentifier: "show", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.downloadProfile()
        if customForm.count == 0 {
            try! Realm().write {
                let cusform = CustomForm()
                cusform.isAnswer = true
                try! Realm().add(cusform)
            }
        }
        self.act.startAnimating()
        self.checkForUpdate()
        self.apiGroup.listOPDTag(sessionid: self.backSystem.getSessionid(), id: "5898452eee522e3830295c25", success: {(success) in
            self.backGroup.initStatus(success: success)
        }, failure: {(error) in
        
        })
//        self.api.listOPDTag(sessionid: self.backSystem.getSessionid(), success: {(success) in
//            self.back.initStatus(success: success)
//        }, failure: {(error) in
//        
//        })
        //        let patient = try! Realm().objects(RealmPatient.self)
        //        if patient.count == 0{
        //            self.downloadPatient(count: 0)
        //        }else{
        //            self.backStack.sendStackFollowup()
        //            self.backStack.sendStackPicture()
        //            self.performSegue(withIdentifier: "show", sender: self)
        //        }
    }
    func downloadProfile(){
        self.apiPhysicain.userInfo(sessionid: self.backSystem.getSessionid(), success: {(success) in
            self.backPhysicain.downloadPhysicianProfile(success: success)
        }, failure: {(error) in
            
        })
    }
    func animateUpdate(i:Int){
        DispatchQueue.global(qos:.background).async {
            if !self.checkupdate{
                self.helper.delay(0.4){
                    if i == 0{
                        self.lb_loading.text = "Checking for update .."
                        self.animateUpdate(i: i+1)
                    }else if i == 1{
                        self.lb_loading.text = "Checking for update ..."
                        self.animateUpdate(i: i+1)
                    }else{
                        self.lb_loading.text = "Checking for update ."
                        self.animateUpdate(i: 0)
                    }
                }
            }else{
                DispatchQueue.main.async {
                    self.lb_loading.text = "Update \(self.patientNumber) patients"
                }
            }
        }
    }
    
    func checkForUpdate(){
        self.animateUpdate(i: 0)
        self.apiGroup.listMyGroup(sessionid: self.backSystem.getSessionid(), success: {(success) in
            self.backGroup.collectGroup(success: success)
        }, failure: {(error) in
            self.performSegue(withIdentifier: "show", sender: self)
        })
        if self.patient.count > 0 {
            self.api.listUpdatedPatient(sessionid: self.backSystem.getSessionid(), updatetime: self.helper.dateToServer(date: self.back.getLastUpdate())
                , offset: "", limit: "", data: "false", success: {(success) in
                    self.patientNumber = (success.value(forKey: "content") as! NSArray).count
                    if self.patientNumber == 0 {
                        self.progress.setProgress(1, animated: true)
                        self.performSegue(withIdentifier: "show", sender: self)
                    }else{
                        self.downloadPatient(count: self.patientNumber/200, mod: self.patientNumber%200)
                    }
                    self.checkupdate = true
            }, failure: {(error) in
                self.performSegue(withIdentifier: "show", sender: self)
            })
        }else{
            self.api.listUpdatedPatient(sessionid: self.backSystem.getSessionid(), updatetime:""
                , offset: "", limit: "", data: "false", success: {(success) in
                    self.patientNumber = (success.value(forKey: "content") as! NSArray).count
                    if self.patientNumber == 0 {
                        self.performSegue(withIdentifier: "show", sender: self)
                    }else{
                        self.downloadPatient(count: self.patientNumber/200, mod: self.patientNumber%200)
                    }
                    self.checkupdate = true
            }, failure: {(error) in
                self.performSegue(withIdentifier: "show", sender: self)
            })
        }
    }
    func downloadPatient(count:Int,mod:Int){
        var c = count
        c+=1
        for i in 0..<c{
            if i == 0 && c == 1{
                self.api.listUpdatedPatient(sessionid: self.backSystem.getSessionid(), updatetime: self.helper.dateToServer(date: self.back.getLastUpdate()), offset: "0", limit: "200",data:"true", success: {(success) in
                    self.back.loadPatientData(dic: success)
                    if let array = success.value(forKey: "content") as? NSArray{
                        self.counting = self.counting + array.count
                        self.lb_loading.text = "Downloading update \(self.counting) of \(self.patientNumber) patients"
                        self.progress.setProgress((Float(Float(self.counting)/Float(self.patientNumber))), animated: true)
                    }
                    self.helper.delay(0.5){
                        self.performSegue(withIdentifier: "show", sender: self)
                    }
                }, failure: {(error) in
                    self.performSegue(withIdentifier: "show", sender: self)
                })
            }else if i == c-1{
                self.api.listUpdatedPatient(sessionid: self.backSystem.getSessionid(), updatetime: self.helper.dateToServer(date: self.back.getLastUpdate()), offset: String(c-i-1), limit: "200",data:"true", success: {(success) in
                    self.back.loadPatientData(dic: success)
                    if let array = success.value(forKey: "content") as? NSArray{
                        self.counting = self.counting + array.count
                        self.lb_loading.text = "Downloading update \(self.counting) of \(self.patientNumber) patients"
                        self.progress.setProgress((Float(Float(self.counting)/Float(self.patientNumber))), animated: true)
                    }
                    self.helper.delay(0.5){
                        self.performSegue(withIdentifier: "show", sender: self)
                    }
                }, failure: {(error) in
                    self.performSegue(withIdentifier: "show", sender: self)
                })
                
            }else{
                self.api.listUpdatedPatient(sessionid: self.backSystem.getSessionid(), updatetime: self.helper.dateToServer(date: self.back.getLastUpdate()), offset: String(c-i-1), limit: "200",data:"true", success: {(success) in
                    print(success)
                    self.back.loadPatientData(dic: success)
                    if let array = success.value(forKey: "content") as? NSArray{
                        self.counting = self.counting + array.count
                        self.lb_loading.text = "Downloading update \(self.counting) of \(self.patientNumber) patients"
                        self.progress.setProgress((Float(Float(self.counting)/Float(self.patientNumber))), animated: true)
                    }
                }, failure: {(error) in
                    self.performSegue(withIdentifier: "show", sender: self)
                })
            }
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
