//
//  ChangePasswordViewController.swift
//  MEDDIC
//
//  Created by Tanakorn on 2/6/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UIViewController,UITextFieldDelegate {
    var isFirst = true
    var password = ""
    var isSecond = false
    var oldpassword = ""
    var pass1 = ""
    var pass2 = ""
    var api = APIUser()
    @IBOutlet weak var lb_error: UILabel!
    @IBOutlet weak var lb_change_password: UILabel!
    @IBOutlet weak var btn_confirm: UIButton!
    @IBOutlet weak var tf_password: UITextField!
    @IBOutlet weak var btn_try: UIButton!
    
    @IBAction func btn_try_action(_ sender: UIButton) {
        self.tf_password.text = ""
        self.btn_try.isHidden = true
        self.lb_error.isHidden = true
        self.password = ""
        self.isFirst = true
        self.isSecond = false
        self.btn_confirm.isUserInteractionEnabled = true
    }
    @IBAction func btn_confirm_action(_ sender: UIButton) {
        if self.isSecond{
            if self.tf_password.text!.characters.count > 8{
                self.lb_error.isHidden = true
                self.isFirst = false
                self.isSecond = false
                self.lb_change_password.text = "Confirm password"
                pass1 = self.tf_password.text!
                self.tf_password.text = ""
            }else{
                self.lb_error.text = "your password must be more than 8 words"
                self.lb_error.isHidden = false
            }
        }else if self.isFirst{
            self.oldpassword = self.tf_password.text!
            self.tf_password.text = ""
            self.lb_change_password.text = "Your new password"
            self.isSecond = true
        }else{
            pass2 = self.tf_password.text!
            self.api.passwd(password: self.oldpassword, pass1: self.pass1, pass2: self.pass2, success: {(success) in
                print(success)
            }, failure: {(error) in
                
            })
//            if self.tf_password.text! == self.password{
//                self.navigationController?.popViewController(animated: true)
//            }else{
//                self.btn_confirm.isUserInteractionEnabled = false
//                self.btn_try.isHidden = false
//                self.lb_error.text = "Your password is mismatch"
//                self.lb_error.isHidden = false
//            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tf_password.delegate = self
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
