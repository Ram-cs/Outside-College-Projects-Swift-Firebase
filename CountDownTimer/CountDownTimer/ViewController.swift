//
//  ViewController.swift
//  CountDownTimer
//
//  Created by Ram Yadav on 7/23/17.
//  Copyright © 2017 Ram Yadav. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    var audioPlayer = AVAudioPlayer()
    var seconds = 30
    var timer = Timer()
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var start: UIButton!
    @IBOutlet weak var stop: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        label.text = "30 Seconds"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        do {
            let audioPath = Bundle.main.path(forResource: "song", ofType: "mp3")
            try audioPlayer = AVAudioPlayer(contentsOf: URL(fileURLWithPath: audioPath!))
        } catch {
            //ERROR
        }
    }
    
    
    func action () { //ACTION
        seconds -= 1
        label.text = String(seconds) + " Seconds"
        if seconds == 0 {
            timer.invalidate()
            audioPlayer.play()
        }
        start.isHidden = true
        slider.isHidden = true
    }
    
    @IBAction func slidePressed(_ sender: UISlider) { //SLIDER
        seconds = Int(sender.value)
        label.text = String(seconds) + " Seconds"
    }
    
    @IBAction func start(_ sender: UIButton) { //START
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.action), userInfo: nil, repeats: true)
    }

    @IBAction func stop(_ sender: UIButton) { //STOP
        seconds = 30
        label.text = String(seconds) + " Seconds"
        start.isHidden = false
        slider.isHidden = false
        timer.invalidate()
        slider.setValue(30, animated: true)
        audioPlayer.stop()
    }
}

