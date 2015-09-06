//
//  ViewController.swift
//  PrayerBook
//
//  Created by keithics on 8/4/15.
//  Copyright (c) 2015 Web Ninja Technologies. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource{

    @IBOutlet weak var todaysMystery: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var currentIndex : Int = 0;
    
    let mysteries = [
        ("Joyful Mysteries","Mondays, Saturdays, Sundays of Advent, and Sundays from Epiphany until Lent","joyful","#8f0f0f"),
        ("Luminous Mysteries","Every Thursday","luminous","#6f6e41"),
        ("Sorrowful Mysteries","Tuesdays, Fridays, and daily from Ash Wednesday until Easter Sunday","sorrowful","#0f0f12"),        
        ("Glorious Mysteries","Every Wednesdays, and Sundays","glorious","#cc6a0b"),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "The Holy Rosary";
        
        let dat = NSDate().toWeekDay();

        todaysMystery.text = Mysteries().getMystery(dat) + " Mysteries";
        
        
        let logButton : UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: self, action: "gotoSettings:")

        self.navigationItem.rightBarButtonItem = logButton
        
        //self.parentViewController.view.backgroundColor = UIColor.redColor();
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"updateMystery", name:
            UIApplicationWillEnterForegroundNotification, object: nil)
        
    }
    
    func updateMystery(){
        let dat = NSDate().toWeekDay();
        
        todaysMystery.text = Mysteries().getMystery(dat) + " Mysteries";
    }
    
    deinit{
         NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func gotoSettings(sender: AnyObject){
        self.performSegueWithIdentifier("settings", sender: sender)
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let nibName = UINib(nibName: "CustomCell", bundle:nil)
        tableView.registerNib(nibName, forCellReuseIdentifier: "customcell")
        
        let cell = tableView.dequeueReusableCellWithIdentifier("customcell", forIndexPath: indexPath) as! CustomCell


        let (title,note,key,color) = mysteries[indexPath.row];
        cell.mainLabel.text = title;
        cell.noteLabel.text = note;
        cell.coverImage.image = UIImage(named:key)
        cell.blurView.backgroundColor = UIColor(rgba: color);
        cell.fonticon.text = "\u{f105}";
        //not on the custom cell
        cell.hiddenButton.tag = indexPath.row
        cell.hiddenButton.addTarget(self, action: "selectCell:", forControlEvents: UIControlEvents.TouchUpInside)

        return cell;
    }
    
    func selectCell(sender:UIButton) {
        self.currentIndex = sender.tag
        self.performSegueWithIdentifier("sgPrayerView", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "sgPrayerView"){
            let viewController:PrayerSingleViewController = segue.destinationViewController as! PrayerSingleViewController
            let (title,note,key,color) = mysteries[self.currentIndex];
            
            viewController.myTitle = title;
            viewController.mysteryIndex = self.currentIndex;
        }
    }
   
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mysteries.count;
    }
    
    
}

