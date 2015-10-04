//
//  PrayerSingleViewController.swift
//  PrayerBook
//
//  Created by keithics on 8/12/15.
//  Copyright (c) 2015 Web Ninja Technologies. All rights reserved.
//

import UIKit
import AVFoundation

class PrayerSingleViewController: UIViewController , AVAudioPlayerDelegate{
    
    var myTitle: String = ""
    var mysteryIndex: Int = 0
    var currentProgress: Int = 0
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var prayerTitle: UILabel!
    @IBOutlet weak var prayer: UILabel!
    
    

    @IBOutlet weak var btnToggleBgMusic: UIButton!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnPrev: UIButton!
    
    let beads = [("Start",12.5),("I",20),("II",20),("III",20),("IV",20),("V",20),("End",12.5)]
    let beadsIndex = [8,22,36,50,64,78,86]
    let beadsNumPrayers = [8,14,14,14,14,13,8]
    var currentBead = 0;
    var beadsArray : [CircleProgress] = []
    
    var beadsTap: UITapGestureRecognizer?
    
    var rosary : [(String,String,String,Int)] = []
    
    var mp3:AVAudioPlayer = AVAudioPlayer()
    var backgroundMusic:AVAudioPlayer = AVAudioPlayer()
    
    var autoPlay = false
    
    var hasLoadedMp3 = false
    
    var isPlaying = false // has the user clicked the play button?
    
    var nextDelay = 0; //
    
    var isDonePlaying = false //check if the music has done playing, for pause/play
    
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    var saveDefaults = false;
    
    var isBackgroundPlaying = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rosary = Rosary();
        self.rosary = rosary.prayRosary(self.mysteryIndex);

//        prepare rosary audio
        checkMp3(rosary)
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width
        let fullWidth = screenWidth/7;
        let pad = 4;
        let dimen = CGFloat(Int(fullWidth) - pad);
        
        
        self.title = self.myTitle;
        
        _ = 10;
        
        //create beads
        for i in 0...6 {
            let newX = CGFloat((i * Int(fullWidth)) + pad);
            let beadsProgress = CircleProgress(frame: CGRectMake(newX, 80, dimen, dimen))
            let (title,size) = beads[i]
            beadsProgress.tag = i
            beadsProgress.progressLabel.text = title
            beadsProgress.progressLabel.font = UIFont(name: "KefaIIPro-Regular", size: CGFloat(size))
            
            beadsTap = UITapGestureRecognizer(target: self , action: Selector("gotoBead:"))
            beadsTap!.numberOfTapsRequired = 1
            
            beadsProgress.addGestureRecognizer(beadsTap!)
            
            self.view.addSubview(beadsProgress)
            
            
            beadsArray.append(beadsProgress)
            //DynamicView.animateProgressView()
            
        }
        
        
        //println(rosary.prayRosary(mysteryIndex))
        
        self.prayer.sizeToFit()
        
        
        self.btnPrev.setTitle("\u{f04a}",forState: UIControlState.Normal)
        self.btnNext.setTitle("\u{f04e}",forState: UIControlState.Normal)
        self.btnPlay.setTitle("\u{f04b}",forState: UIControlState.Normal)
        self.btnToggleBgMusic.setTitle("\u{f001}",forState: UIControlState.Normal)
        
        //        self.navigationItem.title = "asd";
        
        
        //self.parentViewController.view.backgroundColor = UIColor.redColor();
        //restore bead
        var lastProgress = 0;
        if self.mysteryIndex == userDefaults.integerForKey("lastMystery") {
             self.currentBead = userDefaults.integerForKey("lastBead");
             lastProgress = userDefaults.integerForKey("lastProgress")
        }
        
        pray(lastProgress,recite:false)

        checkControls()
        
        // swipes
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        
        leftSwipe.direction = .Left
        rightSwipe.direction = .Right
        
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
        
        let pathBackground = NSBundle.mainBundle().pathForResource("avemaria", ofType: "mp3")
        
