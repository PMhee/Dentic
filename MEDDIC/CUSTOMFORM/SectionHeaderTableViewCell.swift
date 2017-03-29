//
//  SectionHeaderTableViewCell.swift
//  MEDDIC
//
//  Created by Tanakorn on 1/24/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import UIKit

class SectionHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var btn_calculator: UIButton!
    @IBOutlet weak var btn_eye: UIButton!
    @IBOutlet weak var lb_category: UILabel!
    @IBOutlet weak var lb_title: UILabel!
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
