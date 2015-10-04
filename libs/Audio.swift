//
//  Audio.swift
//  PrayerBook
//
//  Created by keithics on 8/15/15.
//  Copyright (c) 2015 Web Ninja Technologies. All rights reserved.
//

import Foundation
import AVFoundation


class Audio {
    
    func merge(audio1: String,silence : Float64) -> Bool{
        
        

        
        var ok1 = false
        
        let composition = AVMutableComposition()
        let compositionAudioTrack1:AVMutableCompositionTrack = composition.addMutableTrackWithMediaType(AVMediaTypeAudio, preferredTrackID: CMPersistentTrackID())
        
        //create new file to receive data
        let paths = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let documentsURL = paths[0] 
        
        // delete if exists
        let paths2 = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] 
        
        let fileDestinationUrl = documentsURL.URLByAppendingPathComponent(audio1.m4a)
        let exportPath = (paths2 as NSString).stringByAppendingPathComponent(audio1.m4a)
        let checkValidation = NSFileManager.defaultManager()
        
        if (checkValidation.fileExistsAtPath(exportPath))
        {
            do {
                try checkValidation.removeItemAtURL(fileDestinationUrl)
            } catch _ {
            }
        }
        
        let url1 = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(audio1, ofType: "mp3")!)
        let avAsset1 = AVURLAsset(URL: url1, options: nil)
        var tracks1 =  avAsset1.tracksWithMediaType(AVMediaTypeAudio)
        
        let assetTrack1:AVAssetTrack = tracks1[0] 
        
        let duration1: CMTime = assetTrack1.timeRange.duration
        let duration2 = CMTimeSubtract(duration1,CMTimeMakeWithSeconds(0.1,duration1.timescale)) //deduct 0.1 second
        
        let timeToAdd   = CMTimeMakeWithSeconds(silence,duration1.timescale);
        
        let timeRange1 = CMTimeRangeMake(kCMTimeZero, duration1)
        
        
        do {
            try compositionAudioTrack1.insertTimeRange(timeRange1, ofTrack: assetTrack1, atTime: kCMTimeZero)
            ok1 = true
        } catch _ {
            ok1 = false
        }
        if ok1 {
            compositionAudioTrack1.insertEmptyTimeRange(CMTimeRangeMake(duration2,timeToAdd))
        }
        
        var errorExport = true
        //AVAssetExportPresetPassthrough => concatenation
        let assetExport = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetAppleM4A)
        assetExport!.outputFileType =  AVFileTypeAppleM4A
        assetExport!.outputURL = fileDestinationUrl
        let sessionWaitSemaphore = dispatch_semaphore_create(0)
        
        assetExport!.exportAsynchronouslyWithCompletionHandler({
            switch assetExport!.status{
            case  AVAssetExportSessionStatus.Failed:
               print("failed \(assetExport!.error)")
            case AVAssetExportSessionStatus.Cancelled:
              print("cancelled \(assetExport!.error)")
            default:
                errorExport = false
            }
            
            dispatch_semaphore_signal(sessionWaitSemaphore)
            return Void()
            
        })
        
        dispatch_semaphore_wait(sessionWaitSemaphore, DISPATCH_TIME_FOREVER)
        
        return errorExport
        
        
        
    }
}