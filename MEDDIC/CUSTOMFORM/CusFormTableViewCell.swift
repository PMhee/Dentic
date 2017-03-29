//
//  CheckBoxTableViewCell.swift
//  MEDLOG
//
//  Created by Tanakorn on 11/1/2559 BE.
//  Copyright © 2559 Tanakorn. All rights reserved.
//

import UIKit

class CusFormTableViewCell: UITableViewCell {
    
    @IBOutlet weak var img_type: UIImageView!
    @IBOutlet weak var tf_score: UITextField!
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
