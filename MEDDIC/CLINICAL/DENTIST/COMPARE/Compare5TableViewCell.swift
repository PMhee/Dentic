//
//  Compare5TableViewCell.swift
//  Dentic
//
//  Created by Tanakorn on 4/4/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import UIKit

class Compare5TableViewCell: UITableViewCell {

    @IBOutlet weak var cons_widht: NSLayoutConstraint!
    @IBOutlet weak var img5: UIImageView!
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
