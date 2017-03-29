//
//  StoneOralTableViewCell.swift
//  MEDDIC
//
//  Created by Tanakorn on 3/28/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import UIKit

class StoneOralTableViewCell: UITableViewCell {

    @IBOutlet var cons_width: NSLayoutConstraint!
    @IBOutlet var btn_right: UIButton!
    @IBOutlet var btn_left: UIButton!
    @IBOutlet var btn_back: UIButton!
    @IBOutlet var btn_top: UIButton!
    @IBOutlet var btn_front: UIButton!
    @IBOutlet var img_right: UIImageView!
    @IBOutlet var img_left: UIImageView!
    @IBOutlet var img_back: UIImageView!
    @IBOutlet var img_top: UIImageView!
    @IBOutlet var img_front: UIImageView!
    @IBOutlet var lb_type: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
