//
//  SectionTitleTableViewCell.swift
//  MEDDIC
//
//  Created by Tanakorn on 2/4/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import UIKit

class SectionTitleTableViewCell: UITableViewCell {

    @IBOutlet weak var lb_sectiondescription: UILabel!
    @IBOutlet weak var lb_description: UILabel!
    @IBOutlet weak var lb_sectionname: UILabel!
    @IBOutlet weak var lb_title: UILabel!
    @IBOutlet weak var img_icon: UIImageView!
    @IBOutlet weak var btn_vw_profile: UIButton!
    @IBOutlet weak var vw_top: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
