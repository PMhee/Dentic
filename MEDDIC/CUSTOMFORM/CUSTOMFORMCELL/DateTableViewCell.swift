//
//  DateTableViewCell.swift
//  MEDDIC
//
//  Created by Tanakorn on 2/5/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import UIKit

class DateTableViewCell: UITableViewCell {

    @IBOutlet weak var lb_date: UILabel!
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
