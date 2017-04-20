//
//  Compare4TableViewCell.swift
//  Dentic
//
//  Created by Tanakorn on 4/19/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import UIKit

class Compare4TableViewCell: UITableViewCell {

    @IBOutlet weak var cons_img_width: NSLayoutConstraint!
    @IBOutlet weak var img4: UIImageView!
    @IBOutlet weak var img3: UIImageView!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var img1: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
