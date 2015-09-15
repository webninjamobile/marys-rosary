//
//  Mysteries.swift
//  PrayerBook
//
//  Created by keithics on 8/5/15.
//  Copyright (c) 2015 Web Ninja Technologies. All rights reserved.
//

import Foundation

class Mysteries {
    
    var daysMysteries: [String] =
    [
        "Sunday - Glorious",
        "Monday - Joyful",
        "Tuesday - Sorrowful",
        "Wednesday - Glorious",
        "Thursday - Luminous",
        "Friday - Joyful",
        "Saturday - Sorrowful"
    ]
    
   
    
    
    func getMystery(day:Int) -> String{
        return daysMysteries[day]
    }
    
    
}