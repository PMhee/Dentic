//
//  ExternalOralTableViewCell.swift
//  MEDDIC
//
//  Created by Tanakorn on 3/27/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import UIKit

class ExternalOralTableViewCell: UITableViewCell {

    @IBOutlet weak var img_right: UIImageView!
    @IBOutlet weak var lb_right_type: UILabel!
    
    @IBOutlet weak var img_left: UIImageView!
    @IBOutlet weak var lb_left_type: UILabel!
    @IBOutlet weak var lb_type: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var btn_right_img: UIButton!
    @IBOutlet weak var btn_left_img: UIButton!
    @IBAction func btn_right_action(_ sender: UIButton) {
    }
    @IBAction func btn_left_action(_ sender: UIButton) {
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
