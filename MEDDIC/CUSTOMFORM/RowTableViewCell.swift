
//
//  RowTableViewCell.swift
//  MEDLOG
//
//  Created by Tanakorn on 11/8/2559 BE.
//  Copyright © 2559 Tanakorn. All rights reserved.
//

import UIKit

class RowTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lb_row: UILabel!
    @IBOutlet weak var btn_reverse: UIButton!
    @IBOutlet weak var tf_option: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
