//
//  Compare3x2TableViewCell.swift
//  Dentic
//
//  Created by Tanakorn on 4/3/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import UIKit

class Compare3x2TableViewCell: UITableViewCell {

    @IBOutlet weak var cons_width: NSLayoutConstraint!
    @IBOutlet weak var btn_3: UIButton!
    @IBOutlet weak var btn_2: UIButton!
    @IBOutlet weak var btn_1: UIButton!
    @IBOutlet weak var img_3: UIImageView!
    @IBOutlet weak var img_2: UIImageView!
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
