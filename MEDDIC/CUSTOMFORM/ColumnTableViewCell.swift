//
//  ColumnTableViewCell.swift
//  MEDLOG
//
//  Created by Tanakorn on 11/8/2559 BE.
//  Copyright © 2559 Tanakorn. All rights reserved.
//

import UIKit

class ColumnTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lb_column: UILabel!
    @IBOutlet weak var tf_option: UITextField!
    @IBOutlet weak var tf_score: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
