//
//  PhysicianProfileViewController.swift
//  MEDDIC
//
//  Created by Tanakorn on 2/8/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import UIKit

class PhysicianProfileViewController: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    var api = APIPhysician()
    var system = BackSystem()
    var ui = UILoading()
    var id : String = ""
    var image : UIImage!
    var userid : String = ""
    var helper = Helper()
    @IBOutlet weak var vw_filter: UIView!
    @IBOutlet weak var act: UIActivityIndicatorView!
    @IBOutlet weak var btn_update: UIButton!
    @IBOutlet weak var tf_phone: UITextField!
    @IBOutlet weak var tf_gender: UITextField!
    @IBOutlet weak var tf_name: UITextField!
    @IBOutlet weak var img_profile: UIImageView!
    @IBAction func btn_update_action(_ sender: UIButton) {
        self.vw_filter.isHidden = false
        self.act.isHidden = false
        self.api.updateUserInfo(sessionid: self.system.getSessionid(), userid: self.userid, name: self.tf_name.text!, gender: self.tf_gender.text!, phoneno: self.tf_phone.text!, success: {(success) in
            if self.image != nil{
                self.api.uploadProfilePic(sessionID: self.system.getSessionid(), id: self.id, image: self.image, success: {(success) in
                    self.navigationController?.popViewController(animated: true)
                }, failure: {(error) in
                    self.vw_filter.isHidden = true
                    self.act.isHidden = true
                    self.ui.showErrorNav(error: "Internet connection problem", view: self.view)
                })
            }else{
                self.navigationController?.popViewController(animated: true)
            }
        }, failure: {(error) in
            self.vw_filter.isHidden = true
            self.act.isHidden = true
            self.ui.showErrorNav(error: "Internet connection problem", view: self.view)
        })
    }
    @IBAction func btn_image_action(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            var imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.image = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.img_profile.image = self.image
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.act.startAnimating()
        self.tf_name.delegate = self
        self.tf_phone.delegate = self
        self.tf_gender.delegate = self
        self.img_profile.layer.cornerRadius = 3
        self.img_profile.layer.masksToBounds = true
        self.img_profile.layer.borderColor = UIColor.white.cgColor
        self.img_profile.layer.borderWidth = 2
        self.btn_update.layer.cornerRadius  = 5
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.api.userInfo(sessionid: system.getSessionid(), success: {(success) in
            if let content = success.value(forKey: "content") as? NSDictionary{
                if let ID = content.value(forKey: "_id") as? NSDictionary{
                    if let id = ID.value(forKey: "$id") as? String{
                        self.id = id
                    }
                }
                if let firstname = content.value(forKey: "firstname") as? String{
                    if let middlename = content.value(forKey: "middlename") as? String{
                        if let lastname = content.value(forKey: "lastname") as? String{
                            self.tf_name.text = firstname + " " + middlename + " " + lastname
                        }
                    }
                }
                if let gender = content.value(forKey: "gender") as? String{
                    self.tf_gender.text = gender
                }
                if let phoneno = content.value(forKey: "phoneno") as? String{
                    self.tf_phone.text = phoneno
                }
                if let userid = content.value(forKey: "userid") as? String{
                    self.userid = userid
                }
                if let picurl = content.value(forKey: "picurl") as? String{
                    self.helper.downloadImageFrom(link: picurl, contentMode: .scaleAspectFill, img: self.img_profile)
                }
            }
            self.vw_filter.isHidden = true
            self.act.isHidden = true
        }, failure: {(error) in
            self.vw_filter.isHidden = true
            self.act.isHidden = true
            self.ui.showErrorNav(error: "Internet connection problem", view: self.view)
        })
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
