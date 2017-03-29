//
//  PatientProfilTableViewCell.swift
//  MEDDIC
//
//  Created by Tanakorn on 1/22/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import UIKit

class PatientProfilTableViewCell: UITableViewCell {

    @IBOutlet weak var tf: UITextField!
    @IBOutlet weak var icon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
