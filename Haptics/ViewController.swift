//
//  ViewController.swift
//  Haptics
//
//  Created by yc on 2/12/24.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var touchView: TouchView!
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var intensitySlider: UISlider!
    @IBOutlet weak var sharpnessSlider: UISlider!
    
    @IBOutlet weak var intensityValueLabel: UILabel!
    @IBOutlet weak var sharpnessValueLabel: UILabel!
    
    var intensityValue: Float = 0.5
    var sharpnessValue: Float = 0.5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func didChangeSliderValue(_ sender: UISlider) {
        let value = floor(sender.value * 10.0) / 10.0
        
        sender.value = value
        
        if sender == intensitySlider {
            intensityValue = sender.value
            intensityValueLabel.text = "\(sender.value)"
        } else {
            sharpnessValue = sender.value
            sharpnessValueLabel.text = "\(sender.value)"
        }
    }
    
    @IBAction func didTapRecordButton(_ sender: UIButton) {
        if sender.titleLabel?.text == "Record" {
            sender.setTitle("Stop", for: .normal)
            
            touchView.startRecording()
            playButton.isEnabled = false
        } else {
            sender.setTitle("Record", for: .normal)
            
            touchView.stopRecording()
            playButton.isEnabled = true
        }
    }
    
    @IBAction func didTapPlayButton(_ sender: UIButton) {
        if sender.titleLabel?.text == "Play" {
            sender.setTitle("Stop", for: .normal)
            
            let haptics = touchView.getResult()
            VibrationManager.shared?.playHaptic(haptics: haptics, intense: intensityValue, sharp: sharpnessValue)
        } else {
            sender.setTitle("Play", for: .normal)
            
            VibrationManager.shared?.stopHapric()
        }
        
    }
}
