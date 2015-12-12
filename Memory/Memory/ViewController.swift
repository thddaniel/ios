//
//  ViewController.swift
//  Memory
//
//  Created by tanghao on 05/12/2015.
//  Copyright © 2015 tanghao. All rights reserved.
//

import UIKit
import AVFoundation
import LocalAuthentication
import Darwin

class ViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var audioPlayer:AVAudioPlayer!
    @IBOutlet weak var playBotton: UIButton!
    @IBOutlet weak var newImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        //call start touchID
        TouchIDCall()
        
        /*load mp3*/
        let filePathUrl = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("tingge", ofType: "mp3")!)
        do{
             audioPlayer = try AVAudioPlayer(contentsOfURL:filePathUrl)
             audioPlayer.numberOfLoops = -1
        }catch {
            print("the filePath is empty")
        }
        
        /*supporting background play*/
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
        
        /*fit image*/
        //newImage = UIImageView(frame: CGRectMake(0, 50, 320, 320))
        //newImage.clipsToBounds = true
        //newImage.contentMode = UIViewContentMode.ScaleAspectFit

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /* playButton play and stop music */
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
    
    
    
    @IBAction func selectImageFromPhotoLibrary(sender: UITapGestureRecognizer) {
        // Hide the keyboard.
        //nameTextField.resignFirstResponder()
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        print("selectImageFromPhotoLibrary in")
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .PhotoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        
        presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // The info dictionary contains multiple representations of the image, and this uses the original.
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        // Set photoImageView to display the selected image.
        newImage.image = selectedImage
        
        // Dismiss the picker.
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func TouchIDCall(){
        let authContext : LAContext = LAContext()
    
        var error : NSError?
        if authContext.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, error: &error){
            authContext.evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, localizedReason: "Personal Information", reply: {
                (wasSuccessful : Bool, error : NSError?) in
                if wasSuccessful{
                    NSLog("success log in")
                }else{
                    NSLog("failed log in")
                    exit(0)
                }
            })
        }else{
            //device without touch id
        }
    }
    
    

    
}

