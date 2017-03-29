//
//  PictureTableViewCell.swift
//  MEDDIC
//
//  Created by Tanakorn on 2/4/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import UIKit

class PictureTableViewCell: UITableViewCell {
    var idx = 0
    var answer = CustomFormAnswer()
    @IBOutlet weak var btn_picture: UIButton!
    @IBOutlet weak var img_picture: UIImageView!
    @IBOutlet weak var lb_question: UILabel!
    @IBOutlet weak var img_star: UIImageView!
    @IBOutlet weak var lb_number: UILabel!
    @IBOutlet weak var vw_number: UIView!
    @IBOutlet weak var vw_layout: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
