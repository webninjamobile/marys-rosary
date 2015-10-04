//
//  Mysteries.swift
//  PrayerBook
//
//  Created by keithics on 8/5/15.
//  Copyright (c) 2015 Web Ninja Technologies. All rights reserved.
//

import Foundation

class Rosary {
    
    let rosaryJson : NSData
    let mysteryJson : NSData
    var rosaryPrayers : [(String,String,String,Int)] = []
    let mysteries = ["1st","2nd","3rd","4th","5th"]
    
    init(){
        rosaryJson =  Helpers().readjson("rosary");
        mysteryJson =  Helpers().readjson("mysteries");
    }
    
    
    func getPrayer(index : Int) -> (String,String,String,Int){
        
        let json = JSON(data: self.rosaryJson)
        let title = json[index]["title"].string
        let content = json[index]["content"].string
        let mp3 = json[index]["mp3"].string
        let delay = json[index]["delay"].int
        
        return (title!,content!,mp3!,delay!)
    }
    
    func getMystery(msytery : Int,index: Int) -> (String,String,String,Int){
        
        let json = JSON(data: self.mysteryJson)
        let title = json[msytery][index]["title"].string
        let content = json[msytery][index]["content"].string
        let mp3 = mysteries[index] + "mystery" //mp3 filename
        
        return (title!,content!,mp3,3)
    }
    
    // formulate all of the rosary prayers into an array
    func prayRosary(mystery : Int ) -> [(String,String,String,Int)]{
        rosaryPrayers.append(getPrayer(10))//Ending Prayer
        rosaryPrayers.append(getPrayer(7))//Sign of the Cross
        rosaryPrayers.append(getPrayer(0))//Apostle's Creed
        rosaryPrayers.append(getPrayer(1))//Our Father
        rosaryPrayers += hailMaries(3) // 3 Hail Mary
        rosaryPrayers.append(getPrayer(3))//Glory Be
        rosaryPrayers.append(getMystery(mystery,index:0))//First Mystery
        //2nd-5th, zero index
        for i in 1...5{
            rosaryPrayers.append(getPrayer(1))//1 Our Father
            rosaryPrayers += hailMaries(10) // 10 Hail Mary
            rosaryPrayers.append(getPrayer(3))//1 Glory Be
            rosaryPrayers.append(getPrayer(4))//1 Fatima Prayer
            if(i < 5 ){
            rosaryPrayers.append(getMystery(mystery,index:i))//Mystery
            }
        }
        rosaryPrayers.append(getPrayer(5))//Hail Holy Queen
        rosaryPrayers.append(getPrayer(8))//Pray for us
        rosaryPrayers.append(getPrayer(6))//Ending Prayer
        rosaryPrayers.append(getPrayer(9))//Popes Intentions intro
        rosaryPrayers.append(getPrayer(1))//Our Father
        rosaryPrayers += hailMaries(1) // 3 Hail Mary
        rosaryPrayers.append(getPrayer(3))//1 Glory Be
        rosaryPrayers.append(getPrayer(7))//Sign of the Cross        
       // println(rosaryPrayers.count)
        return rosaryPrayers
        
    }
    
    func hailMaries(max : Int) -> [(String,String,String,Int)]{
        var hm : [(String,String,String,Int)] = [];
        for i in 1...max {
            hm.append( String(i) + ". " + getPrayer(2).0 as String,getPrayer(2).1 as String,getPrayer(2).2 as String,getPrayer(2).3)
        }
        
        return hm
    }
    
    
    
}