//
//  ViewController.swift
//  PitchNoPerfect
//
//  Created by Francis Gutierrez on 5/29/17.
//  Copyright © 2017 Francis Gutierrez. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingLAbel: UILabel!
    @IBOutlet weak var recordingBtn: UIButton!
    @IBOutlet weak var stopRecordingBtn: UIButton!
    
    var audioRecorder : AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        enableRecording(true)
    }
    
    func enableRecording(_ record: Bool) {
        self.recordingBtn.isEnabled = record
        self.stopRecordingBtn.isEnabled = !record
        
        if record {
            recordingLAbel.text = "Tap to Record"
        } else {
            recordingLAbel.text = "Recording in Process"
        }
    }

    @IBAction func recordAudio(_ sender: Any) {
        enableRecording(false)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }

    @IBAction func stopRecording(_ sender: Any) {
        enableRecording(true)
        audioRecorder.stop()
        let session = AVAudioSession.sharedInstance()
        try! session.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "playSegue", sender: recorder.url)
        }
        else {
            print("could not save the audio")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "playSegue" {
            let soundController = segue.destination as! PlaySoundsViewController
            soundController.recordedAudioURL = sender as! URL
        }
    }
}

