//
//  Compare2TableViewCell.swift
//  Dentic
//
//  Created by Tanakorn on 4/3/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import UIKit

class Compare2TableViewCell: UITableViewCell {

    @IBOutlet weak var cons_width: NSLayoutConstraint!
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
