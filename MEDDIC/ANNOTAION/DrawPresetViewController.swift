//
//  DrawPresetViewController.swift
//  Simplified Medical Record
//
//  Created by Tanakorn on 6/7/2559 BE.
//  Copyright © 2559 Chulalongkorn University. All rights reserved.
//

import UIKit
import Realm
class DrawPresetViewController: UIViewController,UIGestureRecognizerDelegate,UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate{
    @IBOutlet weak var img_preset: UIImageView!
    //Dentist
    var imgPresetSticker = [UIImage]()
    var isDentist = false
    var Dentstate = 0
    var Dentindex = 0
    var isExport = false
    var inFocusImage = 0
    var inExpand = false
    @IBOutlet weak var tf_input_text: UITextField!
    //
    var patientID = NSString()
    var swiped = false
    var lastPoint = CGPoint.zero
    var lineWidth : CGFloat = 1.0
    var rub = false
    var ruler = Ruler()
    var tagArray = [Int]()
    var continue_image : UIImage!
    var settingImage : String! = "white.png"
    var enable_adjust = false
    var enable_tool = false
    var imageID : String!
    var fuID : String!
    var drawPic = false
    var a,b :CGFloat!
    var color = Color()
    var all_color = [Int]()
    var picture_no : Int = 0
    var currentColor = 0x1D1D1D
    var currentTool = 0
    var tools = [Tool]()
    var isEdit = false
    struct Tool {
        var type : String = ""
        var width : CGFloat = 0
        var color : Int = 0
        var icon : String = ""
        var alpha : Double = 0.0
        var lineCap : String = ""
    }
    var begin_x : CGFloat = 0.0
    var start_x : CGFloat = 0.0
    var begin_y : CGFloat = 0.0
    var start_y : CGFloat = 0.0
    var stickerImage = [UIView]()
    var stickerButton = [UIButton]()
    var expandBut = [UIButton]()
    var stickerExpandImage = [UIImageView]()
    var stickerRemoveButton = [UIButton]()
    var imagePreset : UIImage!
    var helper = Helper()
    var state = [CGContext]()
    var inSticker = false
    var exactHeight :CGFloat = 0
    @IBOutlet weak var cons_height_img_preset: NSLayoutConstraint!
    @IBOutlet weak var cons_width_img_preset: NSLayoutConstraint!
    @IBOutlet weak var cons_height_img_temp: NSLayoutConstraint!
    @IBOutlet weak var cons_width_img_temp: NSLayoutConstraint!
    @IBOutlet weak var cons_width_img_marker: NSLayoutConstraint!
    @IBOutlet weak var cons_height_img_marker: NSLayoutConstraint!
    
    @IBOutlet weak var img_tool: UIImageView!
    @IBOutlet var pan_gesture: UIPanGestureRecognizer!
    @IBOutlet weak var vw_camera: UIView!
    @IBOutlet var tap_gesture: UITapGestureRecognizer!
    @IBOutlet weak var vw_show_color: UIView!
    @IBOutlet weak var img_temp: UIImageView!
    @IBOutlet weak var img_marker: UIImageView!
    @IBOutlet weak var vw_filter: UIView!
    @IBOutlet weak var vw_tool: UIView!
    
