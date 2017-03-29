//
//  MoreTableViewCell.swift
//  MEDDIC
//
//  Created by Tanakorn on 2/5/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import UIKit
import RealmSwift
class MoreTableViewCell: UITableViewCell {
    let phys = try! Realm().objects(RealmPhysician.self).first
    @IBAction func switch_change(_ sender: UISwitch) {
        if sender.isOn{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "checkPasscode"), object: nil,userInfo:nil)
        }else{
            try! Realm().write{
            self.phys?.passcode = ""
            }
        }
    }
    @IBOutlet weak var `switch`: UISwitch!
    @IBOutlet weak var lb_more: UILabel!
    @IBOutlet weak var img_icon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
