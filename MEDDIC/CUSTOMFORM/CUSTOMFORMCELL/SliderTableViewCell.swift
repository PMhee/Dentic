//
//  SliderTableViewCell.swift
//  MEDDIC
//
//  Created by Tanakorn on 2/5/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import UIKit
import RealmSwift
class SliderTableViewCell: UITableViewCell {
    var answer = CustomFormAnswer()
    @IBOutlet weak var lb_min: UILabel!
    @IBOutlet weak var lb_value: UILabel!
    @IBOutlet weak var lb_max: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var lb_question: UILabel!
    @IBOutlet weak var img_star: UIImageView!
    @IBOutlet weak var lb_number: UILabel!
    @IBOutlet weak var vw_number: UIView!
    @IBOutlet weak var vw_layout: UIView!
    
    @IBAction func slider_change(_ sender: UISlider) {
        self.lb_value.text = String(Int(slider.value))
        try! Realm().write {
            self.answer.answer = self.lb_value.text!
            self.answer.requiredChecked = true
        }
    }
    @IBAction func slider_end(_ sender: UISlider) {
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
