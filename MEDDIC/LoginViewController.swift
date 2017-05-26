//
//  LoginViewController.swift
//  MEDDIC
//
//  Created by Tanakorn on 1/16/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController,UITextFieldDelegate,UIGestureRecognizerDelegate {
    var api = APIUser()
    var ui = UILoading()
    var back = BackSystem()
    var vw_error = UIView()
    var inSignup = false
    var inPromotion = false
    @IBOutlet weak var tf_promotional_code: UITextField!

    @IBAction func btn_login_promotion(_ sender: UIButton) {
    }
    @IBOutlet weak var vw_promotion: UIView!
    
    @IBAction func btn_create_action(_ sender: UIButton) {
        self.view.endEditing(true)
        self.signup_activity.isHidden = false
        self.signup_activity.startAnimating()
        self.btn_create.isUserInteractionEnabled = false
        if self.tf_email.text! == ""{
            self.signup_activity.isHidden = true
            self.btn_create.isUserInteractionEnabled = true
            let alertController = UIAlertController(title: "Error", message: "Please Fill Email address", preferredStyle: UIAlertControllerStyle.alert)
            let noAction = UIAlertAction(title: "Done", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            }
            alertController.addAction(noAction)
            self.present(alertController, animated: true, completion: nil)
        }else if self.tf_confirm_password.text!.characters.count < 6{
            self.signup_activity.isHidden = true
            self.btn_create.isUserInteractionEnabled = true
            let alertController = UIAlertController(title: "Error", message: "Password must be more than 6 characters", preferredStyle: UIAlertControllerStyle.alert)
            let noAction = UIAlertAction(title: "Done", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            }
            alertController.addAction(noAction)
            self.present(alertController, animated: true, completion: nil)
        }else if self.tf_confirm_password.text! != self.tf_password_signup.text!{
            self.signup_activity.isHidden = true
            self.btn_create.isUserInteractionEnabled = true
            let alertController = UIAlertController(title: "Error", message: "Password mismatch", preferredStyle: UIAlertControllerStyle.alert)
            let noAction = UIAlertAction(title: "Done", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            }
            alertController.addAction(noAction)
            self.present(alertController, animated: true, completion: nil)
        }else{
            self.api.signup(email: self.tf_email.text!, pass1: self.tf_password_signup.text!, pass2: self.tf_confirm_password.text!, success: {(success) in
                self.vw_filter.isHidden = true
                self.vw_signup.isHidden = true
                let alertController = UIAlertController(title: "Success", message: "Your verification was sent to your email.", preferredStyle: UIAlertControllerStyle.alert)
                let noAction = UIAlertAction(title: "Done", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                }
                alertController.addAction(noAction)
                self.signup_activity.isHidden = true
                self.signup_activity.startAnimating()
                self.btn_create.isUserInteractionEnabled = true
                alertController.addAction(noAction)
                self.present(alertController, animated: true, completion: nil)
                self.present(alertController, animated: true, completion: nil)
            }, failure: {(error) in
                self.signup_activity.isHidden = true
                self.btn_create.isUserInteractionEnabled = true
            })
        }
    }
    @IBOutlet weak var btn_create: UIButton!
    @IBOutlet weak var tf_confirm_password: UITextField!
    var helper = Helper()
    @IBOutlet weak var signup_activity: UIActivityIndicatorView!
    @IBOutlet var gesture: UIGestureRecognizer!
    @IBOutlet weak var tf_password_signup: UITextField!
    @IBOutlet weak var tf_email: UITextField!
    @IBOutlet weak var vw_signup: UIView!
    @IBOutlet weak var vw_filter: UIView!
    @IBOutlet weak var act: UIActivityIndicatorView!
    @IBOutlet weak var btn_signin: UIButton!
    @IBOutlet weak var tf_username: UITextField!
    @IBOutlet weak var tf_password: UITextField!
    @IBAction func btn_signin_action(_ sender: UIButton) {
        self.act.isHidden = false
        self.act.startAnimating()
        self.api.login(username: self.tf_username.text!, password: self.tf_password.text!, success: {(success) in
            self.act.isHidden = true
            self.btn_create.isUserInteractionEnabled = false
            if let response = success.value(forKey: "content") as? String{
                if response == "invalid username or password"{
                    self.vw_error = self.ui.loadFromNibNamed(nibNamed: "ModalLoginError")!
                    self.vw_error.frame = CGRect(x: (self.view.frame.width-300)/2, y: (self.view.frame.height-150)/2, width: 300, height: 150)
                    self.vw_error.tag = 10
                    let bg = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
                    bg.backgroundColor = UIColor.black
                    bg.alpha = 0.4
                    bg.tag = 11
                    self.vw_error.layer.cornerRadius = 5
                    self.vw_error.layer.masksToBounds = true
                    self.view.addSubview(bg)
                    self.view.addSubview(self.vw_error)
                    self.ui.delay(1.5){
                        let vw1 = self.view.viewWithTag(10)
                        vw1?.removeFromSuperview()
                        let vw2 = self.view.viewWithTag(11)
                        vw2?.removeFromSuperview()
                    }
                }else{
                    self.back.collectLoginUser(success: success)
                    self.performSegue(withIdentifier: "download", sender: self)
                }
            }
        }, failure: {(error) in
            self.act.isHidden = true
            self.ui.showError(error: "Bad internet connection", view: self.view)
        })
        
    }
    @IBAction func btn_forgot_action(_ sender: UIButton) {
    }
    @IBAction func btn_signup_action(_ sender: UIButton) {
        self.inSignup = true
        self.tf_email.text = ""
        self.tf_password_signup.text = ""
        self.tf_confirm_password.text = ""
        self.tf_email.becomeFirstResponder()
        self.vw_filter.isHidden = false
        self.vw_signup.isHidden = false
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if self.inSignup{
            if self.helper.inBound(x: touch.location(in: self.vw_signup).x, y: touch.location(in: self.vw_signup).y, view: self.vw_signup){
                return false
            }else{
                self.view.endEditing(true)
                self.vw_filter.isHidden = true
                self.vw_signup.isHidden = true
                self.signup_activity.isHidden = true
                self.btn_create.isUserInteractionEnabled = true
                self.inSignup = false
                return true
            }
        }else if self.inPromotion{
            if self.helper.inBound(x: touch.location(in: self.vw_promotion).x, y: touch.location(in: self.vw_promotion).y, view: self.vw_promotion){
                return false
            }else{
                self.view.endEditing(true)
                self.vw_filter.isHidden = true
                self.vw_promotion.isHidden = true
                self.inPromotion = false
                return true
            }
        }else{
            return false
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.signup_activity.isHidden = true
        self.act.isHidden = true
        //        self.tf_username.text = "lufas2603@gmail.com"
        //        self.tf_password.text = "Coutinho2603"
        self.tf_username.delegate = self
        self.tf_password.delegate = self
        self.tf_email.layer.borderWidth = 0.5
        self.tf_email.layer.borderColor = UIColor(netHex: 0xeeeeee).cgColor
        self.tf_confirm_password.layer.borderWidth = 0.5
        self.tf_confirm_password.layer.borderColor = UIColor(netHex: 0xeeeeee).cgColor
        self.tf_password_signup.layer.borderWidth = 0.5
        self.tf_password_signup.layer.borderColor = UIColor(netHex: 0xeeeeee).cgColor
        self.tf_username.keyboardType = .emailAddress
        self.btn_signin.layer.cornerRadius = 2
        self.btn_signin.layer.masksToBounds = true
        self.helper.setButtomBorder(tf: self.tf_promotional_code)
        // Do any additional setup after loading the view.
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
