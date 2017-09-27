//
//  ViewController.swift
//  AudioPlayer
//
//  Created by Ram Yadav on 7/23/17.
//  Copyright © 2017 Ram Yadav. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    var audioPlay:AVAudioPlayer  = AVAudioPlayer()
    @IBOutlet weak var label: UILabel!
    var timer:Timer = Timer()
    var second = 0
 
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        do {
            let audioPath = Bundle.main.path(forResource: "song", ofType: "mp3")
            try audioPlay = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: audioPath!) as URL)
        } catch {
            //ERROR
        }
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.showAudioTime), userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showAudioTime() {
        let audioDuration = String(format: "%.2f", audioPlay.duration/60)
        let audioCurrentTime = Int((audioPlay.currentTime).truncatingRemainder(dividingBy: 60))
        /////////////******************
        //second is wrong, needs correction
        
        ///////////************
        if audioCurrentTime == 59 {
            second += 1
        }
        
        label.text = "||" + audioDuration + "||" + String(second) + " : " + String(audioCurrentTime)
    }
    
    @IBAction func play(_ sender: UIButton) {
        audioPlay.play()
        
    }

    @IBAction func pause(_ sender: UIButton) {
        audioPlay.pause()
    }
    
    
    @IBAction func replay(_ sender: UIButton) {
        audioPlay.currentTime = 0
        second = 0
        audioPlay.play()
    }
    
    @IBAction func speed(_ sender: UIButton) {
        audioPlay.currentTime += 2
        audioPlay.play()
    }
}

