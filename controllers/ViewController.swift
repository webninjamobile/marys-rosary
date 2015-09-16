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
    
    var mysteries : [(String,String,String,String,Int)] = []
     var mysteryIndex = [2,0,1,2,3,0,1]
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "The Holy Rosary";
        
        let dat = NSDate().toWeekDay();

        todaysMystery.text = Mysteries().getMystery(dat) + " Mysteries";
        
        
        let logButton : UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: self, action: "gotoSettings:")

        self.navigationItem.rightBarButtonItem = logButton
        
        let leftButton : UIBarButtonItem = UIBarButtonItem(title: "\u{f004}", style: UIBarButtonItemStyle.Plain, target: self, action: "gotoCredits:")
        leftButton.setTitleTextAttributes([
            NSFontAttributeName : UIFont(name: "FontAwesome", size: 22)!,
            NSForegroundColorAttributeName : UIColor.whiteColor()],
            forState: UIControlState.Normal)
        self.navigationItem.leftBarButtonItem = leftButton
        
        //self.parentViewController.view.backgroundColor = UIColor.redColor();
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"updateMystery", name:
            UIApplicationWillEnterForegroundNotification, object: nil)
        updateRow()
    }
    
    
    func updateRow(){
        let dat = NSDate().toWeekDay();
        let mysteries = [
            ("Joyful Mysteries","Mondays, Saturdays, Sundays of Advent, and Sundays from Epiphany until Lent","joyful","#8f0f0f",0),
            ("Sorrowful Mysteries","Tuesdays, Fridays, and daily from Ash Wednesday until Easter Sunday","sorrowful","#0f0f12",1),
            ("Glorious Mysteries","Every Wednesdays, and Sundays","glorious","#cc6a0b",2),
            ("Luminous Mysteries","Every Thursday","luminous","#6f6e41",3),
        ]
        self.mysteries = mysteries
        self.mysteries.removeAtIndex(mysteryIndex[dat])
        self.mysteries.insert(mysteries[mysteryIndex[dat]],atIndex:0)
    }
    
    func updateMystery(){
        let dat = NSDate().toWeekDay();
        
        todaysMystery.text = Mysteries().getMystery(dat) + " Mysteries";
        updateRow()

    }
    
    deinit{
         NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func gotoSettings(sender: AnyObject){
        self.performSegueWithIdentifier("settings", sender: sender)
    }
    
    func gotoCredits(sender: AnyObject){
        self.performSegueWithIdentifier("credits", sender: sender)
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


        let (title,note,key,color,index) = mysteries[indexPath.row];
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
            let (title,note,key,color,index) = mysteries[self.currentIndex];
            
            viewController.myTitle = title;
            viewController.mysteryIndex = index;
        }
    }
   
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mysteries.count;
    }
    
    
}

