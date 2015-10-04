//
//  SettingsViewController.swift
//  PrayerBook
//
//  Created by keithics on 8/26/15.
//  Copyright (c) 2015 Web Ninja Technologies. All rights reserved.
//

import UIKit



class SettingsViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var tblSettings: UITableView!
    @IBOutlet weak var btnReset: UIButton!
    @IBOutlet weak var info: UILabel!
    @IBOutlet weak var table: UITableView!    
    @IBOutlet weak var btnSave: UIButton!
    
    //TODO : based on json file
    let settings = [
        ("Apostle's Creed","creed",10), //title,mp3 file , delay
        ("Mysteries","1stmystery",3),
        ("Our Father","ourfather",10),
        ("Hail Mary","hailmary",5),
        ("Glory Be","glorybe",4),
        ("Pray For Us","prayforus",3)
    ]
    
    let defaultDelays = [10,3,10,5,4,3]
    let userDefaults = NSUserDefaults.standardUserDefaults()
    var delays = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblSettings.tableFooterView = UIView()
        
        delays = (userDefaults.arrayForKey("defaultDelays") == nil ? defaultDelays : userDefaults.arrayForKey("defaultDelays"))!
        
        
//        NSUserDefaults.standardUserDefaults().setValue(defaultDelays, forKey: "defaultDelays")
        
         self.btnBack.setTitle("\u{f107}",forState: UIControlState.Normal)
        
        

       
    }
    
    
    @IBAction func btnBack(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let nibName = UINib(nibName: "SettingsCustomCell", bundle:nil)
        tableView.registerNib(nibName, forCellReuseIdentifier: "settingsCell")
        
        let cell = tableView.dequeueReusableCellWithIdentifier("settingsCell", forIndexPath: indexPath) as! settingsCell
        
        let (title,mp3,delay) = settings[indexPath.row];
        cell.label.text = title
        cell.value.text = String(delays[indexPath.row].integerValue) + " seconds"
        cell.stepper.value = Double(delay)
        cell.btnPlay.setTitle("\u{f144}",forState: UIControlState.Normal)
        cell.btnPlay.layer.cornerRadius = 20
        cell.btnPlay.tag = indexPath.row
        cell.btnPlay.currentCell = indexPath
        cell.btnPlay.currentMp3 = mp3
        cell.btnPlay.addTarget(self, action: "playMp3:", forControlEvents: UIControlEvents.TouchUpInside)
        return cell;
        
    }
    
    @IBAction func btnReset(sender: AnyObject) {
        let refreshAlert = UIAlertController(title: "Alert", message: "Reset to default settings?", preferredStyle: UIAlertControllerStyle.Alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (action: UIAlertAction) in
            self.save(true)

        }))
        refreshAlert.addAction(UIAlertAction(title: "No", style: .Default, handler: { (action: UIAlertAction) in
            refreshAlert.dismissViewControllerAnimated(true, completion: nil)
        }))

        
        self.presentViewController(refreshAlert, animated: true, completion: nil)
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count;
    }
    
    func playMp3(sender:CustomButtonWithValue){
        let (title,file,_) = settings[sender.tag];
        let currentCell = table.cellForRowAtIndexPath(sender.currentCell) as! settingsCell

        let viewController = self.storyboard!.instantiateViewControllerWithIdentifier("modalSettings") 
        let formSheetController = MZFormSheetPresentationController(contentViewController: viewController)
        let presentedViewController = viewController as! ModalPreviewViewController
        presentedViewController.currentPrayer = title
        presentedViewController.currentMp3 = file
        presentedViewController.responseTime = Double(currentCell.stepper.value)

        
        formSheetController.shouldCenterVertically = true
        formSheetController.shouldDismissOnBackgroundViewTap = true
        formSheetController.contentViewSize = CGSizeMake(210, 280)
        
        self.presentViewController(formSheetController, animated: true, completion: nil)

    }
    
    @IBAction func btnSave(sender: AnyObject) {
        save(false)
    }
    
    func save(reset : Bool ){
        let show = showLoading(self)
        let qualityOfServiceClass = QOS_CLASS_BACKGROUND
        let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
        
        dispatch_async(backgroundQueue, {
            self.sync()
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                show.dismissViewControllerAnimated(true, completion: nil)
                if reset {
                    self.delays =  self.defaultDelays
                    self.tblSettings.reloadData()
                }
                
            })
        })
    }
    
    func sync(){
        var status : [Bool] = []
        var mysteriesSilence = 3.0;
        
        var newDelays : [Int] = []
        
        for section in 0..<table.numberOfSections {
            
            for row in 0..<table.numberOfRowsInSection(section) {
                
                let indexPath = NSIndexPath(forRow: row, inSection: section)
                let cell = table.cellForRowAtIndexPath(indexPath) as! settingsCell
                
//                println("processing ... " + cell.btnPlay.currentMp3 + " with delay of \(cell.stepper.value)")
                newDelays.append(Int(cell.stepper.value))
                
                if cell.btnPlay.currentMp3 != "1stmystery" {
                    
                    let isOkay = Audio().merge(cell.btnPlay.currentMp3,silence: Double(cell.stepper.value))
                    status.append(isOkay)
                }else{
                    mysteriesSilence = Double(cell.stepper.value)
                }
                
            }
        }//end loop
        
        let rosary = Rosary()
        
        for index in rosary.mysteries{
            let isOkay = Audio().merge(index + "mystery",silence: mysteriesSilence)
            status.append(isOkay)
        }
        
        let isOK = !status.contains(true)
        
        if !isOK {
            notifyUserError()
        }
        
        userDefaults.setBool(isOK, forKey: "hasProcessed")
        userDefaults.setObject(newDelays, forKey: "defaultDelays")
        userDefaults.synchronize()
    }
    
    func notifyUserError(){
        let refreshAlert = UIAlertController(title: "Error", message: "Error saving audio files. ", preferredStyle: UIAlertControllerStyle.Alert)
        
        
        self.presentViewController(refreshAlert, animated: true, completion: nil)
    }
    

    
}

