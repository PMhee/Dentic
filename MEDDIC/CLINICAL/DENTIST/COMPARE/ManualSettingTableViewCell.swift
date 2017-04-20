//
//  ManualSettingTableViewCell.swift
//  Dentic
//
//  Created by Tanakorn on 4/18/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import UIKit

class ManualSettingTableViewCell: UITableViewCell {
    var manualSetting = 0
    @IBOutlet weak var sgFace: UISegmentedControl!
    @IBOutlet weak var sgDegree: UISegmentedControl!
    @IBOutlet weak var sgSmile: UISegmentedControl!
    
    @IBAction func sg_face_action(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            self.manualSetting -= 4
        }else{
            self.manualSetting += 4
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "selectManual"), object: self, userInfo: ["index":self.manualSetting]
        )
    }
    @IBAction func sg_degree_action(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            self.manualSetting -= 2
        }else{
            self.manualSetting += 2
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "selectManual"), object: self, userInfo: ["index":self.manualSetting]
        )
    }
    @IBAction func sg_smile_action(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            self.manualSetting -= 1
        }else{
            self.manualSetting += 1
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "selectManual"), object: self, userInfo: ["index":self.manualSetting])
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
