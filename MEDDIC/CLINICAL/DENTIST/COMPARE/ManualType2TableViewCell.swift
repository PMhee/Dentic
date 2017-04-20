//
//  ManualType2TableViewCell.swift
//  Dentic
//
//  Created by Tanakorn on 4/18/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import UIKit

class ManualType2TableViewCell: UITableViewCell {

    var typeState2 = 0
    @IBOutlet weak var sg_manual: UISegmentedControl!
    @IBAction func sg_manual_action(_ sender: UISegmentedControl) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "selectType2"), object: self, userInfo: ["index":sender.selectedSegmentIndex])
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
