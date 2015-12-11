//
//  ViewController.swift
//  Memory
//
//  Created by tanghao on 05/12/2015.
//  Copyright © 2015 tanghao. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var audioPlayer:AVAudioPlayer!
    @IBOutlet weak var playBotton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let filePathUrl = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("tingge", ofType: "mp3")!)
        do{
             audioPlayer = try AVAudioPlayer(contentsOfURL:filePathUrl)
             audioPlayer.numberOfLoops = -1
        }catch {
            print("the filePath is empty")
        }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            print("AVAudioSession Category Playback OK")
            do {
                try AVAudioSession.sharedInstance().setActive(true)
                print("AVAudioSession is Active")
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func playMusic(sender: UIButton) {
        playBotton.setTitle("stop", forState: UIControlState.Selected)
        playBotton.setTitle("play", forState: UIControlState.Normal)
        
       sender.selected = !sender.selected
        if sender.selected{
            
            audioPlayer.play()
            print("play")
            
        }else{
            print("stop")
            audioPlayer.stop()
            audioPlayer.currentTime = 0
            
        }
    }
}

