//
//  PasscodeViewController.swift
//  MEDDIC
//
//  Created by Tanakorn on 2/5/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import UIKit
import LocalAuthentication
import AudioToolbox
import RealmSwift
class PasscodeViewController: UIViewController,UITextFieldDelegate {
    var helper = Helper()
    var passcode : String = ""
    var isSet = false
    var cfPassword = false
    var cfPasswordString = ""
    let phys = try! Realm().objects(RealmPhysician.self).first
    @IBOutlet weak var lb_passcode: UILabel!
    @IBOutlet weak var vw4: UIView!
    @IBOutlet weak var vw3: UIView!
    @IBOutlet weak var vw2: UIView!
    @IBOutlet weak var vw1: UIView!
    @IBOutlet weak var tf_passcode: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tf_passcode.keyboardType = .numberPad
        self.tf_passcode.delegate = self
        self.tf_passcode.becomeFirstResponder()
        self.vw1.layer.cornerRadius = 10
        self.vw2.layer.cornerRadius = 10
        self.vw3.layer.cornerRadius = 10
        self.vw4.layer.cornerRadius = 10
        let context = LAContext()
        if #available(iOS 9.0, *) {
            if !isSet{
                context.evaluatePolicy(LAPolicy.deviceOwnerAuthentication, localizedReason: "Please authenticate to proceed.") { [weak self] (success, error) in
                    guard success else {
                        self?.vw1.backgroundColor = UIColor(netHex: 0x967C90)
                        self?.vw2.backgroundColor = UIColor(netHex: 0x967C90)
                        self?.vw3.backgroundColor = UIColor(netHex: 0x967C90)
                        self?.vw4.backgroundColor = UIColor(netHex: 0x967C90)
                        DispatchQueue.main.async {
                            print("false")
                            self?.vw1.backgroundColor = UIColor.white
                            self?.vw2.backgroundColor = UIColor.white
                            self?.vw3.backgroundColor = UIColor.white
                            self?.vw4.backgroundColor = UIColor.white
                            self?.lb_passcode.text = "Wrong passcode"
                            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                            // show something here to block the user from continuing
                        }
                        
                        return
                    }
                    DispatchQueue.main.async {
                        self?.vw1.backgroundColor = UIColor(netHex: 0x967C90)
                        self?.vw2.backgroundColor = UIColor(netHex: 0x967C90)
                        self?.vw3.backgroundColor = UIColor(netHex: 0x967C90)
                        self?.vw4.backgroundColor = UIColor(netHex: 0x967C90)
                        self?.helper.delay(0.2){
                        self?.performSegue(withIdentifier: "success", sender: self)
                        }
                        print("success")
                        // do something here to continue loading your app, e.g. call a delegate method
                    }
                }
            }
        } else {
            // Fallback on earlier versions
        }
        // Do any additional setup after loading the view.
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func tf_change(_ sender: UITextField) {
        if sender.text!.characters.count == 0{
            self.vw1.backgroundColor = UIColor.white
            self.vw2.backgroundColor = UIColor.white
            self.vw3.backgroundColor = UIColor.white
            self.vw4.backgroundColor = UIColor.white
        }else if sender.text!.characters.count == 1{
            self.vw1.backgroundColor = UIColor(netHex: 0x967C90)
            self.vw2.backgroundColor = UIColor.white
            self.vw3.backgroundColor = UIColor.white
            self.vw4.backgroundColor = UIColor.white
        }else if sender.text!.characters.count == 2{
            self.vw1.backgroundColor = UIColor(netHex: 0x967C90)
            self.vw2.backgroundColor = UIColor(netHex: 0x967C90)
            self.vw3.backgroundColor = UIColor.white
            self.vw4.backgroundColor = UIColor.white
        }else if sender.text!.characters.count == 3{
            self.vw1.backgroundColor = UIColor(netHex: 0x967C90)
            self.vw2.backgroundColor = UIColor(netHex: 0x967C90)
            self.vw3.backgroundColor = UIColor(netHex: 0x967C90)
            self.vw4.backgroundColor = UIColor.white
        }else{
            self.vw1.backgroundColor = UIColor(netHex: 0x967C90)
            self.vw2.backgroundColor = UIColor(netHex: 0x967C90)
            self.vw3.backgroundColor = UIColor(netHex: 0x967C90)
            self.vw4.backgroundColor = UIColor(netHex: 0x967C90)
        }
        if sender.text!.characters.count == 4{
            if self.isSet && !self.cfPassword{
                self.cfPasswordString = sender.text!
                sender.text = ""
                self.helper.delay(0.5){
                    self.cfPassword = true
                    self.vw1.backgroundColor = UIColor.white
                    self.vw2.backgroundColor = UIColor.white
                    self.vw3.backgroundColor = UIColor.white
                    self.vw4.backgroundColor = UIColor.white
                    self.lb_passcode.text = "Confirm password"
                }
            }else if self.isSet && self.cfPassword{
                try! Realm().write {
                    self.phys?.passcode = sender.text!
                }
                self.navigationController?.popViewController(animated: true)
            }else{
                if sender.text! == self.phys?.passcode{
                    self.performSegue(withIdentifier: "success", sender: self)
                }else{
                    self.helper.delay(0.5){
                        self.vw1.backgroundColor = UIColor.white
                        self.vw2.backgroundColor = UIColor.white
                        self.vw3.backgroundColor = UIColor.white
                        self.vw4.backgroundColor = UIColor.white
                        self.lb_passcode.text = "Wrong passcode"
                        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                    }
                }
                sender.text = ""
            }
        }
        
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
