//
//  MultipleCheckTableViewCell.swift
//  MEDDIC
//
//  Created by Tanakorn on 2/4/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import UIKit

class MultipleCheckTableViewCell: UITableViewCell {

    @IBOutlet weak var img_check: UIImageView!
    @IBOutlet weak var lb_question: UILabel!
    @IBOutlet weak var btn_check: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
