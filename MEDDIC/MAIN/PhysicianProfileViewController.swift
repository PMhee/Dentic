//
//  PhysicianProfileViewController.swift
//  MEDDIC
//
//  Created by Tanakorn on 2/8/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import UIKit
import RealmSwift
class PhysicianProfileViewController: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var lb_description: UILabel!
    @IBOutlet weak var lb_institute: UILabel!
    @IBOutlet weak var img_institute_logo: UIImageView!
    @IBOutlet weak var lb_major: UILabel!
    @IBOutlet weak var lb_name: UILabel!
    @IBOutlet weak var vw_profile: UIView!
    @IBOutlet weak var img_profile: UIImageView!
    var api = APIPhysician()
    var system = BackSystem()
    var back = BackPhysician()
    var ui = UILoading()
    var id : String = ""
    var image : UIImage!
    var userid : String = ""
    var helper = Helper()
    var physician = try! Realm().objects(RealmPhysician.self).first
    //,"Bone Exchange","Patho Surgery","Kidney Exchange","General Doctor"
    var doctor_tag = ["Orthodontics"]
    @IBAction func btn_edit_action(_ sender: UIButton) {
        self.performSegue(withIdentifier: "edit", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setUI()
        self.api.userInfo(sessionid: self.system.getSessionid(), success: {(success) in
            self.back.downloadPhysicianProfile(success: success)
            self.setUI()
        }, failure: {(error) in
            
        })
    }
    func setUI(){
        if self.physician != nil{
            if self.physician?.id != nil{
                self.helper.loadLocalProfilePicWithSuccess(id: self.physician!.id, success: {(success) in
                    self.img_profile.image = success
                })
            }
            if self.physician?.name != nil{
                self.lb_name.text = (self.physician?.name)!
            }
            self.lb_description.text = self.physician!.des
            self.lb_institute.text = self.physician!.institute
            self.lb_major.text = self.physician!.major
        }
        self.helper.shadow(vw_layout: self.img_profile)
        self.helper.shadow(vw_layout: self.vw_profile)
        //   self.generateDoctorTag()
    }
    func generateDoctorTag(){
        if doctor_tag.count == 0{
            
        }else if doctor_tag.count == 1{
            let lb_tag_1 = UILabel()
            lb_tag_1.font = UIFont.systemFont(ofSize: 12)
            lb_tag_1.text = self.doctor_tag[0]
            let width1 = lb_tag_1.text!.characters.count*8
            lb_tag_1.frame = CGRect(x: (self.view.frame.width/2)-CGFloat(width1), y: 286, width: CGFloat(width1), height: 30)
            lb_tag_1.layer.borderWidth = 1
            lb_tag_1.layer.cornerRadius = 15
            lb_tag_1.layer.borderColor = UIColor.lightGray.cgColor
            lb_tag_1.textAlignment = .center
            self.vw_profile.addSubview(lb_tag_1)
        }else if doctor_tag.count == 2{
            let lb_tag_1 = UILabel()
            let lb_tag_2 = UILabel()
            lb_tag_1.font = UIFont.systemFont(ofSize: 12)
            lb_tag_1.text = self.doctor_tag[0]
            let width1 = lb_tag_1.text!.characters.count*8
            lb_tag_1.frame = CGRect(x: (self.view.frame.width/2)-CGFloat(width1), y: 286, width: CGFloat(width1), height: 30)
            lb_tag_1.layer.borderWidth = 1
            lb_tag_1.layer.cornerRadius = 15
            lb_tag_1.layer.borderColor = UIColor.lightGray.cgColor
            lb_tag_1.textAlignment = .center
            self.vw_profile.addSubview(lb_tag_1)
        }else if doctor_tag.count == 3{
            
        }else{
            
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "edit"{
            if let des = segue.destination as? PhysicianEditViewController{
                if self.physician != nil{
                    des.physician = self.physician!
                }
            }
        }
    }
}
