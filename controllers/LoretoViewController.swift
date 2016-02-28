//
//  LoretoViewController.swift
//  PrayerBook
//
//  Created by keithics on 2/15/16.
//  Copyright © 2016 Web Ninja Technologies. All rights reserved.
//

import UIKit
import AVFoundation

class LoretoViewController: UIViewController {
    
    
    @IBOutlet var btnPlay: UIButton!
    var mp3:AVAudioPlayer = AVAudioPlayer()
    
    var isPlaying  = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       self.btnPlay.setTitle("\u{f04b}",forState: UIControlState.Normal)
        let pathBackground = NSBundle.mainBundle().pathForResource("loreto", ofType: "mp3")
        
        mp3 = try! AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: pathBackground!))
        mp3.numberOfLoops = -1;
        mp3.prepareToPlay()
        
    }
    
    @IBAction func onPlay(sender: AnyObject) {
        if !isPlaying {
            
            isPlaying = true
            self.btnPlay.setTitle("\u{f04c}",forState: UIControlState.Normal)
            mp3.play()
            
        }else{
            isPlaying = false
            self.btnPlay.setTitle("\u{f04b}",forState: UIControlState.Normal)
            mp3.pause()
        }
    }
    
    func handleTap(gestureRecognize: UIGestureRecognizer) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
}

