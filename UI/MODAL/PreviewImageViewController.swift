//
//  PreviewImageViewController.swift
//  Dentic
//
//  Created by Tanakorn on 5/4/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import UIKit
import RealmSwift
class PreviewImageViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate {
    
    @IBOutlet weak var lb_date: UILabel!
    @IBOutlet weak var img_show: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var collectionView: UICollectionView!
    var picID = ""
    var isEdit = false
    var customPic = [CompareViewController.Image()]
    var didCancel = false
    var isCustom = false
    let sectionInsets = UIEdgeInsets(top: 1, left:1, bottom: 1, right: 1)
    var compareType = 0
    var compareFollowUp = [RealmFollowup]()
    var helper = Helper()
    var manualState = 0
    var previewImg = [UIImage?]()
    var doctor = try! Realm().objects(RealmPhysician.self).first
    var row = 0
    var column = 0
    var patient = RealmPatient()
    var isAnnotate = false
    @IBOutlet weak var lb_patient_name: UILabel!
    @IBOutlet weak var lb_dentic: UILabel!
    @IBOutlet weak var cons_collectionView_height: NSLayoutConstraint!
    @IBAction func btn_back_action(_ sender: UIButton) {
        self.dismiss(animated: true, completion: {})
    }
    
    @IBAction func btn_save_action(_ sender: UIButton) {
        var id = self.helper.generateID()
        self.helper.saveLocalProfilePicFromImage(image: self.img_show.image!, id:id)
        try! Realm().write {
            var pic = Picture()
            pic.id = id
            self.patient.comparePic.append(pic)
        }
        let alertController = UIAlertController(title: "Success", message: "Your Comparison was saved", preferredStyle: UIAlertControllerStyle.alert)
        let noAction = UIAlertAction(title: "Done", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            self.navigationController?.popViewController(animated: true)
        }
        alertController.addAction(noAction)
        self.present(alertController, animated: true, completion: nil)
    }
    @IBAction func btn_annotation_action(_ sender: UIButton) {
        self.performSegue(withIdentifier: "annotate", sender: self)
    }
    
