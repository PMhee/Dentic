//
//  RecentPatientTableViewCell.swift
//  MEDDIC
//
//  Created by Tanakorn on 1/17/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import UIKit

class RecentPatientTableViewCell: UITableViewCell {

    @IBOutlet weak var lb_group: UILabel!
    @IBOutlet weak var icon_group: UIImageView!
    @IBOutlet weak var lb_status: UILabel!
    @IBOutlet weak var vw_status: UIView!
    @IBOutlet weak var lb_meshtag: UILabel!
    @IBOutlet weak var lb_lastfudate: UILabel!
    @IBOutlet weak var lb_gender_age: UILabel!
    @IBOutlet weak var lb_HN: UILabel!
    @IBOutlet weak var lb_name: UILabel!
    @IBOutlet weak var img_profile: UIImageView!
    @IBOutlet weak var vw_layout: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
