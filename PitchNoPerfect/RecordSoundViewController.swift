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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        enableRecording(true)
    }
    
    func enableRecording(_ record: Bool = true) {
        recordingBtn.isEnabled = record
        stopRecordingBtn.isEnabled = !record
        recordingLAbel.text = record ? "Tap to Record" : "Recording in Process"
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
        enableRecording()
        audioRecorder.stop()
        let session = AVAudioSession.sharedInstance()
        try! session.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "playSegue", sender: recorder.url)
        }
        else {
            let alertController = UIAlertController(title: "Error", message: "Could not save audio", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(action)
            present(alertController, animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "playSegue" {
            let soundController = segue.destination as! PlaySoundsViewController
            soundController.recordedAudioURL = sender as! URL
        }
    }
}

