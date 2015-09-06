//
//  MinMax+Int.swift
//  PrayerBook
//
//  Created by keithics on 8/14/15.
//  Copyright (c) 2015 Web Ninja Technologies. All rights reserved.
//

extension Int {
 
    var mincrement : Int {return self - 1 > 0 ? self - 1 : 0 }
    
   
    func maxcrement(max: Int) -> Int {       
        return self >= max ? max  : self + 1
    }
    
}