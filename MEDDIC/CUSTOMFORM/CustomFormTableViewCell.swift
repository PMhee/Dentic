//
//  CustomFormTableViewCell.swift
//  MEDDIC
//
//  Created by Tanakorn on 1/22/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import UIKit

class CustomFormTableViewCell: UITableViewCell {

    @IBOutlet weak var img_star_5: UIImageView!
    @IBOutlet weak var img_star_4: UIImageView!
    @IBOutlet weak var img_star_3: UIImageView!
    @IBOutlet weak var img_star_2: UIImageView!
    @IBOutlet weak var img_star_1: UIImageView!
    @IBOutlet weak var lb_category: UILabel!
    @IBOutlet weak var lb_name: UILabel!
    @IBOutlet weak var lb_no: UILabel!
    @IBOutlet weak var vw_icon: UIView!
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
