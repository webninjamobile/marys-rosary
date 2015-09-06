//
//  ModalPreviewViewController.swift
//  PrayerBook
//
//  Created by keithics on 8/27/15.
//  Copyright (c) 2015 Web Ninja Technologies. All rights reserved.
//

import UIKit
import AVFoundation

class ModalPreviewViewController: UIViewController {
    
    
    @IBOutlet weak var viewPlay: CircleProgress!
    
    @IBOutlet weak var labelTitle: UILabel!
    
    
    var mp3:AVAudioPlayer = AVAudioPlayer()
    var responseTime : Double = 0
    var currentPrayer : String = ""
    var timer = NSTimer()
    var currentMp3 : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewPlay.layer.cornerRadius = 100
        viewPlay.lineWidth = CGFloat(10.0)
        viewPlay.fill = "#E63320"
        viewPlay.layer.backgroundColor = UIColor(rgba: "#e7993c").CGColor
        viewPlay.progressLabel.text = "\u{f144}"
        viewPlay.progressLabel.font = UIFont(name: "FontAwesome", size: CGFloat(140))
        
        
    }
    
    
    @IBAction func tapHidden(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        self.mp3.stop()
    }
    
    
    override func viewDidAppear(animated: Bool) {
         super.viewDidAppear(animated)
        var path = NSBundle.mainBundle().pathForResource(currentMp3, ofType: "mp3")
        mp3 = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: path!), error: nil)
        mp3.prepareToPlay()
        mp3.play()

        delay(Double(mp3.duration)) {
            self.updateCounter()
            self.viewPlay.animateLayerFill()
            self.timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target:self, selector: Selector("updateCounter"), userInfo: nil, repeats: true)
        }
        
        labelTitle.text = currentPrayer
        viewPlay.animateProgressView(0.0,to: 1.0,duration: CFTimeInterval(Double(responseTime) + Double(mp3.duration)))
        
    }
    
    func updateCounter(){
        responseTime -= 0.1
        let rounded = Double(round(1000*responseTime)/1000)
        labelTitle.text = "\(rounded)"
        if rounded <= 0 {
            timer.invalidate()
            labelTitle.text = currentPrayer
            delay(0.5) {
                self.dismissViewControllerAnimated(true, completion: nil)
                self.mp3.stop()
            }

        }
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        self.mp3.stop()
    }
    
    
}
