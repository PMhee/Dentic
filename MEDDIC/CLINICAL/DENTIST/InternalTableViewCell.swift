//
//  InternalTableViewCell.swift
//  MEDDIC
//
//  Created by Tanakorn on 3/27/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import UIKit

class InternalTableViewCell: UITableViewCell {

    @IBOutlet weak var btn_internal: UIButton!
    @IBOutlet weak var img_internal: UIImageView!
    @IBOutlet weak var lb_type: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
