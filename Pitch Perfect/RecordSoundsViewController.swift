//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Marcus Ronélius on 2015-08-23.
//  Copyright (c) 2015 Ronelium Applications. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    
    var audioRecorder : AVAudioRecorder!
    var recordedAudio : RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        recordingViewAvailableWithText("Tap to record")
    }

    @IBAction func recordAudio(sender: UIButton) {
        println("Recording...");
        recordingViewIsRecording()
        
        // Declare the path of where we'll save our soundfile
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        
        // The name of the soundfile. NOTE: will be overwritten everytime we start a new recording
        let recordingName = "my_audio.wav"
        // Put together the path and filename and make an NSURL of it
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        // Notify audioRecorder where we want to save our file. Then start recording
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()

    }

    @IBAction func stopRecordingAudio(sender: UIButton) {
        println("Stopped recording");
        recordingInProgress.text = "Saving..."; recordingInProgress.textColor = UIColor.blackColor()
        
        // Stop the recording and inactivate the session of singleton audioSession
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
    

    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if (flag) {
            // If successfully finished recording, init our recordedAudio object and assign its filePathUrl and title to properties gotten from the provided AVAudioRecorder object
            recordedAudio = RecordedAudio()
            recordedAudio.filePathUrl = recorder.url
            recordedAudio.title = recorder.url.lastPathComponent
            
            // Initiate the segue sequence that eventually will send this recording for playback in PlaySoundsViewController
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        } else {
            println("Recording failed...")
            recordingViewAvailableWithText("Recording failed, try again")
        }
    }
    
    func recordingViewAvailableWithText(text: String) {
        stopButton.hidden = true
        recordButton.enabled = true
        recordingInProgress.text = text; recordingInProgress.textColor = UIColor.blackColor()
    }
    
    func recordingViewIsRecording() {
        recordingInProgress.text = "Recording..."; recordingInProgress.textColor = UIColor.redColor()
        stopButton.hidden = false
        recordButton.enabled = false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            // PlaySoundsViewController is our designated viewcontroller for this segue
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            
            // Save the recorded date in RecordedAudio object and send it to PlaySoundsViewController
            let recordedData = sender as! RecordedAudio
            playSoundsVC.receivedAudio = recordedData
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}