    @IBAction func btn_text_input_action(_ sender: UIButton) {
        self.img_show.isHidden = true
        self.collectionView.isHidden = false
        self.lb_patient_name.isHidden = false
        self.lb_dentic.isHidden = false
        self.lb_name.isHidden = false
        self.presentAlert()
    }
    @IBAction func btn_upload_action(_ sender: UIButton) {
        var image = [UIImage]()
        image.append(self.img_show.image!)
        let activityViewController = UIActivityViewController(activityItems: image, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBOutlet weak var lb_name: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lb_patient_name.text = self.patient.name
        NotificationCenter.default.addObserver(self, selector: #selector(didAnnotateDent), name: NSNotification.Name(rawValue: "didAnnotateDent"), object: nil)
        // Do any additional setup after loading the view.
    }
    func didAnnotateDent(notification:Notification){
        self.img_show.image = notification.userInfo?["pic"] as! UIImage
        self.isAnnotate = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.isEdit{
            self.collectionView.isHidden = true
            self.lb_name.isHidden = true
            self.lb_patient_name.isHidden = true
            self.lb_dentic.isHidden = true
            self.lb_date.isHidden = true
            self.helper.loadLocalProfilePic(id: self.picID, image: self.img_show)
            self.img_show.isHidden = false
            UIApplication.shared.setStatusBarHidden(true, with: .fade)
            self.navigationController?.isNavigationBarHidden = true
        }else{
            self.lb_name.text = self.doctor?.name
            self.lb_date.text = self.helper.dateToString(date: Date())
            print(self.helper.dateToString(date: Date()))
            UIApplication.shared.setStatusBarHidden(true, with: .fade)
            self.navigationController?.isNavigationBarHidden = true
            self.collectionView.isHidden = false
            self.lb_name.isHidden = false
            self.lb_dentic.isHidden = false
            self.lb_date.isHidden = false
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //self.presentAlert()
        if self.isEdit{
            
        }else{
        self.initImage()
        }
        // present the view controller
    }
    func presentAlert() {
        let alertController = UIAlertController(title: "Patient name?", message: "Please input your patient name", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (_) in
            if let field = alertController.textFields?[0] {
                // store your data
                self.lb_patient_name.text = field.text!
                self.initImage()
                self.didCancel = true
            } else {
                // user did not fill field
                self.initImage()
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            self.didCancel = true
            self.initImage()
        }
        alertController.addTextField { (textField) in
            textField.text = self.patient.name
            if textField.text! == ""{
                textField.placeholder = "Patient name"
            }
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    func initImage(){
        if !self.didCancel{
            self.lb_patient_name.text = self.lb_patient_name.text!+" "+self.patient.HN
        }
        self.collectionView.layoutIfNeeded()
        self.cons_collectionView_height.constant = self.collectionView.contentSize.height
        var image = [UIImage]()
        if !self.isAnnotate{
            self.img_show.image = self.generateImage(view: self.collectionView)
            image.append(self.generateImage(view: self.collectionView))
            self.img_show.image = self.generateImage(view: self.collectionView)
        }
        //        let activityViewController = UIActivityViewController(activityItems: image, applicationActivities: nil)
        //        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        //        // exclude some activity types from the list (optional)
        //        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        //        self.present(activityViewController, animated: true, completion: nil)
        self.collectionView.isHidden = true
        self.lb_dentic.isHidden = true
        self.lb_name.isHidden = true
        self.lb_patient_name.isHidden = true
        self.lb_date.isHidden = true
        self.img_show.isHidden = false
    }
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        if scrollView.tag == 2{
            return scrollView.viewWithTag(1)
        }else{
            return nil
        }
    }
    func generateImage(view:UIView) ->UIImage{
        var image = UIImage()
        if #available(iOS 10.0, *) {
            self.collectionView.layoutIfNeeded()
            let renderer = UIGraphicsImageRenderer(size: CGSize(width: self.collectionView.bounds.width, height: self.collectionView.bounds.height+50))
            image = renderer.image { ctx in
                view.drawHierarchy(in: collectionView.bounds, afterScreenUpdates: true)
                self.lb_name.drawHierarchy(in: CGRect.init(x: (collectionView.frame.width-self.lb_name.frame.width)/2, y:collectionView.frame.height/2, width: self.lb_name.frame.width, height: self.lb_name.frame.height), afterScreenUpdates: true)
                self.lb_date.drawHierarchy(in: CGRect.init(x: (collectionView.frame.width-self.lb_date.frame.width)-10, y:(collectionView.frame.height)+25, width: self.lb_date.frame.width, height: self.lb_date.frame.height), afterScreenUpdates: true)
                self.lb_patient_name.drawHierarchy(in: CGRect.init(x: (collectionView.frame.width-self.lb_patient_name.frame.width)-10, y:collectionView.frame.height+5, width: self.lb_patient_name.frame.width, height: self.lb_patient_name.frame.height), afterScreenUpdates: true)
                self.lb_dentic.drawHierarchy(in: CGRect.init(x: (collectionView.frame.width-self.lb_dentic.frame.width)/2, y:collectionView.frame.height/2-40, width: self.lb_dentic.frame.width, height: self.lb_dentic.frame.height), afterScreenUpdates: true)
                
                
            }
        } else {
            let alertController = UIAlertController(title: "Error!", message: "Please update your ios version to 10.0 or higher", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            }
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
            // Fallback on earlier versions
        }
        return image
        //        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, true, 0)
        //        for row in 4..<tblview.numberOfRows(inSection: 0) {
        //            let indexPath = IndexPath.init(row: row, section: 0)
        //            let cell = tableView.cellForRow(at: indexPath)!
        //            let height = cell.frame.height
        //            print("row:\(indexPath.row), frame:\(cell.frame) height:\(height)")
        //            cell.contentView.drawHierarchy(in: cell.frame, afterScreenUpdates: true)
        //        }
        //        let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        //        UIGraphicsEndImageContext()
        //        return image
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.isCustom{
            return self.customPic.count
        }else{
            if self.compareType == 0{
                return self.compareFollowUp.count
            }else if self.compareType == 1 || self.compareType == 5{
                return self.compareFollowUp.count*2
            }else if self.compareType == 2 || self.compareType == 6{
                return self.compareFollowUp.count*3
            }else if self.compareType == 3{
                return self.compareFollowUp.count*4
            }else{
                return self.compareFollowUp.count*5
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let img = cell.viewWithTag(1) as! UIImageView
        if self.isCustom{
            img.image = self.customPic[indexPath.row].img
        }else{
            if let image = self.previewImg[indexPath.row] as? UIImage{
                img.image = image
            }
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if self.isCustom{
            let paddingSpace = sectionInsets.left * (CGFloat(self.column) + 1)
            let availableWidth = self.view.frame.width - paddingSpace
            var widthPerItem = 0
            widthPerItem = Int(availableWidth / CGFloat(self.column))
            return CGSize(width: widthPerItem, height: widthPerItem)
        }else{
            var size = 0
            if self.compareType == 0{
                size = 1
            }else if self.compareType == 1 || self.compareType == 5{
                size = 2
            }else if self.compareType == 2 || self.compareType == 6{
                size = 3
            }else if self.compareType == 3{
                size = 4
            }else{
                size = 5
            }
            let paddingSpace = sectionInsets.left * (CGFloat(size-1) + 1)
            let availableWidth = self.view.frame.width - paddingSpace
            var widthPerItem = 0
            widthPerItem = Int(availableWidth / CGFloat(size))
            if self.compareType == 0 {
                return CGSize(width: (self.view.frame.width) - paddingSpace, height: (self.view.frame.height/2) - paddingSpace)
            }else{
                return CGSize(width: widthPerItem, height: widthPerItem)
            }
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
        if segue.identifier == "annotate"{
            if let des = segue.destination as? DrawPresetViewController{
                des.isExport = true
                des.imagePreset = self.img_show.image
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
