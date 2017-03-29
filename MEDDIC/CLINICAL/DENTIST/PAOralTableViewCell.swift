//
//  PAOralTableViewCell.swift
//  MEDDIC
//
//  Created by Tanakorn on 3/27/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import UIKit

class PAOralTableViewCell: UITableViewCell {

    @IBOutlet var cons_width: NSLayoutConstraint!
    @IBOutlet weak var lb_type: UILabel!
    @IBOutlet weak var btn_4: UIButton!
    @IBOutlet weak var img_4: UIImageView!
    @IBOutlet weak var btn_3: UIButton!
    @IBOutlet weak var img_3: UIImageView!
    @IBOutlet weak var btn_2: UIButton!
    @IBOutlet weak var img_2: UIImageView!
    @IBOutlet weak var btn_1: UIButton!
    @IBOutlet weak var img_1: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
