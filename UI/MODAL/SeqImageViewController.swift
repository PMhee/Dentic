//
//  SeqImageViewController.swift
//  Dentic
//
//  Created by Tanakorn on 4/29/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import UIKit

class SeqImageViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    var sequent = ["Facial-Front","Facial-Front-Smile","Facial-Left 45º","Facial-Left-Smile 45º","Facial-Left 90º","Facial-Left-Smile 90º"]
    var external_oral_image = [DentistClinicalViewController.Image()]
    @IBOutlet weak var lb_show: UILabel!
    var index = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.openCamera()
        // Do any additional setup after loading the view.
    }
    @IBAction func btn_cancel_action(_ sender: UIButton) {
        self.dismiss(animated: true, completion: {(_) in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue:"SequentPic"), object: nil, userInfo: ["pic":self.external_oral_image])
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func openCamera(){
        self.lb_show.text = self.sequent[index]
        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when) {
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                var imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.camera
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
        self.index += 1
        if self.index == self.sequent.count{
            self.lb_show.text = ""
            self.dismiss(animated: true, completion: {(_) in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue:"SequentPic"), object: nil, userInfo: ["pic":self.external_oral_image])
            })
        }else{
            self.openCamera()
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var img = DentistClinicalViewController.Image()
        let im = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.external_oral_image[self.index].isSet = true
        self.external_oral_image[self.index].img = im
        self.dismiss(animated: true, completion: nil)
        self.index += 1
        if self.index == self.sequent.count{
            self.lb_show.text = ""
            self.dismiss(animated: true, completion: {(_) in
                NotificationCenter.default.post(name: NSNotification.Name(rawValue:"SequentPic"), object: nil, userInfo: ["pic":self.external_oral_image])
            })

        }else{
            self.openCamera()
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