    @IBAction func tf_input_text_change(_ sender: UITextField) {
        if let lb = self.stickerImage[self.inFocusImage-1] as? UILabel{
            lb.text = sender.text!
        }
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let lb = self.stickerImage[self.inFocusImage-1] as? UILabel{
            if lb.text != nil{
            textField.text = lb.text!
            }
        }
    }
    @IBAction func btn_gallery_action(_ sender: UIButton) {
        self.vw_camera.isHidden = true
        self.vw_filter.isHidden = true
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            var imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    @IBAction func btn_sticker_action(_ sender: UIButton) {
        self.vw_camera.isHidden = true
        self.view.bringSubview(toFront: self.vw_sticker)
        self.vw_sticker.isHidden = false
    }
    @IBAction func btn_cam_action(_ sender: UIButton) {
        self.vw_camera.isHidden = true
        self.vw_filter.isHidden = true
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            var imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    @IBAction func btn_text_action(_ sender: UIButton) {
        let tf_label = UILabel()
        tf_label.frame = CGRect(x: (self.view.frame.width/2)-100, y: (self.view.frame.height/2)-25, width: 200, height:35)
        tf_label.textColor = UIColor.white
        tf_label.layer.cornerRadius = 3
        tf_label.addDashedBorder(strokeColor: UIColor(netHex:0xE85153), lineWidth: 0.5)
        tf_label.tag = self.stickerImage.count+1
        tf_label.numberOfLines = 0
        let btn = UIButton()
        btn.tag = self.stickerImage.count+1
        btn.frame = tf_label.frame
        btn.addTarget(self, action: #selector(didTouchImage), for: .touchUpInside)
        let btn_expand = UIButton()
        btn_expand.frame = CGRect(x: tf_label.frame.origin.x + tf_label.frame.width - 10, y: tf_label.frame.origin.y + tf_label.frame.height - 10, width: 20, height: 20)
        btn_expand.backgroundColor = UIColor(netHex:0xE85153)
        btn_expand.layer.cornerRadius = 10
        btn_expand.layer.masksToBounds = true
        btn_expand.tag = self.stickerImage.count+1
        let img_expand = UIImageView()
        img_expand.frame = CGRect(x: tf_label.frame.origin.x + tf_label.frame.width - 6, y: tf_label.frame.origin.y + tf_label.frame.height - 6, width: 12, height: 12)
        img_expand.image = UIImage(named:"expand.png")
        let btn_remove = UIButton()
        btn_remove.frame = CGRect(x: tf_label.frame.origin.x-10, y: tf_label.frame.origin.y-10, width: 20, height: 20)
        btn_remove.backgroundColor = UIColor(netHex:0xE85153)
        btn_remove.layer.cornerRadius = 10
        btn_remove.layer.masksToBounds = true
        btn_remove.setTitle("×", for: .normal)
        btn_remove.addTarget(self, action: #selector(didRemoveImage), for: .touchUpInside)
        btn_remove.tag = self.stickerImage.count+1
        //tf_label.becomeFirstResponder()
        self.view.addSubview(tf_label)
        self.view.addSubview(btn)
        self.view.addSubview(btn_expand)
        self.view.addSubview(img_expand)
        self.view.addSubview(btn_remove)
        self.stickerButton.append(btn)
        self.stickerImage.append(tf_label)
        self.expandBut.append(btn_expand)
        self.stickerExpandImage.append(img_expand)
        self.stickerRemoveButton.append(btn_remove)
        self.inFocusImage = btn.tag
        self.vw_filter.isHidden = true
        self.vw_camera.isHidden = true
        self.view.addGestureRecognizer(self.pan_gesture)
    }
    @IBOutlet weak var vw_sticker: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    //    @IBOutlet weak var tick_yellow: UIImageView!
    //    @IBOutlet weak var tick_black: UIImageView!
    //    @IBOutlet weak var tick_green: UIImageView!
    //    @IBOutlet weak var tick_blue: UIImageView!
    //    @IBOutlet weak var tick_red: UIImageView!
    //    @IBOutlet weak var tick_pink: UIImageView!
    func setLWidth(_ width:CGFloat){
        self.lineWidth = width
        ///self.line_size.text = String(Int(width))+" px"
    }
    
    @IBAction func btn_add_pic_action(_ sender: UIButton) {
        self.view.bringSubview(toFront: self.vw_camera)
        self.vw_camera.isHidden = false
        self.vw_filter.isHidden = false
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        self.img_preset.image = image
        self.dismiss(animated: true, completion: nil);
    }
    @IBAction func btn_tool_action(_ sender: UIButton) {
        self.view.bringSubview(toFront: self.vw_filter)
        self.view.bringSubview(toFront: self.vw_tool)
        self.vw_tool.isHidden = false
        self.vw_filter.isHidden = false
    }
    func aspectScaledImageSizeForImageView(iv:UIImageView,im:UIImage){
        
        var x,y :CGFloat!
        x = iv.frame.size.width
        y = iv.frame.size.height
        a = im.size.width
        b = im.size.height
        
        if ( x == a && y == b ) {           // image fits exactly, no scaling required
            // return iv.frame.size;
        }
        else if ( x > a && y > b ) {         // image fits completely within the imageview frame
            if ( x-a > y-b ) {              // image height is limiting factor, scale by height
                a = y/b * a
                b = y
            } else {
                b = x/a * b               // image width is limiting factor, scale by width
                a = x
            }
        }
        else if ( x < a && y < b ) {        // image is wider and taller than image view
            if !( a - x > b - y ) {          // height is limiting factor, scale by height
                a = y/b * a
                b = y
            }
            else {                        // width is limiting factor, scale by width
                b = x/a * b
                a = x
            }
        }
        else if ( x < a && y > b ) {        // image is wider than view, scale by width
            b = x/a * b
            a = x
        }
        else if ( x > a && y < b ) {        // image is taller than view, scale by height
            a = y/b * a
            b = y
        }
    }
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    struct Ruler {
        var enable : Bool!
        var begin : Bool!
        var end : Bool!
        var beginX : CGPoint!
        var endX : CGPoint!
    }
    @IBAction func btn_camera_action(_ sender: UIButton) {
        self.vw_camera.isHidden = false
        self.vw_filter.isHidden = false
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.img_preset.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
    var x : CGFloat!
    var y : CGFloat!
    
    func reset_all(_ sender: UIButton) {
        self.img_temp.image = nil
        if tagArray.count > 0 {
            for i in 0...tagArray.count-1 {
                if let tag = self.img_temp.viewWithTag(tagArray[i]) as? UILabel {
                    tag.removeFromSuperview()
                }
            }
        }
    }
    @IBAction func btn_back_action(_ sender: UIButton) {
        self.performSegue(withIdentifier: "back", sender: self)
    }
    func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.exactHeight = self.img_preset.frame.height
        self.genTool()
        self.addPresetImage()
        self.ruler = Ruler(enable: false, begin: false, end: false, beginX: CGPoint(x: 0,y:0), endX: CGPoint(x: 0,y:0))
        tap_gesture.delegate = self
        self.view.addGestureRecognizer(tap_gesture)
        self.pan_gesture = UIPanGestureRecognizer(target: self, action:#selector(handlePanGesture))
        //self.view.addGestureRecognizer(panGesture)
        self.setUI()
        self.tf_input_text.delegate = self
        if self.imagePreset != nil{
            self.img_preset.image = self.imagePreset
        }
        //        //up after loading the view.
    }
    func handlePanGesture(panGestureRecognizer : UIPanGestureRecognizer!){
        switch panGestureRecognizer.state {
        case .began:
            self.begin_x = panGestureRecognizer.location(in: self.view).x
            self.begin_y = panGestureRecognizer.location(in: self.view).y
        case .changed:
            if self.inFocusImage != 0 {
                if self.inExpand{
                    if let tf = stickerImage[self.inFocusImage-1] as? UILabel{
                        tf.resignFirstResponder()
                        self.expandBut[self.inFocusImage-1].isHidden = true
                        self.stickerExpandImage[self.inFocusImage-1].isHidden = true
                        self.stickerRemoveButton[self.inFocusImage-1].isHidden = true
                        self.stickerImage[self.inFocusImage-1].frame = CGRect(x:self.stickerImage[self.inFocusImage-1].frame.origin.x , y: self.stickerImage[self.inFocusImage-1].frame.origin.y, width: self.stickerImage[self.inFocusImage-1].frame.width + (panGestureRecognizer.location(in: self.view).x-self.begin_x), height: self.stickerImage[self.inFocusImage-1].frame.height + (panGestureRecognizer.location(in: self.view).y-self.begin_y))
                        self.begin_y = panGestureRecognizer.location(in: self.view).y
                        self.begin_x = panGestureRecognizer.location(in: self.view).x
                        self.stickerImage[self.inFocusImage-1].layer.sublayers?.removeAll()
                        self.stickerImage[self.inFocusImage-1].addDashedBorder(strokeColor: UIColor(netHex:0xE85153), lineWidth: 0.5)
                    }else{
                    self.stickerImage[self.inFocusImage-1].frame = CGRect(x:self.stickerImage[self.inFocusImage-1].frame.origin.x , y: self.stickerImage[self.inFocusImage-1].frame.origin.y, width: self.stickerImage[self.inFocusImage-1].frame.height + (panGestureRecognizer.location(in: self.view).y-self.begin_y), height: self.stickerImage[self.inFocusImage-1].frame.height + (panGestureRecognizer.location(in: self.view).y-self.begin_y))
                    self.stickerImage[self.inFocusImage-1].layer.sublayers?.removeAll()
                    self.expandBut[self.inFocusImage-1].isHidden = true
                    self.stickerExpandImage[self.inFocusImage-1].isHidden = true
                    self.begin_y = panGestureRecognizer.location(in: self.view).y
                    self.stickerRemoveButton[self.inFocusImage-1].isHidden = true
                    }
                }else{
                    if let tf = stickerImage[self.inFocusImage-1] as? UILabel{
                        self.stickerImage[self.inFocusImage-1].frame = CGRect(x:panGestureRecognizer.location(in: self.view).x-(self.stickerImage[self.inFocusImage-1].frame.width/2) , y: panGestureRecognizer.location(in: self.view).y-(self.stickerImage[self.inFocusImage-1].frame.height/2), width: self.stickerImage[self.inFocusImage-1].frame.width, height: self.stickerImage[self.inFocusImage-1].frame.height)
                        self.stickerButton[self.inFocusImage-1].frame = CGRect(x:panGestureRecognizer.location(in: self.view).x-(self.stickerImage[self.inFocusImage-1].frame.width/2) , y: panGestureRecognizer.location(in: self.view).y-(self.stickerImage[self.inFocusImage-1].frame.height/2), width: self.stickerImage[self.inFocusImage-1].frame.width, height: self.stickerImage[self.inFocusImage-1].frame.height)
                        self.stickerExpandImage[self.inFocusImage-1].frame = CGRect(x:panGestureRecognizer.location(in: self.view).x+((self.stickerImage[self.inFocusImage-1].frame.width/2)-6) , y: panGestureRecognizer.location(in: self.view).y+((self.stickerImage[self.inFocusImage-1].frame.height/2)-6), width: 12, height: 12)
                        self.expandBut[self.inFocusImage-1].frame = CGRect(x:panGestureRecognizer.location(in: self.view).x+((self.stickerImage[self.inFocusImage-1].frame.width/2)-10) , y: panGestureRecognizer.location(in: self.view).y+((self.stickerImage[self.inFocusImage-1].frame.height/2)-10), width: 20, height: 20)
                        self.stickerRemoveButton[self.inFocusImage-1].frame = CGRect(x:panGestureRecognizer.location(in: self.view).x-((self.stickerImage[self.inFocusImage-1].frame.width/2)+10) , y: panGestureRecognizer.location(in: self.view).y-((self.stickerImage[self.inFocusImage-1].frame.height/2)+6), width: 20, height: 20)
                    }else{
                    self.stickerImage[self.inFocusImage-1].frame = CGRect(x:panGestureRecognizer.location(in: self.view).x-(self.stickerImage[self.inFocusImage-1].frame.width/2) , y: panGestureRecognizer.location(in: self.view).y-(self.stickerImage[self.inFocusImage-1].frame.height/2), width: self.stickerImage[self.inFocusImage-1].frame.width, height: self.stickerImage[self.inFocusImage-1].frame.height)
                    self.stickerButton[self.inFocusImage-1].frame = CGRect(x:panGestureRecognizer.location(in: self.view).x-(self.stickerImage[self.inFocusImage-1].frame.width/2) , y: panGestureRecognizer.location(in: self.view).y-(self.stickerImage[self.inFocusImage-1].frame.height/2), width: self.stickerImage[self.inFocusImage-1].frame.width, height: self.stickerImage[self.inFocusImage-1].frame.height)
                    self.stickerExpandImage[self.inFocusImage-1].frame = CGRect(x:panGestureRecognizer.location(in: self.view).x+((self.stickerImage[self.inFocusImage-1].frame.width/2)-6) , y: panGestureRecognizer.location(in: self.view).y+((self.stickerImage[self.inFocusImage-1].frame.width/2)-6), width: 12, height: 12)
                    self.expandBut[self.inFocusImage-1].frame = CGRect(x:panGestureRecognizer.location(in: self.view).x+((self.stickerImage[self.inFocusImage-1].frame.width/2)-10) , y: panGestureRecognizer.location(in: self.view).y+((self.stickerImage[self.inFocusImage-1].frame.width/2)-10), width: 20, height: 20)
                    self.stickerRemoveButton[self.inFocusImage-1].frame = CGRect(x:panGestureRecognizer.location(in: self.view).x-((self.stickerImage[self.inFocusImage-1].frame.width/2)+10) , y: panGestureRecognizer.location(in: self.view).y-((self.stickerImage[self.inFocusImage-1].frame.width/2)+6), width: 20, height: 20)
                    }
                }
            }
        case .ended:
            if self.inExpand{
                self.inExpand = false
                self.stickerImage[self.inFocusImage-1].addDashedBorder(strokeColor: UIColor(netHex:0xE85153), lineWidth: 0.5)
                self.stickerButton[self.inFocusImage-1].frame = self.stickerImage[self.inFocusImage-1].frame
                self.expandBut[self.inFocusImage-1].frame = CGRect(x: self.stickerImage[self.inFocusImage-1].frame.origin.x + self.stickerImage[self.inFocusImage-1].frame.width - 10, y: self.stickerImage[self.inFocusImage-1].frame.origin.y + self.stickerImage[self.inFocusImage-1].frame.height - 10, width: 20, height: 20)
                self.stickerExpandImage[self.inFocusImage-1].frame = CGRect(x: self.stickerImage[self.inFocusImage-1].frame.origin.x + self.stickerImage[self.inFocusImage-1].frame.width - 6, y: self.stickerImage[self.inFocusImage-1].frame.origin.y + self.stickerImage[self.inFocusImage-1].frame.height - 6, width: 12, height: 12)
                self.stickerRemoveButton[self.inFocusImage-1].frame = CGRect(x: self.stickerImage[self.inFocusImage-1].frame.origin.x-10, y: self.stickerImage[self.inFocusImage-1].frame.origin.y-10, width: 20, height: 20)
                self.stickerRemoveButton[self.inFocusImage-1].isHidden = false
                self.stickerExpandImage[self.inFocusImage-1].isHidden = false
                self.expandBut[self.inFocusImage-1].isHidden = false
            }
            print("")
        default:
            print("")
        }
    }
    func addPresetImage(){
        for i in 1..<11{
            self.imgPresetSticker.append(UIImage(named:"img_annotate_"+String(i)+".png")!)
        }
        self.collectionView.reloadData()
    }
    func setUI(){
        let button: UIButton = UIButton()
        button.setImage(UIImage(named: "upload.png"), for: UIControlState.normal)
        button.addTarget(self, action: #selector(save), for: UIControlEvents.touchUpInside)
        button.frame = CGRect(x:self.view.frame.width-40, y:0, width:20, height:20)
        let barButton = UIBarButtonItem(customView: button)
        //assign button to navigationbar
        self.navigationItem.rightBarButtonItem = barButton
        UIApplication.shared.isStatusBarHidden = false
    }
    func save(sender:UIButton){
        if self.isExport{
            self.aspectScaledImageSizeForImageView(iv: self.img_preset, im: self.img_preset.image!)
            UIGraphicsBeginImageContextWithOptions(CGSize(width:a,height:b), view.isOpaque, 0.0)
            //img_background.image?.draw(in: CGRect(x: 0, y: 0, width: self.img_preset.frame.width, height: self.img_preset.frame.height), blendMode: .normal, alpha: 1)
            if img_preset.image != nil{
                img_preset.image?.draw(in: CGRect(x: 0, y: 0, width: a, height: b), blendMode: .normal, alpha: 1)
                // draw the image
            }else{
                img_preset.image?.draw(in: CGRect(x: 0, y: 0, width: a, height: b), blendMode: .normal, alpha: 1)
            }
            img_temp.image?.draw(in: CGRect(x: 0, y: 0, width: a, height: b), blendMode: .normal, alpha: 1)
            img_marker.image?.draw(in: CGRect(x: 0, y: 0, width: a, height: b), blendMode: .normal, alpha: 0.95)
            for i in 0..<self.stickerImage.count{
                if let pic = self.stickerImage[i] as? UIImageView{
                pic.image?.draw(in:CGRect(x: self.stickerImage[i].frame.origin.x, y:self.stickerImage[i].frame.origin.y-(self.img_preset.frame.height-b)/2-64, width: self.stickerImage[i].frame.width, height: self.stickerImage[i].frame.height), blendMode: .normal, alpha: 1 )
                }else{
                    if let lb = self.stickerImage[i] as? UILabel{
                        lb.drawHierarchy(in: CGRect(x: self.stickerImage[i].frame.origin.x, y:self.stickerImage[i].frame.origin.y-(self.img_preset.frame.height-b)/2-64, width: self.stickerImage[i].frame.width, height: self.stickerImage[i].frame.height), afterScreenUpdates: true)
                    }
                }
            }
            img_preset.image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            if let image = img_preset.image {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "didAnnotateDent"), object: nil,userInfo:["pic":image])
                self.navigationController?.popViewController(animated: true)
            }
        }else{
            self.aspectScaledImageSizeForImageView(iv: self.img_preset, im: self.img_preset.image!)
            UIGraphicsBeginImageContextWithOptions(CGSize(width:a,height:b), view.isOpaque, 0.0)
            //img_background.image?.draw(in: CGRect(x: 0, y: 0, width: self.img_preset.frame.width, height: self.img_preset.frame.height), blendMode: .normal, alpha: 1)
            if img_preset.image != nil{
                img_preset.image?.draw(in: CGRect(x: 0, y: 0, width: a, height: b), blendMode: .normal, alpha: 1)
                // draw the image
            }else{
                img_preset.image?.draw(in: CGRect(x: 0, y: 0, width: self.img_preset.frame.width, height: self.img_preset.frame.height), blendMode: .normal, alpha: 1)
            }
            img_temp.image?.draw(in: CGRect(x: 0, y: 0, width: a, height: b), blendMode: .normal, alpha: 1)
            img_marker.image?.draw(in: CGRect(x: 0, y: 0, width: a, height: b), blendMode: .normal, alpha: 0.95)
            img_preset.image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            if let image = img_preset.image {
                if self.isDentist{
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DentaddAnnotateImage"), object: nil,userInfo:["pic":image,"index":self.Dentindex,"state":self.Dentstate])
                    self.navigationController?.popViewController(animated: false)
                }else{
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "addAnnotateImage"), object: nil,userInfo:["pic":image,"isEdit":self.isEdit,"picture_no":self.picture_no])
                    self.navigationController?.popViewController(animated: false)
                    //                let filename = getDocumentsDirectory().appendingPathComponent("draw"+String(self.chatGroup.chat.count))
                    //                try? data.write(to: filename)
                }
                
            }
        }
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.all_color = self.color.listColor()
        self.vw_show_color.backgroundColor = UIColor(netHex: self.currentColor)
        self.vw_show_color.layer.cornerRadius = 15
        self.vw_show_color.layer.masksToBounds = true
        if self.img_preset.image != nil {
            self.aspectScaledImageSizeForImageView(iv: self.img_preset, im: self.img_preset.image!)
            self.cons_width_img_preset.constant = self.a
            self.cons_height_img_preset.constant = self.b
            self.cons_width_img_temp.constant = self.a
            self.cons_height_img_temp.constant = self.b
            self.cons_width_img_marker.constant = self.a
            self.cons_height_img_marker.constant = self.b
        }
        //self.tick_black.hidden = false
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.navigationController?.isNavigationBarHidden = false
        self.img_preset.clipsToBounds = true
        self.img_temp.clipsToBounds = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    func genTool(){
        self.tools = [Tool]()
        var pencil = Tool()
        pencil.type = "pencil"
        pencil.color = self.currentColor
        pencil.width = 0.5
        pencil.icon = "pencil.png"
        pencil.alpha = 0.8
        var pen = Tool()
        pen.type = "pen"
        pen.color = self.currentColor
        pen.width = 2
        pen.icon = "pen.png"
        pen.alpha = 1.0
        var marker = Tool()
        marker.type = "marker"
        marker.color = self.currentColor
        marker.width = 20
        marker.alpha = 0.95
        marker.icon = "marker.png"
        var eraser = Tool()
        eraser.type = "eraser"
        eraser.width = 10
        eraser.icon = "eraser.png"
        eraser.alpha = 1.0
        self.tools.append(pencil)
        self.tools.append(pen)
        self.tools.append(marker)
        self.tools.append(eraser)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //  let colorArray = ["black":UIColor(red:0/255,green: 0/255,blue: 0/255,alpha: 1.0),"green":UIColor(red:112/255,green:181/255,blue:69/255,alpha:1.0),"blue":UIColor(red:14/255,green:14/255,blue:84/255,alpha:1.0),"red":UIColor(red:168/255,green: 34/255,blue:27/255,alpha:1.0),"yellow":UIColor(red:231/255,green:158/255,blue:63/255,alpha:1.0),"pink":UIColor(red:232/255,green: 81/255,blue:83/255,alpha:1.0)]
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if !self.vw_tool.isHidden{
            
            if self.helper.inBound(x: touch.location(in: self.vw_tool).x, y: touch.location(in: self.vw_tool).y, view: self.vw_tool){
                return false
            }else{
                self.vw_tool.isHidden = true
                self.vw_filter.isHidden = true
                return true
            }
        }
        if !self.vw_camera.isHidden {
            if self.helper.inBound(x: touch.location(in: self.vw_camera).x, y: touch.location(in: self.vw_camera).y, view: self.vw_camera){
                return false
            }else{
                self.vw_camera.isHidden = true
                self.vw_filter.isHidden = true
                return true
            }
        }
        if !self.vw_sticker.isHidden{
            if self.helper.inBound(x: touch.location(in: self.vw_sticker).x, y: touch.location(in: self.vw_sticker).y, view: self.vw_sticker){
                return false
            }else{
                self.vw_sticker.isHidden = true
                self.vw_filter.isHidden = true
                return true
            }
        }
        if self.inFocusImage > 0 {
            if self.helper.inBound(x: touch.location(in:self.expandBut[self.inFocusImage-1]).x, y: touch.location(in: self.expandBut[self.inFocusImage-1]).y, view: self.expandBut[self.inFocusImage-1]){
                self.inExpand = true
                return false
            }
            if self.helper.inBound(x: touch.location(in: self.stickerImage[self.inFocusImage-1]).x, y: touch.location(in: self.stickerImage[self.inFocusImage-1]).y, view: self.stickerImage[self.inFocusImage-1]){
                return false
            }else{
                if self.helper.inBound(x: touch.location(in:self.expandBut[self.inFocusImage-1]).x, y: touch.location(in: self.expandBut[self.inFocusImage-1]).y, view: self.expandBut[self.inFocusImage-1]){
                    return false
                }else{
                    self.view.removeGestureRecognizer(self.pan_gesture)
                    self.inExpand = false
                    self.inFocusImage = 0
                    self.tf_input_text.resignFirstResponder()
                    for i in 0..<self.stickerImage.count{
                        self.stickerImage[i].layer.sublayers?.removeAll()
                    }
                    for i in 0..<self.expandBut.count{
                        self.expandBut[i].isHidden = true
                        self.stickerExpandImage[i].isHidden = true
                    }
                    for i in 0..<self.stickerRemoveButton.count{
                        self.stickerRemoveButton[i].isHidden = true
                    }
                    return true
                }
            }
        }
        return false
        //        if touch.location(in: self.view).y > self.view.frame.height - 100{
        //            return false
        //        }else{
        //            print("oooo")
        //            return true
        //
        //        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        swiped = false
        let touch = touches.first
        lastPoint = touch!.location(in: self.img_temp)
        if (ruler.enable)!{
            if !(ruler.begin)!{
                ruler.begin = !(ruler.begin)!
                ruler.beginX = touch!.location(in: self.img_temp)
            }else{
                ruler.begin = !(ruler.begin)!
                ruler.endX = touch!.location(in: self.img_temp)
                ruler.end = !(ruler.end)!
            }
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        swiped = true
        let touch = touches.first
        let currentPoint = touch!.location(in: self.img_temp)
        drawLineFrom(lastPoint, toPoint: currentPoint)
        lastPoint = currentPoint
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if !swiped {
            drawLineFrom(lastPoint, toPoint: lastPoint)
        }
        if (ruler.enable)!{
            if (ruler.end)!{
                drawLineFrom((ruler.beginX)!, toPoint: (ruler.endX)!)
                ruler.end = !(ruler.end)!
                let xDist = (ruler.endX.x)-(ruler.beginX.x)
                let yDist = (ruler.endX.y)-(ruler.beginX.y)
                let lb = UILabel(frame: CGRect(x: (ruler.beginX.x)+(xDist/2)-50,y: (ruler.beginX.y)+(yDist/2)-50,width: 100,height: 100))
                lb.text = String(format:"%.2f",sqrt((xDist*xDist)+(yDist*yDist)))+" cm"
                
                lb.font = UIFont(name: "Helvetica Neue", size: 15)
                lb.tag = tagArray.count+1
                tagArray.append(lb.tag)
                self.img_temp.addSubview(lb)
            }
        }
        // Merge tempImageView into mainImageView
        //                UIGraphicsBeginImageContext(img_preset.frame.size)
        //                img_ruler.image?.drawInRect(CGRect(x: 0, y: 0, width: self.img_preset.frame.width, height: self.img_preset.frame.height), blendMode: .Normal, alpha: 1)
        //                img_preset.image?.drawInRect(CGRect(x: 0, y: 0, width: self.img_preset.frame.width, height: self.img_preset.frame.height), blendMode: .Normal, alpha: 1)
        //img_temp.image?.drawInRect(CGRect(x: 0, y: 0, width: self.img_temp.frame.width, height: self.img_temp.frame.height), blendMode: .Normal, alpha: 0.65)
        //                img_preset.image = UIGraphicsGetImageFromCurrentImageContext()
        //                img_ruler.image = UIGraphicsGetImageFromCurrentImageContext()
        //                UIGraphicsEndImageContext()
        //img_temp.image = nil
    }
    func drawLineFrom(_ fromPoint: CGPoint, toPoint: CGPoint) {
        if self.tools[self.currentTool].type == "marker" {
            UIGraphicsBeginImageContext(self.img_marker.frame.size)
        }else{
            UIGraphicsBeginImageContext(self.img_temp.frame.size)
        }
        let context = UIGraphicsGetCurrentContext()
        if self.tools[self.currentTool].type == "marker" {
            img_marker.image?.draw(in: CGRect(x: 0, y: 0, width: self.img_marker.frame.width, height: self.img_marker.frame.height))
        }else{
            img_temp.image?.draw(in: CGRect(x: 0, y: 0, width: self.img_temp.frame.width, height: self.img_temp.frame.height))
        }
        context?.move(to: CGPoint(x: fromPoint.x, y: fromPoint.y))
        context?.addLine(to: CGPoint(x: toPoint.x, y: toPoint.y))
        context?.setLineCap(.round)
        context?.setLineWidth(self.tools[self.currentTool].width)
        context?.setAllowsAntialiasing(true)
        context?.setShouldAntialias(true)
        context?.setStrokeColor(UIColor(netHex: self.currentColor).cgColor)
        if self.tools[self.currentTool].type == "eraser" {
            context?.setBlendMode(.clear)
        }else{
            context?.setBlendMode(.normal)
        }
        context?.strokePath()
        if self.tools[self.currentTool].type == "marker" {
            img_marker.image = UIGraphicsGetImageFromCurrentImageContext()
            img_marker.alpha = 0.95
        }else{
            if self.tools[self.currentTool].type == "eraser"{
                img_marker.image = UIGraphicsGetImageFromCurrentImageContext()
                img_temp.image = UIGraphicsGetImageFromCurrentImageContext()
                img_temp.alpha = 1.0
            }else{
                img_temp.image = UIGraphicsGetImageFromCurrentImageContext()
                img_temp.alpha = 1.0
            }
        }
        UIGraphicsEndImageContext()
    }
    //Color
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 1{
            return self.tools.count
        }else if collectionView.tag == 2{
            return self.imgPresetSticker.count
        }else{
            return self.all_color.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 1{
            self.currentTool = indexPath.row
            self.img_tool.image = UIImage(named: self.tools[indexPath.row].icon)
            self.vw_tool.isHidden = true
            self.vw_filter.isHidden = true
        }else if collectionView.tag == 2{
            let imageView = UIImageView()
            imageView.image = self.imgPresetSticker[indexPath.row]
            imageView.frame = CGRect(x: self.view.frame.width/2, y: self.view.frame.height/2, width: 150, height: 150)
            imageView.addDashedBorder(strokeColor: UIColor(netHex:0xE85153), lineWidth: 0.5)
            let btn = UIButton()
            btn.tag = self.stickerImage.count+1
            btn.frame = imageView.frame
            btn.addTarget(self, action: #selector(didTouchImage), for: .touchUpInside)
            let btn_expand = UIButton()
            btn_expand.frame = CGRect(x: imageView.frame.origin.x + imageView.frame.width - 10, y: imageView.frame.origin.y + imageView.frame.height - 10, width: 20, height: 20)
            btn_expand.backgroundColor = UIColor(netHex:0xE85153)
            btn_expand.layer.cornerRadius = 10
            btn_expand.layer.masksToBounds = true
            btn_expand.tag = btn.tag
            let img_expand = UIImageView()
            img_expand.frame = CGRect(x: imageView.frame.origin.x + imageView.frame.width - 6, y: imageView.frame.origin.y + imageView.frame.height - 6, width: 12, height: 12)
            img_expand.image = UIImage(named:"expand.png")
            let btn_remove = UIButton()
            btn_remove.frame = CGRect(x: imageView.frame.origin.x-10, y: imageView.frame.origin.y-10, width: 20, height: 20)
            btn_remove.backgroundColor = UIColor(netHex:0xE85153)
            btn_remove.layer.cornerRadius = 10
            btn_remove.layer.masksToBounds = true
            btn_remove.setTitle("×", for: .normal)
            btn_remove.addTarget(self, action: #selector(didRemoveImage), for: .touchUpInside)
            btn_remove.tag = btn.tag
            self.view.addSubview(btn)
            self.view.addSubview(imageView)
            self.view.addSubview(btn_expand)
            self.view.addSubview(img_expand)
            self.view.addSubview(btn_remove)
            self.stickerButton.append(btn)
            self.stickerImage.append(imageView)
            self.expandBut.append(btn_expand)
            self.stickerExpandImage.append(img_expand)
            self.stickerRemoveButton.append(btn_remove)
            self.inFocusImage = btn.tag
            self.vw_filter.isHidden = true
            self.vw_sticker.isHidden = true
            self.view.addGestureRecognizer(self.pan_gesture)
        }else{
            self.currentColor = self.all_color[indexPath.row]
            self.vw_show_color.backgroundColor = UIColor(netHex: self.currentColor)
        }
    }
    func didRemoveImage(sender:UIButton){
        self.view.removeGestureRecognizer(self.pan_gesture)
        self.inFocusImage = 0
        self.inExpand = false
        self.stickerButton[sender.tag-1].removeFromSuperview()
        self.stickerImage[sender.tag-1].removeFromSuperview()
        self.expandBut[sender.tag-1].removeFromSuperview()
        self.stickerExpandImage[sender.tag-1].removeFromSuperview()
        self.stickerRemoveButton[sender.tag-1].removeFromSuperview()
        self.stickerButton.remove(at: sender.tag-1)
        self.stickerImage.remove(at: sender.tag-1)
        self.expandBut.remove(at: sender.tag-1)
        self.stickerExpandImage.remove(at: sender.tag-1)
        self.stickerRemoveButton.remove(at: sender.tag-1)
        for i in sender.tag-1..<self.stickerRemoveButton.count{
            self.stickerRemoveButton[i].tag -= 1
            self.stickerButton[i].tag -= 1
        }
    }
    func didTouchImage(sender:UIButton){
        self.inFocusImage = sender.tag
        self.inExpand = false
        self.view.addGestureRecognizer(self.pan_gesture)
        for i in 0..<self.stickerImage.count{
            if self.inFocusImage-1 != i{
                self.stickerImage[i].layer.sublayers?.removeAll()
                self.stickerExpandImage[i].isHidden = true
                self.expandBut[i].isHidden = true
                self.stickerRemoveButton[i].isHidden = true
            }else{
                self.stickerImage[i].addDashedBorder(strokeColor: UIColor(netHex:0xE85153), lineWidth: 0.5)
                self.stickerExpandImage[i].isHidden = false
                self.expandBut[i].isHidden = false
                self.stickerRemoveButton[i].isHidden = false
            }
        }
        if let lb = self.stickerImage[sender.tag-1] as? UILabel{
            self.tf_input_text.becomeFirstResponder()
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 1{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tool", for: indexPath)
            let icon = cell.viewWithTag(1) as! UIImageView
            icon.image = UIImage(named: self.tools[indexPath.row].icon)
            return cell
        }else if collectionView.tag == 2{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sticker", for: indexPath)
            let vw_bg = cell.viewWithTag(1)
            let img_sticker = cell.viewWithTag(2) as! UIImageView
            vw_bg?.layer.cornerRadius = 5
            vw_bg?.layer.masksToBounds = true
            img_sticker.image = self.imgPresetSticker[indexPath.row]
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
            let vw = cell.viewWithTag(1)
            vw?.layer.cornerRadius = 15
            vw?.layer.masksToBounds = true
            vw?.backgroundColor = UIColor(netHex: self.all_color[indexPath.row])
            return cell
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
