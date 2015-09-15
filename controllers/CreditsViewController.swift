//
//  CreditsViewController.swift
//  PrayerBook
//
//  Created by keithics on 9/15/15.
//  Copyright (c) 2015 Web Ninja Technologies. All rights reserved.
//

import UIKit



class CreditsViewController: UIViewController{
    @IBOutlet weak var btnBack: UIButton!
    
    @IBOutlet weak var label: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.label.textAlignment = NSTextAlignment.Center
        self.btnBack.setTitle("\u{f107}",forState: UIControlState.Normal)
        
        
        //label.backgroundColor = UIColor.redColor()
    }
    
    override func viewDidLayoutSubviews(){
        
    }
    
    @IBAction func onBack(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