        backgroundMusic = try! AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: pathBackground!))
        backgroundMusic.volume = 0.1
        backgroundMusic.numberOfLoops = -1;
        backgroundMusic.prepareToPlay()

        
    }
    
    func back(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pray(currentIndex : Int,direction : String = "forward",recite: Bool = false){
        
        self.prayer.fadeOut()
        self.prayerTitle.fadeOut()
        
        
        let (title,content,mp3,delay) = self.rosary[currentIndex]
        self.prayer.text = content
        self.prayerTitle.text = title
        self.nextDelay = delay
        
        if(recite){ //do not play if last prayer
            playMp3(mp3,delay:delay)
        }
        
        self.prayer.fadeIn()
        self.prayerTitle.fadeIn()
        
        
        
        if(currentIndex >= self.beadsIndex[self.currentBead]){
            //next bead
            self.currentBead++
        }
        
        showHideBeadProgress(self.currentBead)
        
        let mulcrement : CGFloat = CGFloat((100/self.beadsNumPrayers[self.currentBead]))/100
        
        let currentProgress = currentIndex < self.beadsNumPrayers[0] ? currentIndex : (currentIndex - self.beadsIndex[self.currentBead - 1])
        
        
        let nextcrement : CGFloat = CGFloat(Double(currentProgress) + 1.00)
        
        if (direction == "forward"){
            beadsArray[self.currentBead].animateProgressView(mulcrement * CGFloat(Double(currentProgress)) , to: mulcrement  * nextcrement)
        }else{
            //back
            beadsArray[self.currentBead].animateProgressView( (mulcrement  * nextcrement) + mulcrement, to: mulcrement  * nextcrement)
            
        }
        
        
        self.currentProgress = currentIndex
        checkControls()
        
        //save current progress
        if(self.saveDefaults){
            userDefaults.setInteger(self.currentProgress,forKey: "lastProgress")
            userDefaults.setInteger(self.currentBead,forKey: "lastBead")
            userDefaults.setInteger(self.mysteryIndex,forKey: "lastMystery")
            
        }
        
    }
    
    @IBAction func onNext(sender: AnyObject) {
        self.autoPlay = false
        nextPrayer(false, willPause: true)
    }
    
    func nextPrayer(autoplay : Bool = false , willPause: Bool = false){
        if willPause {
            pauseMp3()
        }
        userMoved()
        pray(self.currentProgress.maxcrement(self.rosary.count - 1),recite:autoplay)
    }
    
    @IBAction func onPrev(sender: AnyObject) {
        userMoved()
        pauseMp3()
        let currentIndex = self.currentProgress.mincrement
        //println(currentIndex)
        
        if(currentIndex <= self.beadsIndex[self.currentBead ]){
            //clear prev bead
            beadsArray[self.currentBead].hideProgressView()
            //prev bead
            self.currentBead = self.currentBead.mincrement
            
        }
        
        pray(currentIndex,direction: "back")
    }
    
    @IBAction func onPlay(sender: AnyObject) {
        
        self.saveDefaults = true
        if self.hasLoadedMp3 && !isDonePlaying && !self.isPlaying {
            //mp3 is paused
            mp3.play() // play the old one
            playBackground()
            self.autoPlay = true
            isDonePlaying = false
            isPlaying = true
            //            pray(self.currentProgress,recite:false)
            self.btnPlay.setTitle("\u{f04c}",forState: UIControlState.Normal)
        }  else
            if !isPlaying {
                playBackground()
                self.autoPlay = true
                pray(self.currentProgress,recite:true)
                self.btnPlay.setTitle("\u{f04c}",forState: UIControlState.Normal)
            }else {
                self.btnToggleBgMusic.alpha = 1
                pauseBackground()
                pauseMp3()
        }
        
    }
    
    @IBAction func toggleBgMusic(sender: AnyObject) {
        //TODO , set to userdefaults
        if(isBackgroundPlaying){
            pauseBackground()
        }else{
             playBackground()
        }
        
        
    }
    
    func playBackground(){
        backgroundMusic.play()
        btnToggleBgMusic.alpha = 0.5
        isBackgroundPlaying = true
    }
    
    func pauseBackground(){
        backgroundMusic.pause()
        btnToggleBgMusic.alpha = 1
        isBackgroundPlaying = false
    }
    
    
    func checkControls(){
        if(self.currentProgress == 0){
            btnPrev.alpha = 0.5
            btnPrev.enabled = false
        }else{
            btnPrev.alpha = 1.0
            btnPrev.enabled = true
        }
        
        if(self.currentProgress >= self.rosary.count - 1){
            btnNext.alpha = 0.5
            btnNext.enabled = false
        }else{
            btnNext.alpha = 1.0
            btnNext.enabled = true
        }
        
    }
    
    func gotoBead(sender: UITapGestureRecognizer!){
        if sender.state == .Ended {
            let currentBead = sender.view!.tag
            
            self.currentBead = currentBead
            let currentPrayer = currentBead > 0 ? self.beadsIndex[currentBead - 1] : 0;
            //            let playmp3 = currentBead > 0 ? true : false
            userMoved()
            pauseMp3()
            pray(currentPrayer,recite:false)
            
        }
    }
    
    func showHideBeadProgress(currentBead : Int){

        for i in 0..<currentBead {
            //println(i)
            beadsArray[i].showProgressView()
        }
        
        for i in currentBead  ..< beadsArray.count {
          //  println(currentBead)
            beadsArray[i].hideProgressView()
        }
    }
    
    func handleSwipes(sender:UISwipeGestureRecognizer) {
        if (sender.direction == .Left) {
            btnNext.sendActionsForControlEvents(UIControlEvents.TouchUpInside)
        }
        
        if (sender.direction == .Right) {
            btnPrev.sendActionsForControlEvents(UIControlEvents.TouchUpInside)
        }
    }
    
    func playMp3(file : String, delay : Int) {
        if(delay == 0){
            mp3 = try! AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath:  NSBundle.mainBundle().pathForResource(file, ofType: "mp3")!))
        }else{
            //play processed audio instead
            let paths = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
            let documentsURL = paths[0] 

            let processedAudio = documentsURL.URLByAppendingPathComponent(file.m4a)
            try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            mp3 = try! AVAudioPlayer(contentsOfURL: processedAudio)

        }
        

        
        mp3.prepareToPlay()
        self.hasLoadedMp3 = true
        
        mp3.delegate = self
        mp3.play()
        
        isDonePlaying = false
        isPlaying = true
    }
    
    func userMoved(){ //triggered if user taps on prev,next or beads
        self.isDonePlaying = true
        self.isPlaying = false
    }
    
    func pauseMp3(){
        if(self.hasLoadedMp3){
            self.isPlaying = false
            self.autoPlay = false
            self.mp3.pause();
            self.btnPlay.setTitle("\u{f04b}",forState: UIControlState.Normal)
        }
    }
    
    /* Prepare audio and delete if audio is already processed
    */
    
    func toggleControls(enable : Bool , alpha : Double){
        self.btnNext.enabled = enable
        self.btnNext.alpha = CGFloat(alpha)
        
        self.btnPlay.enabled = enable
        self.btnPlay.alpha = CGFloat(alpha)
    }
    
    func prepareAudio(rosary : Rosary){
        var status : [Bool] = []
        
        for (_, subJson): (String, JSON) in JSON(data:rosary.rosaryJson) {
            if subJson["delay"] > 0 {
                let isOkay = Audio().merge(subJson["mp3"].stringValue,silence: Double(subJson["delay"].intValue))
                status.append(isOkay)
            }
        };
        
        for index in rosary.mysteries{
            let isOkay = Audio().merge(index + "mystery",silence: 3)
            status.append(isOkay)
        }
        
        let isOK = !status.contains(true)
        
        if !isOK {
            notifyUserError()
        }
        
        userDefaults.setBool(isOK, forKey: "hasProcessed")
        
        
    }
    
    func checkMp3(rosary  :Rosary){
        
        if !userDefaults.boolForKey("hasProcessed"){
            
            let qualityOfServiceClass = QOS_CLASS_BACKGROUND
            let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
            dispatch_async(backgroundQueue, {
                self.toggleControls(false,alpha: 0.5)
                self.prepareAudio(rosary)
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.toggleControls(true,alpha: 1)
                    
                })
            })
        }else{
            var audiofiles : [String] = [];
            
            //check if mp3 files exists, just in case :)
            for (_, subJson): (String, JSON) in JSON(data:rosary.rosaryJson) {
                if subJson["delay"] > 0 {
                    audiofiles.append(subJson["mp3"].stringValue)
                }
            };
            
            for index in rosary.mysteries{
                audiofiles.append(index + "mystery")
            }
            let docPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] 
            
            let checkValidation = NSFileManager.defaultManager()
            
            for eachAudio in audiofiles{
                let exportPath = (docPath as NSString).stringByAppendingPathComponent(eachAudio.m4a)
                if (!checkValidation.fileExistsAtPath(exportPath)) {
                    notifyUserError()
                    break
                }
     
            }
        }
    }
    
    func notifyUserError(){
        let refreshAlert = UIAlertController(title: "Error", message: "Error saving audio files. ", preferredStyle: UIAlertControllerStyle.Alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Retry", style: .Default, handler: { (action: UIAlertAction) in
            NSUserDefaults.standardUserDefaults().setBool(false, forKey: "hasProcessed")
            self.back()
        }))
        
        self.presentViewController(refreshAlert, animated: true, completion: nil)
    }
    
    // delegates
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        isDonePlaying = true
        if(self.autoPlay && self.currentProgress < self.rosary.count - 1){
            self.nextPrayer(true)
        }
        
        if(self.currentProgress == self.rosary.count - 1){ // last item
            //change play button
            self.btnPlay.setTitle("\u{f04b}",forState: UIControlState.Normal)
            let fader = iiFaderForAvAudioPlayer(player: backgroundMusic)
            fader.volumeAlterationsPerSecond = 10
            fader.fadeOut(7, velocity: 1)
           // backgroundMusic.fadeOut()
        }


        
        
    }
    
    
}


