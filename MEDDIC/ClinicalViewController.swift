//
//  ClinicalViewController.swift
//  MEDDIC
//
//  Created by Tanakorn on 1/18/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import UIKit
import TagListView
import RealmSwift
class ClinicalViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UITextViewDelegate,TagListViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIGestureRecognizerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    var MAX_SEARCH_MESHTAG : CGFloat = 0
    struct Image {
        var img = UIImage()
        var id : String = ""
    }
    struct ClinicalForm {
        var clinical_field_question : String = ""
        var clinical_field_answer : String = ""
        var clinical_field_answer_color : Int = 0
    }
    var apiPatient = APIPatient()
    var inProgress = false //for add more customform
    var tf_tag_y :CGFloat = 0
    var presetImage = ["Skull","Pelvis","Upper_Limb_Lt","Upper_Limb_Rt","Hand_Lt","Hand_Rt","Shoulder_Lt","Shoulder_Rt","Thoracic spine","Vertebral column","Hip_Lt","Hip_Rt","Knee_Lt","Knee_Rt","Lower_Limb_Lt","Lower_Limb_Rt","Humerus_Lt","Humerus_Rt","Ankle_Lt","Ankle_Rt","Foot_Lt","Foot_Rt","Neuro"]
    var inImage = false
    var backMeshtag = BackMeshtag()
    var preset : UIImage?
    var picture_no : Int!
    var isTool = false
    var oldPic = [Image]()
    var histPic = [Picture]()
    var tool = [String]()
    var inType = false
    var followUp = RealmFollowup()
    var listFU = RealmListFollowup()
    var listFollowUp = try! Realm().objects(RealmFollowup.self)
    var back = BackPatient()
    var uiLoading = UILoading()
    var backSystem = BackSystem()
    var api = APIPatient()
    var helper = Helper()
    var inTag = false
    var uiTable = UITable()
    var color = Color()
    var clinicalForm = [ClinicalForm]()
    var patient = RealmPatient()
    var isUpdate = false
    let sectionInsets = UIEdgeInsets(top: 2, left:2, bottom: 2, right: 2)
    var y : CGFloat = 0
    var hashTag = [String]()
    var images = [Image]()
    var isFirst = false
    var viewForZoom = UIView()
    var apiGroup = APIGroup()
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var gesture: UIGestureRecognizer!
    //PatientProfile
    var didChangeStatus = false
    var meshTag = [String]()
    var picture = [Picture]()
    var start_x : CGFloat = 0
    var begin_x : CGFloat = 0
    @IBOutlet weak var tableView_meshtag: UITableView!
    @IBOutlet weak var vw_table_meshtag: UIView!
    @IBOutlet weak var vw_searchMeshtag: UIView!
    @IBOutlet weak var cons_height_searchMeshtag: NSLayoutConstraint!
    @IBOutlet weak var cons_tableView_meshtag: NSLayoutConstraint!
    @IBOutlet weak var vw_hashtag: UIView!
    @IBOutlet weak var vw_filter: UIView!
    @IBOutlet weak var act: UIActivityIndicatorView!
    @IBOutlet weak var img_profile_large: UIImageView!
    @IBOutlet weak var vw_image_profile: UIView!
    @IBOutlet weak var vw_top: UIView!
    @IBOutlet weak var vw_patient_profile: UIView!
    @IBOutlet weak var cons_height_tableView_ClinicalForm: NSLayoutConstraint!
    @IBOutlet weak var tableView_ClinicalForm: UITableView!
    @IBOutlet weak var img_profile: UIImageView!
    @IBOutlet weak var lb_name: UILabel!
    
    @IBOutlet weak var lb_hn: UILabel!
    @IBOutlet weak var sg_status: UISegmentedControl!
    @IBOutlet weak var cons_top: NSLayoutConstraint!
    @IBOutlet weak var vw_customForm: UIView!
    @IBOutlet weak var cons_height_customForm: NSLayoutConstraint!
    @IBOutlet weak var tableCustomForm: UITableView!
    
    @IBOutlet weak var lb_cover_followup: UILabel!
    @IBAction func btn_history_action(_ sender: UIButton) {
        self.performSegue(withIdentifier: "history", sender: self)
        //        self.vw_history.isHidden = false
        //        self.vw_select_page.isHidden = false
    }
    @IBAction func btn_clinical_note_action(_ sender: UIButton) {
    }
    @IBAction func btn_questionare_action(_ sender: UIButton) {
        self.performSegue(withIdentifier: "customForm", sender: self)
    }
    @IBAction func btn_edit_action(_ sender: UIButton) {
        self.performSegue(withIdentifier: "edit", sender: self)
    }
    
    @IBAction func btn_edit_annotate_action(_ sender: UIButton) {
        self.performSegue(withIdentifier: "edit_annotate", sender: self)
    }
    @IBAction func btn_camera_action(_ sender: UIButton) {
        
    }
    @IBAction func sg_status_change(_ sender: UISegmentedControl) {
        self.didChangeStatus = true
        let status = try! Realm().objects(RealmStatus.self)
        self.vw_top.backgroundColor = UIColor(netHex: status[sender.selectedSegmentIndex].color)
    }
    @IBAction func btn_view_profile_pic_action(_ sender: UIButton) {
        self.performSegue(withIdentifier: "edit", sender: self)
        //        self.navigationController?.isNavigationBarHidden = true
        //        self.img_profile_large.image = self.img_profile.image
        //        self.vw_image_profile.isHidden = false
        //self.performSegue(withIdentifier: "profilePic", sender: self)
    }
    @IBAction func btn_cancel_profile_pic_action(_ sender: UIButton) {
        self.vw_image_profile.isHidden = true
        self.navigationController?.isNavigationBarHidden = false
    }
    
    
    
    //Clinical Note
    @IBOutlet weak var btn_date: UIButton!
    @IBOutlet weak var vw_clinicalNote: UIView!
    @IBOutlet weak var tv_note: UITextView!
    @IBOutlet weak var cons_height_tv_note: NSLayoutConstraint!
    
    //Tag
    var lastrow = 0
    
    @IBOutlet weak var cons_height_vw_tag: NSLayoutConstraint!
    @IBOutlet weak var tf_tag: UITextField!
    @IBOutlet weak var vw_tag: TagListView!
    @IBOutlet weak var lb_hashtag: UILabel!
    @IBAction func tf_hashtag_change(_ sender: UITextField) {
        if sender.text! == ""{
            self.lb_hashtag.isHidden = true
        }else{
            self.lb_hashtag.isHidden = false
        }
        self.meshTag = [String]()
        let array = self.backMeshtag.getMeshtag(id: sender.text!)
        for i in 0..<array.count{
            self.meshTag.append(array[i].tag)
        }
        if sender.text! == ""{
            self.meshTag = [String]()
        }
        self.tableView_meshtag.reloadData()
        self.tableView_meshtag.layoutIfNeeded()
        if self.tableView_meshtag.contentSize.height > self.MAX_SEARCH_MESHTAG{
            self.cons_tableView_meshtag.constant = self.MAX_SEARCH_MESHTAG
        }else{
            self.cons_tableView_meshtag.constant = self.tableView_meshtag.contentSize.height
        }
        self.api.searchMeshTag(sessionID: self.backSystem.getSessionid(), keyword: sender.text!, success: {(success) in
            self.backMeshtag.downloadMeshtag(success: success)
            self.meshTag = [String]()
            let array = self.backMeshtag.getMeshtag(id: sender.text!)
            for i in 0..<array.count{
                self.meshTag.append(array[i].tag)
            }
//            if let array = success.value(forKey: "content") as? NSArray{
//                for i in 0..<array.count{
//                    if let content = array[i] as? NSDictionary{
//                        if let name = content.value(forKey: "name") as? String{
//                            self.meshTag.append(name)
//                        }
//                    }
//                }
//            }
            if sender.text! == ""{
                self.meshTag = [String]()
            }
            self.tableView_meshtag.reloadData()
            self.tableView_meshtag.layoutIfNeeded()
            if self.tableView_meshtag.contentSize.height > self.MAX_SEARCH_MESHTAG{
                self.cons_tableView_meshtag.constant = self.MAX_SEARCH_MESHTAG
            }else{
                self.cons_tableView_meshtag.constant = self.tableView_meshtag.contentSize.height
            }
        }, failure: {(error) in
            
        })
    }
    //DatePicker
    @IBOutlet weak var vw_datePicker: UIView!
    @IBOutlet weak var vw_filter_datePicker: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var btn_confirm_datePicker: UIButton!
    @IBOutlet weak var btn_cancel_datePicker: UIButton!
    @IBAction func btn_date_action(_ sender: UIButton) {
        self.vw_filter_datePicker.isHidden = false
        self.vw_datePicker.isHidden = false
    }
    @IBAction func btn_cancel_datePicker_action(_ sender: UIButton) {
        self.vw_filter_datePicker.isHidden = true
        self.vw_datePicker.isHidden = true
    }
    @IBAction func btn_confirm_datePicker_action(_ sender: UIButton) {
        self.vw_filter_datePicker.isHidden = true
        self.vw_datePicker.isHidden = true
        self.btn_date.setTitle(self.helper.dateToStringOnlyDate(date: self.datePicker.date), for: .normal)
        self.initFollowUp()
    }
    @IBAction func datePicker_change(_ sender: UIDatePicker) {
    }
    //Tool Picker
    @IBOutlet weak var vw_tool_picker: UIView!
    @IBOutlet weak var tableView_tools: UITableView!
    
    @IBAction func btn_tools(_ sender: UIButton) {
        self.tableView_tools.reloadData()
        self.vw_filter_tool_picker.isHidden = false
        self.vw_tool_picker.isHidden = false
        //self.cons_height_vw_tool.constant = self.tableView_tools.contentSize.height
        self.isTool = true
    }
    //View Image
    @IBOutlet weak var vw_image: UIView!
    @IBOutlet weak var collectionView_image: UICollectionView!
    @IBOutlet weak var cons_height_collectionView: NSLayoutConstraint!
    
    @IBOutlet weak var vw_filter_tool_picker: UIView!
    
    //View Preset
    @IBOutlet weak var vw_preset: UIView!
    @IBOutlet weak var collectionView_preset: UICollectionView!
    @IBOutlet weak var btn_cancel_preset: UIButton!
    @IBAction func btn_cancel_preset_action(_ sender: UIButton) {
        self.vw_preset.isHidden = true
    }
    @IBAction func btn_update_action(_ sender: UIButton) {
        self.vw_filter.isHidden = false
        self.act.isHidden = false
        self.act.startAnimating()
        var updatedImage = [Image]()
        for i in 0..<self.images.count{
            if self.oldPic.count == 0 {
                updatedImage.append(self.images[i])
            }else{
                for j in 0..<self.oldPic.count{
                    if self.oldPic[j].id != self.images[i].id{
                        updatedImage.append(self.images[i])
                    }
                }
            }
        }
        if updatedImage.count > 0{
        }else{
            self.navigationController?.popViewController(animated: false)
        }
        if self.didChangeStatus{
            if self.patient.lastfudate != nil{
                if self.datePicker.date >= self.patient.lastfuupdatetime{
                    self.back.updateStatus(patient: self.patient, status: self.sg_status.titleForSegment(at: self.sg_status.selectedSegmentIndex)!)
                }
            }else{
                self.back.updateStatus(patient: self.patient, status: self.sg_status.titleForSegment(at: self.sg_status.selectedSegmentIndex)!)
            }
        }
        if self.isUpdate{
            if self.patient.status != ""{
                self.apiPatient.updatePatientMeshtag(meshtag: self.hashTag, patientid: self.patient.id, success: {(success) in
                
                }, failure: {(error) in
                
                })
                self.api.updateFollowUp(sessionID: self.backSystem.getSessionid(), patientid: self.patient.id, followupid: self.followUp.id, followupnote: self.tv_note.text!, meshtag: self.hashTag, opdtag: self.sg_status.titleForSegment(at: self.sg_status.selectedSegmentIndex)!, followupdate: self.helper.dateToServer(date: self.datePicker.date) , success: {(success) in
                    if let content = success.value(forKey: "content") as? NSDictionary{
                        if let ID = content.value(forKey: "_id") as? NSDictionary{
                            if let id = ID.value(forKey: "$id") as? String{
                                try! Realm().write{
                                self.followUp.id = id
                                }
                            }
                        }
                        if let updatetime = content.value(forKey: "updatetime") as? String{
                            try! Realm().write{
                                self.followUp.updatetime = self.helper.StringToDate(date: updatetime)
                                self.patient.lastfuupdatetime = self.helper.StringToDate(date: updatetime)
                            }
                        }
                        for i in 0..<updatedImage.count{
                            self.api.uploadOPDPictureWithUIImage(sessionID: self.backSystem.getSessionid(), patientid: self.patient.id, fudocid: self.followUp.id, image: updatedImage[i].img, success: {(success) in
                                self.navigationController?.popViewController(animated: false)
                            }, failure: {(error) in
                                
                            })
                        }
                    }
                }, failure: {(error) in
                    print(error)
                })
                self.back.updateFollowUp(date: self.datePicker.date, note: self.tv_note.text!, hashtag: self.hashTag, pic: self.images, followup: self.followUp,patient:self.patient,status:self.sg_status.titleForSegment(at: self.sg_status.selectedSegmentIndex)!,picture:self.picture,listFollowup:self.listFU)
            }else{
                self.apiPatient.updatePatientMeshtag(meshtag: self.hashTag, patientid: self.patient.id, success: {(success) in
                    
                }, failure: {(error) in
                    
                })
                self.api.updateFollowUp(sessionID: self.backSystem.getSessionid(), patientid: self.patient.id, followupid: self.followUp.id, followupnote: self.tv_note.text!, meshtag: self.hashTag, opdtag: "", followupdate: self.helper.dateToServer(date: self.datePicker.date) , success: {(success) in
                    
                    if let content = success.value(forKey: "content") as? NSDictionary{
                        if let ID = content.value(forKey: "_id") as? NSDictionary{
                            if let id = ID.value(forKey: "$id") as? String{
                                try! Realm().write{
                                self.followUp.id = id
                                }
                            }
                        }
                        if let updatetime = content.value(forKey: "updatetime") as? String{
                            try! Realm().write{
                                self.followUp.updatetime = self.helper.StringToDate(date: updatetime)
                                self.patient.lastfuupdatetime = self.helper.StringToDate(date: updatetime)
                            }
                        }
                        for i in 0..<updatedImage.count{
                            self.api.uploadOPDPictureWithUIImage(sessionID: self.backSystem.getSessionid(), patientid: self.patient.id, fudocid: self.followUp.id, image: updatedImage[i].img, success: {(success) in
                                self.navigationController?.popViewController(animated: false)
                            }, failure: {(error) in
                                
                            })
                        }
                    }
                }, failure: {(error) in
                    print(error)
                })
                
                self.back.updateFollowUp(date: self.datePicker.date, note: self.tv_note.text!, hashtag: self.hashTag, pic: self.images, followup: self.followUp,patient:self.patient,status:"",picture:self.picture,listFollowup:self.listFU)
            }
        }else{
            if self.patient.status != ""{
                self.apiPatient.updatePatientMeshtag(meshtag: self.hashTag, patientid: self.patient.id, success: {(success) in
                    
                }, failure: {(error) in
                    
                })
                self.api.createFollowup(sessionID: self.backSystem.getSessionid(), patientid: self.patient.id, followupnote: self.tv_note.text, meshtag: self.hashTag, opdtag: self.sg_status.titleForSegment(at: self.sg_status.selectedSegmentIndex)!, followupdate: self.helper.dateToServer(date: self.datePicker.date), success: {(success) in
                    if let content = success.value(forKey: "content") as? NSDictionary{
                        if let ID = content.value(forKey: "_id") as? NSDictionary{
                            if let id = ID.value(forKey: "$id") as? String{
                                self.followUp.id = id
                            }
                        }
                        if let updatetime = content.value(forKey: "updatetime") as? String{
                            try! Realm().write{
                                self.followUp.updatetime = self.helper.StringToDate(date: updatetime)
                                self.patient.lastfuupdatetime = self.helper.StringToDate(date: updatetime)
                            }
                        }
                        
                        for i in 0..<updatedImage.count{
                            self.api.uploadOPDPictureWithUIImage(sessionID: self.backSystem.getSessionid(), patientid: self.patient.id, fudocid: self.followUp.id, image: updatedImage[i].img, success: {(success) in
                                self.navigationController?.popViewController(animated: false)
                            }, failure: {(error) in
                                
                            })
                        }
                        self.back.createFollowup(date: self.datePicker.date, note: self.tv_note.text!, hashtag: self.hashTag, pic: self.images,patient:self.patient,status:self.sg_status.titleForSegment(at: self.sg_status.selectedSegmentIndex)!,picture:self.picture,id:self.followUp.id,updatetime:self.followUp.updatetime)
                    }
                }, failure: {(error) in
                    
                })
                
            }else{
                self.apiPatient.updatePatientMeshtag(meshtag: self.hashTag, patientid: self.patient.id, success: {(success) in
                    
                }, failure: {(error) in
                    
                })
                self.api.createFollowup(sessionID: self.backSystem.getSessionid(), patientid: self.patient.id, followupnote: self.tv_note.text, meshtag: self.hashTag, opdtag: "", followupdate: self.helper.dateToServer(date: self.datePicker.date), success: {(success) in
                    if let content = success.value(forKey: "content") as? NSDictionary{
                        if let ID = content.value(forKey: "_id") as? NSDictionary{
                            if let id = ID.value(forKey: "$id") as? String{
                                self.followUp.id = id
                            }
                        }
                        
                        for i in 0..<updatedImage.count{
                            self.api.uploadOPDPictureWithUIImage(sessionID: self.backSystem.getSessionid(), patientid: self.patient.id, fudocid: self.followUp.id, image: updatedImage[i].img, success: {(success) in
                                self.navigationController?.popViewController(animated: false)
                            }, failure: {(error) in
                                
                            })
                        }
                        if let updatetime = content.value(forKey: "updatetime") as? String{
                            try! Realm().write{
                                self.followUp.updatetime = self.helper.StringToDate(date: updatetime)
                                self.patient.lastfuupdatetime = self.helper.StringToDate(date: updatetime)
                            }
                            
                        }
                        self.back.createFollowup(date: self.datePicker.date, note: self.tv_note.text!, hashtag: self.hashTag, pic: self.images,patient:self.patient,status:"",picture:self.picture,id:self.followUp.id,updatetime:self.followUp.updatetime)
                    }
                    
                }, failure: {(error) in
                    
                })
                
            }
        }
    }
    //View ProfilePic
    override func viewDidLoad() {
        super.viewDidLoad()
        self.act.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(addAnnotateImage(notification:)), name: NSNotification.Name(rawValue: "addAnnotateImage"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(inFuProgress), name: NSNotification.Name(rawValue: "inFuProgress"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        let panGesture = UIPanGestureRecognizer(target: self, action:#selector(handlePanGesture))
        self.view.addGestureRecognizer(panGesture)
        self.tf_tag.delegate = self
        self.vw_tag.delegate = self
        self.gesture.delegate = self
        self.tv_note.delegate = self
        self.view.addGestureRecognizer(self.gesture)
        // Do any additional setup after loading the view.
    }
    
    func inFuProgress(notification:NSNotification){
        self.inProgress = true
        self.downloadFollowUp()
    }
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.MAX_SEARCH_MESHTAG = self.view.frame.height - keyboardSize.height - self.vw_hashtag.frame.height
            //self.cons_height_searchMeshtag.constant = self.MAX_SEARCH_MESHTAG
            //self.cons_tableView_meshtag.constant = self.MAX_SEARCH_MESHTAG
        }
    }
    func handlePanGesture(panGestureRecognizer : UIPanGestureRecognizer!){
        switch (panGestureRecognizer.state) {
        case UIGestureRecognizerState.began:
            self.start_x = (panGestureRecognizer.location(in: self.view).x)
            self.begin_x = (panGestureRecognizer.location(in: self.view).x)
        case UIGestureRecognizerState.changed:
            var position = self.begin_x
            position = panGestureRecognizer.location(in: self.view).x - begin_x
            self.begin_x = panGestureRecognizer.location(in: self.view).x
        //self.pageAnimation(view1: self.container_home, view2: self.container_rotation, const1: self.cons_Container_home_align_x, const2: self.cons_Container_rotation_align_x, changePosition: position)
        case UIGestureRecognizerState.ended:
            if self.start_x - (panGestureRecognizer.location(in: self.view).x) > 60 {
                self.performSegue(withIdentifier: "history", sender: self)
            }
        default: print("fail")
        }
    }
    func addAnnotateImage(notification:NSNotification){
        let data = notification.userInfo?["pic"] as! UIImage
        if notification.userInfo?["isEdit"] as! Bool{
            let index = notification.userInfo?["picture_no"] as! Int
            self.images[index].img = data
            self.collectionView_image.reloadData()
            self.collectionView_image.layoutIfNeeded()
            self.cons_height_collectionView.constant = self.collectionView_image.contentSize.height
        }else{
            var image = Image()
            image.id = self.helper.generateID()
            image.img = data
            var pic = Picture()
            pic.id = image.id
            pic.fudocid = self.followUp.id
            pic.patientid = self.patient.id
            self.picture.append(pic)
            self.images.append(image)
            self.collectionView_image.reloadData()
            self.collectionView_image.layoutIfNeeded()
            self.cons_height_collectionView.constant = self.collectionView_image.contentSize.height
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !self.inImage{
            self.setClinicalForm()
            self.downloadFollowUp()
            self.initValue()
            self.setUI()
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        
    }
    override func viewDidLayoutSubviews() {
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if self.inType{
            if self.helper.inBound(x: touch.location(in: self.tv_note).x, y: touch.location(in: self.tv_note).y, view: self.tv_note){
                return true
            }else{
                self.inType = false
                self.tv_note.resignFirstResponder()
                return true
            }
        }else if self.isTool{
            if self.helper.inBound(x: touch.location(in: self.vw_tool_picker).x, y: touch.location(in: self.vw_tool_picker).y, view: self.vw_tool_picker){
                return false
            }else{
                self.isTool = false
                self.vw_tool_picker.isHidden = true
                self.vw_filter_tool_picker.isHidden = true
                return true
            }
        }else{
            return false
        }
    }
    func downloadFollowUp(){
        if self.patient.listFollowUp.count == 0 {
            if !self.patient.isDownload{
                self.vw_filter.isHidden = false
                self.act.isHidden = false
                self.act.startAnimating()
            }
            self.api.listUpdatedFollowUp(sessionid: self.backSystem.getSessionid(), updatetime: "", patientid: self.patient.id, data: "true", success: {(success) in
                self.vw_filter.isHidden = true
                self.act.isHidden = true
                self.back.setIsDwonloaded(patient: self.patient)
                self.back.downloadFollowUp(dic: success, patient: self.patient,isUpdate: false)
                self.initValue()
                self.initFollowUp()
                self.setUI()
                self.vw_filter.isHidden = true
                self.act.isHidden = true
            }, failure: {(error) in
                self.vw_filter.isHidden = true
                self.act.isHidden = true
                self.uiLoading.showErrorNav(error: "No internet connection", view: self.view)
            })
        }else{
            self.api.listUpdatedFollowUp(sessionid: self.backSystem.getSessionid(), updatetime: self.helper.dateToServer(date: self.patient.lastfuupdatetime), patientid: self.patient.id, data: "true", success: {(success) in
                self.back.downloadFollowUp(dic: success, patient: self.patient,isUpdate: true)
                self.initValue()
                self.initFollowUp()
                self.setUI()
                self.vw_filter.isHidden = true
                self.act.isHidden = true
                
            }, failure: {(error) in
                self.vw_filter.isHidden = true
                self.act.isHidden = true
                self.uiLoading.showErrorNav(error: "No internet connection", view: self.view)
            })
        }
    }
    func isToday() -> Bool{
        if self.patient.followup.first?.followdate != nil {
            if self.helper.dateToStringOnlyDate(date: Date()) == self.helper.dateToStringOnlyDate(date: self.patient.followup.first?.followdate){
                return true
            }else{
                return false
            }
        }else{
            return false
        }
    }
    func setUI(){
        let button: UIButton = UIButton()
        button.setTitle("DONE", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(btn_update_action), for: UIControlEvents.touchUpInside)
        button.frame = CGRect(x:self.view.frame.width-40, y:0, width:40, height:40)
        let barButton = UIBarButtonItem(customView: button)
        //assign button to navigationbar
        self.navigationItem.rightBarButtonItem = barButton
        self.img_profile.layer.cornerRadius = 2
        self.img_profile.layer.borderWidth = 2
        self.img_profile.layer.borderColor = UIColor.white.cgColor
        self.img_profile.layer.masksToBounds = true
        self.btn_cancel_datePicker.layer.cornerRadius = 3
        self.btn_cancel_datePicker.layer.borderWidth = 1
        self.btn_cancel_datePicker.layer.borderColor = UIColor(netHex: 0x1B5391).cgColor
        self.btn_cancel_datePicker.layer.masksToBounds = true
        self.btn_confirm_datePicker.backgroundColor = UIColor(netHex: 0x1B5391)
        self.btn_confirm_datePicker.layer.cornerRadius = 3
        self.btn_confirm_datePicker.layer.masksToBounds = true
        self.collectionView_image.reloadData()
        self.collectionView_image.layoutIfNeeded()
        self.cons_height_collectionView.constant = self.collectionView_image.contentSize.height
        self.tv_note.layer.cornerRadius = 2
        self.tv_note.layer.masksToBounds = true
        self.btn_cancel_preset.layer.cornerRadius = 2
        self.btn_cancel_preset.layer.masksToBounds = true
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        let status = try! Realm().objects(RealmStatus.self)
        self.sg_status.removeAllSegments()
        for i in 0..<status.count{
            self.sg_status.insertSegment(withTitle: status[i].name, at: i, animated: false)
        }
        for i in 0..<status.count{
            if status[i].name == self.patient.status{
                self.sg_status.selectedSegmentIndex = i
                self.vw_top.backgroundColor = UIColor(netHex:status[i].color)
                break
            }else{
                self.sg_status.selectedSegmentIndex = 0
            }
        }
        self.initFollowUp()
        //self.helper.setButtomBorder(tf: self.tf_tag)
    }
    func initValue(){
        self.tool = [String]()
        self.tool.append("Camera")
        self.tool.append("Gallery")
        self.tool.append("Annotate")
        self.tool.append("Preset")
        self.helper.loadLocalProfilePic(id: self.patient.id,image:self.img_profile)
        self.lb_name.text = self.patient.name
        self.lb_hn.text = self.patient.HN
        self.clinicalForm[0].clinical_field_answer = self.patient.gender
        self.clinicalForm[1].clinical_field_answer = self.patient.age
        if self.patient.phoneno.count > 0{
            self.clinicalForm[2].clinical_field_answer = self.patient.phoneno[0].phoneno
        }
        //self.listFollowUp = self.back.sortFollowup(followUp: self.patient.followup)
        self.tableView_ClinicalForm.reloadData()
        self.tableView_ClinicalForm.layoutIfNeeded()
        self.cons_height_tableView_ClinicalForm.constant = self.tableView_ClinicalForm.contentSize.height
        self.btn_date.setTitle(self.helper.dateToStringOnlyDate(date: self.datePicker.date), for: .normal)
    }
    func initFollowUp(){
        if self.back.findFuByDate(date: self.helper.dateToStringOnlyDate(date: self.datePicker.date) ,patient:self.patient) != nil{
            self.listFU = self.back.findFuByDate(date: self.helper.dateToStringOnlyDate(date: self.datePicker.date) ,patient:self.patient)!
            if self.inProgress{
                self.followUp = self.listFU.followup.first!
            }
            self.tableCustomForm.reloadData()
            self.tableCustomForm.layoutIfNeeded()
            self.cons_height_customForm.constant = self.tableCustomForm.contentSize.height
            self.cons_height_collectionView.constant = self.collectionView_image.contentSize.height
            self.isUpdate = true
            self.hashTag = [String]()
            self.vw_tag.removeAllTags()
            self.hashTag = [String]()
            for i in 0..<self.patient.meshtag.count{
                self.hashTag.append(self.patient.meshtag[i].tag)
                self.vw_tag.addTag("#"+self.patient.meshtag[i].tag)
                if lastrow < self.vw_tag.lastRow{
                    self.lastrow = self.vw_tag.lastRow
                    self.cons_height_vw_tag.constant += 20
                }
            }
        }else{
            self.followUp = RealmFollowup()
            self.tv_note.text = ""
            if self.tv_note.text == ""{
                self.lb_cover_followup.isHidden = false
            }
            self.hashTag = [String]()
            self.vw_tag.removeAllTags()
            self.hashTag = [String]()
            for i in 0..<self.patient.meshtag.count{
                self.hashTag.append(self.patient.meshtag[i].tag)
                self.vw_tag.addTag("#"+self.patient.meshtag[i].tag)
                if lastrow < self.vw_tag.lastRow{
                    self.lastrow = self.vw_tag.lastRow
                    self.cons_height_vw_tag.constant += 20
                }
            }
            self.images = [Image]()
            self.collectionView_image.reloadData()
            self.collectionView_image.layoutIfNeeded()
            self.tableCustomForm.reloadData()
            self.tableCustomForm.layoutIfNeeded()
            self.cons_height_customForm.constant = self.tableCustomForm.contentSize.height
            self.cons_height_collectionView.constant = self.collectionView_image.contentSize.height
            self.isUpdate = false
        }
    }
    func setClinicalForm(){
        self.clinicalForm = [ClinicalForm]()
        var gender = ClinicalForm()
        gender.clinical_field_question = "Gender"
        self.clinicalForm.append(gender)
        var age = ClinicalForm()
        age.clinical_field_question = "Age"
        self.clinicalForm.append(age)
        var telephone = ClinicalForm()
        telephone.clinical_field_question = "Telephone"
        telephone.clinical_field_answer_color = self.color.flatMintLight
        self.clinicalForm.append(telephone)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.scrollView.scrollRectToVisible(self.vw_tag.frame, animated: false)
        if textField.tag == 2{
            self.vw_searchMeshtag.isHidden = true
            self.vw_table_meshtag.isHidden = true
            self.cons_top.constant += self.tf_tag_y
        }else{
            self.cons_top.constant += 350
        }
        self.scrollView.contentOffset.y = self.y
        self.lb_hashtag.isHidden = true
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.y = self.scrollView.contentOffset.y
        if textField.tag == 2{
            self.inTag = true
            
            self.tf_tag_y = self.vw_hashtag.frame.origin.y
            self.cons_top.constant -= self.vw_hashtag.frame.origin.y
            self.vw_searchMeshtag.isHidden = false
            self.vw_table_meshtag.isHidden = false
        }else{
            self.cons_top.constant -= 350
        }
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text! != ""{
            self.hashTag.append(textField.text!)
            self.vw_tag.addTag("#"+textField.text!)
            if lastrow < self.vw_tag.lastRow{
                self.lastrow = self.vw_tag.lastRow
                self.cons_height_vw_tag.constant += 20
            }
            self.inTag = false
            self.meshTag = [String]()
            self.tableView_meshtag.reloadData()
            self.cons_tableView_meshtag.constant = 0
        }
        textField.text = ""
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.inType = true
        self.lb_cover_followup.isHidden = true
        self.cons_top.constant -= 200
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        self.cons_top.constant += 200
        if textView.text == ""{
            self.lb_cover_followup.isHidden = false
        }else{
            self.lb_cover_followup.isHidden = true
        }
    }
    func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
        self.vw_tag.removeTag(title)
        for i in 0..<self.hashTag.count{
            if title == "#"+self.hashTag[i]{
                self.hashTag.remove(at: i)
                break
            }
        }
        if lastrow > self.vw_tag.lastRow{
            self.lastrow = self.vw_tag.lastRow
            self.cons_height_vw_tag.constant -= 20
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "tool", for: indexPath)
            let pic = cell.viewWithTag(1) as! UIImageView
            let lb = cell.viewWithTag(2) as! UILabel
            pic.image = UIImage(named: self.tool[indexPath.row])
            lb.text = self.tool[indexPath.row]
            return cell
        }else if tableView.tag == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: "meshtag", for: indexPath)
            let lb_meshtag = cell.viewWithTag(1) as! UILabel
            lb_meshtag.text = self.meshTag[indexPath.row]
            return cell
        }else if tableView.tag == 3{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            let vw_icon = cell.viewWithTag(1)
            let img_icon = cell.viewWithTag(2) as! UIImageView
            let lb_name = cell.viewWithTag(3) as! UILabel
            let vw_score = cell.viewWithTag(4)
            let lb_score = cell.viewWithTag(5) as! UILabel
            let vw_layout = cell.viewWithTag(6)
            vw_icon?.backgroundColor = UIColor(netHex: self.followUp.cusforms[indexPath.row].color)
            self.helper.downloadImageFrom(link:self.followUp.cusforms[indexPath.row].picurl , contentMode: .scaleAspectFill, img: img_icon)
            //self.helper.loadLocalProfilePic(id: self.followUp.cusforms[indexPath.row].cfansid, image: img_icon)
            lb_name.text = self.followUp.cusforms[indexPath.row].cusfomrname
            vw_score?.backgroundColor = UIColor(netHex: self.followUp.cusforms[indexPath.row].color)
            lb_score.text = String(format:"%.2f", self.followUp.cusforms[indexPath.row].score)
            self.uiTable.shadow(vw_layout: vw_layout!)
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            let lb_question = cell.viewWithTag(1) as! UILabel
            let lb_answer = cell.viewWithTag(2) as! UILabel
            lb_question.text = self.clinicalForm[indexPath.row].clinical_field_question
            lb_answer.text = self.clinicalForm[indexPath.row].clinical_field_answer
            lb_answer.textColor = UIColor(netHex: self.clinicalForm[indexPath.row].clinical_field_answer_color)
            return cell
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 1{
            return self.tool.count
        }else if tableView.tag == 2{
            return self.meshTag.count
        }else if tableView.tag == 3{
            return self.followUp.cusforms.count
        }else{
            return self.clinicalForm.count
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView.tag == 1 || tableView.tag == 2{
            return 44
        }else if tableView.tag == 3{
            return 60
        }else{
            return 35
        }
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag == 1{
            if indexPath.row == 0 {
                self.openCamera()
                self.isTool = false
                self.vw_filter_tool_picker.isHidden = true
                self.vw_tool_picker.isHidden = true
            }else if indexPath.row == 1{
                self.openGallery()
                self.isTool = false
                self.vw_filter_tool_picker.isHidden = true
                self.vw_tool_picker.isHidden = true
            }else if indexPath.row == 2{
                self.isTool = false
                self.vw_filter_tool_picker.isHidden = true
                self.vw_tool_picker.isHidden = true
                self.performSegue(withIdentifier: "annotate", sender: self)
            }else if indexPath.row == 3{
                self.isTool = false
                self.vw_preset.isHidden = false
                self.vw_filter_tool_picker.isHidden = true
                self.vw_tool_picker.isHidden = true
            }
            
        }else if tableView.tag == 2{
            self.hashTag.append(self.meshTag[indexPath.row])
            self.vw_tag.addTag("#"+self.meshTag[indexPath.row])
            if lastrow < self.vw_tag.lastRow{
                self.lastrow = self.vw_tag.lastRow
                self.cons_height_vw_tag.constant += 20
            }
            self.tf_tag.text = ""
            self.meshTag = [String]()
            self.tableView_meshtag.reloadData()
            self.cons_tableView_meshtag.constant = 0
        }
    }
    func openCamera(){
        self.inImage = true
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            var imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    func openGallery(){
        self.inImage = true
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
        var image = Image()
        image.id = self.helper.generateID()
        image.img = info[UIImagePickerControllerOriginalImage] as! UIImage
        var pic = Picture()
        pic.id = image.id
        pic.fudocid = self.followUp.id
        pic.patientid = self.patient.id
        self.picture.append(pic)
        self.images.append(image)
        self.dismiss(animated: true, completion: nil)
        self.collectionView_image.reloadData()
        self.collectionView_image.layoutIfNeeded()
        self.cons_height_collectionView.constant = self.collectionView_image.contentSize.height
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 1{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "preset", for: indexPath)
            let img = cell.viewWithTag(1) as! UIImageView
            img.image = UIImage(named: self.presetImage[indexPath.row]+".jpg")
            return cell
        }else if collectionView.tag == 2{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
            let scrollview = cell.viewWithTag(10) as! UIScrollView
            scrollview.delegate = self
            let vw = scrollview.viewWithTag(10)
            let img = vw?.viewWithTag(11) as! UIImageView
            self.helper.loadLocalProfilePic(id: self.histPic[indexPath.row].id, image: img)
            return cell
            
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
            let img = cell.viewWithTag(1) as! UIImageView
            img.image = self.images[indexPath.row].img
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 1{
            return self.presetImage.count
        }else if collectionView.tag == 2{
            return self.histPic.count
        }else{
            return self.images.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 1{
            self.vw_preset.isHidden = true
            self.preset = UIImage(named: self.presetImage[indexPath.row]+".jpg")!
            self.performSegue(withIdentifier: "annotate", sender: self)
            //            var image = Image()
            //            image.id = self.helper.generateID()
            //            image.img = UIImage(named: self.presetImage[indexPath.row]+".jpg")!
            //            self.images.append(image)
            //            self.collectionView_image.reloadData()
            //            self.collectionView_image.layoutIfNeeded()
            //            self.cons_height_collectionView.constant = self.collectionView_image.contentSize.height
        }else{
            self.navigationController?.isNavigationBarHidden = true
            self.vw_image_profile.isHidden = false
            self.img_profile_large.image = self.images[indexPath.row].img
            self.picture_no = indexPath.row
        }
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag == 1{
            let paddingSpace = sectionInsets.left * (2 + 1)
            let availableWidth = self.view.frame.width - paddingSpace
            let widthPerItem = availableWidth / 2
            return CGSize(width: widthPerItem, height: widthPerItem)
        }else if collectionView.tag == 2{
            return CGSize(width: self.view.frame.width, height: self.view.frame.height)
        }else{
            let paddingSpace = sectionInsets.left * (3 + 1)
            let availableWidth = self.view.frame.width - paddingSpace
            let widthPerItem = availableWidth / 3
            return CGSize(width: widthPerItem, height: widthPerItem)
        }
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "history"{
            if let des = segue.destination as? HistoryViewController{
                des.patient = self.patient
                self.inImage = true
            }
        }else if segue.identifier == "edit"{
            if let des = segue.destination as? PatientProfileViewController{
                des.patient = self.patient
            }
        }else if segue.identifier == "profilePic"{
            if let des = segue.destination as? ViewProfilePicViewController{
                des.image = self.img_profile.image!
            }
        }else if segue.identifier == "annotate"{
            if let des = segue.destination as? DrawPresetViewController{
                des.imagePreset = self.preset
                self.preset = UIImage()
            }
        }else if segue.identifier == "edit_annotate"{
            if let des = segue.destination as? DrawPresetViewController{
                self.navigationController?.isNavigationBarHidden = false
                self.vw_image_profile.isHidden = true
                des.imagePreset = self.img_profile_large.image
                des.isEdit = true
                des.picture_no = self.picture_no
                self.preset = UIImage()
            }
        }else if segue.identifier == "customForm"{
            if let des = segue.destination as? CustomFormViewController{
                des.isQuestionare = true
                des.patient = self.patient
                self.inImage = true
                if self.followUp.cusforms.count > 0{
                    des.isUpdate = true
                }
                des.fudocid = self.followUp.id
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
