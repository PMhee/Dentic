//
//  CheckBoxCheckTableViewCell.swift
//  MEDDIC
//
//  Created by Tanakorn on 2/4/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import UIKit

class CheckBoxCheckTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var btn_check: UIButton!
    @IBOutlet weak var lb_question: UILabel!
    @IBOutlet weak var img_tick: UIImageView!

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
