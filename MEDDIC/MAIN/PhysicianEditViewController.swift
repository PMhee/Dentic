//
//  PhysicianEditViewController.swift
//  MEDDIC
//
//  Created by Tanakorn on 5/24/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import UIKit

class PhysicianEditViewController: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    var physician = RealmPhysician()
    var helper = Helper()
    var image : UIImage!
    var system = BackSystem()
    var api = APIPhysician()
    var back = BackPhysician()
    @IBOutlet weak var tf_des: UITextField!
    @IBOutlet weak var vw_edit_pic: UIView!
    @IBOutlet weak var tf_institute: UITextField!
    @IBOutlet weak var tf_major: UITextField!
    @IBOutlet weak var tf_name: UITextField!
    @IBOutlet weak var img_profile: UIImageView!
    
    @IBOutlet weak var vw_filter: UIView!
    @IBAction func btn_change_pic_action(_ sender: UIButton) {
        self.openGallery()
    }
    @IBOutlet weak var act: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.act.startAnimating()
        self.act.isHidden = true
        self.tf_des.text = self.physician.des
        self.tf_institute.text = self.physician.institute
        self.tf_major.text = self.physician.major
        self.tf_name.text = self.physician.name
        self.vw_edit_pic.layer.cornerRadius = 15
        self.vw_edit_pic.layer.masksToBounds = true
        self.helper.shadow(vw_layout: self.vw_edit_pic)
        self.helper.loadLocalProfilePicWithSuccess(id: self.physician.id, success: {(success) in
            self.img_profile.image = success
        })
        let button: UIButton = UIButton()
        button.setTitle("DONE", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(btn_update_action), for: UIControlEvents.touchUpInside)
        button.frame = CGRect(x:self.view.frame.width-40, y:0, width:40, height:40)
        let barButton = UIBarButtonItem(customView: button)
        //assign button to navigationbar
        self.navigationItem.rightBarButtonItem = barButton
        // Do any additional setup after loading the view.
    }
    func btn_update_action(sender:UIButton){
        self.vw_filter.isHidden = false
        self.act.isHidden = false
        if self.image != nil {
            self.api.uploadProfilePic(sessionID: self.system.getSessionid(), id: self.physician.id, image: self.image, success: {(success) in
                print(success)
                self.navigationController?.popViewController(animated: true)
            }, failure: {(error) in
                
            })
            self.api.updateUserInfo(sessionid: self.system.getSessionid(), physicianid: self.physician.id, name: self.tf_name.text!, gender: self.physician.gender, phoneno: self.physician.phoneno, success: {(success) in
                print(success)
                
                self.back.updatePhysicianProfile(name: self.tf_name.text!, des: self.tf_des.text!, institute: self.tf_institute.text!, major: self.tf_major.text!)
            }, failure: {(error) in
                
            })
        }else{
            self.api.updateUserInfo(sessionid: self.system.getSessionid(), physicianid: self.physician.id, name: self.tf_name.text!, gender: self.physician.gender, phoneno: self.physician.phoneno, success: {(success) in
                print(success)
                self.navigationController?.popViewController(animated: true)
                self.back.updatePhysicianProfile(name: self.tf_name.text!, des: self.tf_des.text!, institute: self.tf_institute.text!, major: self.tf_major.text!)
            }, failure: {(error) in
                
            })
        }
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func openGallery(){
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
        self.img_profile.image = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.image = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.dismiss(animated: true, completion: nil)
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
