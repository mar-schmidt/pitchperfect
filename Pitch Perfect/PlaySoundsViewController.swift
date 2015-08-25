//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Marcus Ronélius on 2015-08-25.
//  Copyright (c) 2015 Ronelium Applications. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    var receivedAudio : RecordedAudio! // This is received from RecordSoundsViewController
    
    var audioPlayer : AVAudioPlayer!
    var audioEngine : AVAudioEngine!
    var audioFile : AVAudioFile!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        var error: NSError?
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: &error)
        audioPlayer.enableRate = true // Needed to be able to change the rate
        audioPlayer.volume = 1.0
        
        // This is needed for Chipmunk and Darthvadar effect since their using pitching effect which cannot be reached from normal AVAudioPlayer
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
    }
    
    
    @IBAction func playSlowAudio(sender: UIButton) {
        stopAudio(sender)
        // Rate will decrease speed of the sound
        audioPlayer.rate = 0.5
        // Force playback to start at the beginning
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }

    @IBAction func playFastAudio(sender: UIButton) {
        stopAudio(sender)
        // Rate will increase speed of the sound
        audioPlayer.rate = 2.0
        // Force playback to start at the beginning
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        // Stop and reset potential sounds to start from the beginning
        stopAudio(sender)
        // This will increase the pitch, making the sound higher
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func playDarthvaderAudio(sender: UIButton) {
        // Stop and reset potential sounds to start from the beginning
        stopAudio(sender)
        // This will lower down the pitch, making the sound darker
        playAudioWithVariablePitch(-1000)
    }
    
    
    func playAudioWithVariablePitch(pitch: Float) {
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        // Add pitching object to our engine, using the pitching value of the methods parameter
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        // Connect playerNode and pitching effect to audioEngine, scrambling everything together
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    
    
    @IBAction func stopAudio(sender: AnyObject) {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
