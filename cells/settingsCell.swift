//
//  PersonalPrayersTableViewCell.swift
//  Litanea
//
//  Created by keithics on 3/24/15.
//  Copyright (c) 2015 Web Ninja Technologies. All rights reserved.
//

import UIKit

class settingsCell: UITableViewCell {
    
   

    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var btnPlay: CustomButtonWithValue!
    @IBOutlet weak var value: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    
        
    @IBAction func onStep(sender: UIStepper) {
        let s = Int(sender.value) == 1 ? "" : "s"
        self.value.text = Int(sender.value).description + " second" + s
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    
}
