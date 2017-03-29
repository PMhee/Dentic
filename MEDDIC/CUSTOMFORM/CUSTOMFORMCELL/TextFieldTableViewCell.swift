//
//  TextFieldTableViewCell.swift
//  MEDDIC
//
//  Created by Tanakorn on 2/4/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import UIKit
import RealmSwift
class TextFieldTableViewCell: UITableViewCell,UITextFieldDelegate {
    var idx = 0
    var sectionindex = 0
    var answer = CustomFormAnswer()
    @IBOutlet weak var lb_answer: UILabel!
    @IBOutlet weak var tf_answer: UITextField!
    @IBOutlet weak var lb_question: UILabel!
    @IBOutlet weak var img_star: UIImageView!
    @IBOutlet weak var lb_number: UILabel!
    @IBOutlet weak var vw_number: UIView!
    @IBOutlet weak var vw_layout: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setDelegate(){
        self.tf_answer.delegate = self
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "isTyping"), object: nil,userInfo:["isTyping":false,"textfield":textField])
        try! Realm().write{
            if textField.text! != ""{
                self.answer.requiredChecked = true
            }else{
                self.answer.requiredChecked = false
            }
            self.answer.answer = textField.text!
        }
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "isTyping"), object: nil,userInfo:["isTyping":true,"textfield":textField])
    }
    @IBAction func tf_answer_change(_ sender: UITextField) {
        if sender.text == ""{
            self.lb_answer.isHidden = true
        }else{
            self.lb_answer.isHidden = false
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
