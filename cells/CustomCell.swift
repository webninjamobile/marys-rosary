//
//  PersonalPrayersTableViewCell.swift
//  Litanea
//
//  Created by keithics on 3/24/15.
//  Copyright (c) 2015 Web Ninja Technologies. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {
    
    
    @IBOutlet weak var mainLabel: UILabel!
    
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var coverImage: UIImageView!
   
    @IBOutlet weak var fonticon: UILabel!
    
    @IBOutlet weak var blurView: UIView!
    

    @IBOutlet weak var hiddenButton: UIButton!

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {

        super.init(style: UITableViewCellStyle.Value1, reuseIdentifier: reuseIdentifier)
        

        
    }
    
   
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    
}
