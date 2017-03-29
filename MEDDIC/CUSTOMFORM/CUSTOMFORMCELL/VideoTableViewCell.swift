//
//  VideoTableViewCell.swift
//  MEDDIC
//
//  Created by Tanakorn on 2/5/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import UIKit
import RealmSwift
class VideoTableViewCell: UITableViewCell,UITextFieldDelegate {
    var api = APIAddCustomForm()
    var back = BackSystem()
    var helper = Helper()
    var uiTable = UITable()
    var tableView = UITableView()
    var answer = CustomFormAnswer()
    @IBOutlet weak var lb_answer: UILabel!
    @IBOutlet weak var img_play: UIImageView!
    @IBOutlet weak var cons_height: NSLayoutConstraint!
    @IBOutlet weak var lb_channel_name: UILabel!
    @IBOutlet weak var lb_video_name: UILabel!
    @IBOutlet weak var img_video: UIImageView!
    @IBOutlet weak var vw_video: UIView!
    @IBOutlet weak var tf_answer: UITextField!
    @IBOutlet weak var lb_question: UILabel!
    @IBOutlet weak var img_star: UIImageView!
    @IBOutlet weak var lb_number: UILabel!
    @IBOutlet weak var vw_number: UIView!
    @IBOutlet weak var vw_layout: UIView!
    @IBOutlet weak var btn_play: UIButton!
    
    @IBAction func btn_play_action(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showVideo"), object: nil,userInfo:["link":self.tf_answer.text!])
    }
    @IBAction func tf_end(_ sender: UITextField) {
        self.downloadYoutube()
    }
    func downloadYoutube(){
        self.api.getYoutubeMeta(sessionid: self.back.getSessionid(), videoid: self.tf_answer.text!, success: {(success) in
            self.uiTable.shadow(vw_layout: self.vw_video)
            self.img_video.isHidden = false
            if let title = success.value(forKey: "title") as? String{
                self.lb_video_name.text = title
            }
            if let thumbnail_url = success.value(forKey: "thumbnail_url") as? String{
                self.helper.downloadImageFrom(link: thumbnail_url, contentMode: .scaleAspectFill, img: self.img_video)
            }
            if let author_name = success.value(forKey: "author_name") as? String{
                self.lb_channel_name.text = author_name
            }
            try! Realm().write {
                self.answer.answer = self.tf_answer.text!
                self.answer.requiredChecked = true
            }
            
            self.btn_play.isUserInteractionEnabled = true
            self.cons_height.constant = 139
            self.img_play.isHidden = false
            self.tableView.reloadData()
        }, failure: {(error) in
            try! Realm().write {
                self.answer.requiredChecked = false
            }
            self.btn_play.isUserInteractionEnabled = false
            self.img_play.isHidden = true
        })
    }
    @IBAction func tf_change(_ sender: UITextField) {
        
    }
    func setDelegate(){
        //self.cons_height.constant = 0
        self.tf_answer.delegate = self
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
