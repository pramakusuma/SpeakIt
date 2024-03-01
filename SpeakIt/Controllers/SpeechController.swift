//
//  SpeechController.swift
//  SpeakIt
//
//  Created by Prama Kusuma on 24/11/23.
//

import UIKit
import Firebase
import AVFoundation
import Speech

class SpeechController: NSObject, ObservableObject, SFSpeechRecognizerDelegate, AVSpeechSynthesizerDelegate {
    let audioEngine = AVAudioEngine()
    let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
    var request: SFSpeechAudioBufferRecognitionRequest?
    var task: SFSpeechRecognitionTask?
    var isEnabled = false
    var isStart: Bool = false
    
    let synthesizer = AVSpeechSynthesizer()
    var speechMessage = ""
    
    func requestPermission() {
        SFSpeechRecognizer.requestAuthorization { (authState) in
            OperationQueue.main.addOperation {
                if authState == .authorized {
                    print("Permission Allowed")
                    self.isEnabled = true
                } else if authState == .denied {
                    print("Permission Denied")
                } else if authState == .notDetermined {
                    print("No Speech Recognition Found")
                } else if authState == .restricted {
                    print("Permission restricted")
                }
            }
        }
        
        switch AVAudioSession.sharedInstance().recordPermission {
            case AVAudioSession.RecordPermission.granted:
                print("Permission granted")
            case AVAudioSession.RecordPermission.denied:
                print("Pemission denied")
            case AVAudioSession.RecordPermission.undetermined:
                print("Request permission here")
                AVAudioSession.sharedInstance().requestRecordPermission({ (granted) in
                    // Handle granted
                })
        @unknown default:
            print("Permission unknown")
        }
    }
    
    func startSpeechRecognition() {
        self.speechMessage = ""
        if let task = task {
            task.cancel()
            self.task = nil
        }
        
        // Audio session, to get information from the microphone.
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch let error as NSError {
            print("Error : ", error.localizedDescription)
        }
        let inputNode = audioEngine.inputNode
        _ = audioEngine.outputNode
        
        request = SFSpeechAudioBufferRecognitionRequest()
        guard let request = request else {
            fatalError("Unable to created a SFSpeechAudioBufferRecognitionRequest object")
        }
        request.shouldReportPartialResults = true
        
        //Check Availability
        guard let recognization = SFSpeechRecognizer() else {
            print("Speech recognition not allowed")
            return
        }
        
        if !recognization.isAvailable {
            print("Speech recognition not available")
        }
        
        speechRecognizer.delegate = self

        //Recognition Task
        task = speechRecognizer.recognitionTask(with: request) { response, error in
            var isFinal = false
            
            
            if let response = response {
                //Result Message
                self.speechMessage = response.bestTranscription.formattedString
                print("Speech result: \(self.speechMessage)")
                isFinal = response.isFinal
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.request = nil
                self.task = nil
                
            }
        }
        
        //Configure Microphone
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        if recordingFormat.sampleRate == 0.0 {
            return
        }
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.request?.append(buffer)
        }
        
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch let error {
            print("Error : \(error.localizedDescription)")
        }
 
    }
    
    func cancelSpeechRecogniton() -> String {
        task?.finish()
        task?.cancel()
        task = nil
        
        request?.endAudio()
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        
        return speechMessage
    }
    
    
    func playSentence(sentence: String) {
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playback, mode: .moviePlayback)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch let error as NSError {
            print("Error : ", error.localizedDescription)
        }

        let utterance = AVSpeechUtterance(string: sentence)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.57
        utterance.pitchMultiplier = 0.8
        utterance.postUtteranceDelay = 0.2
        utterance.volume = 0.8
        
        
        synthesizer.delegate = self
        synthesizer.speak(utterance)
    }
    
    func calculateSpeechAccuracy(hyphotesis: String, reference: String) -> Int {
        
        //Split sentence into array
        var hyphotesisArr = hyphotesis.lowercased().components(separatedBy: [".", ",", "?", "!"]).joined(separator: "").components(separatedBy: " ")
        var referenceArr = reference.lowercased().components(separatedBy: [".", ",", "?", "!"]).joined(separator: "").components(separatedBy: " ")
        
        if hyphotesisArr.count == 1 && referenceArr.count == 1 {
            //Split word into array
            hyphotesisArr = hyphotesis.lowercased().map { String($0) }
            referenceArr = reference.lowercased().map { String($0) }
        }
        
        
        let distance = levenshteinDistance(hyphotesisArr, referenceArr)
        let totalWords = referenceArr.count
        
        print("Speech Accuracy: \nHypotesis: \(hyphotesisArr)\nReference: \(referenceArr)\nDistance: \(distance)")
        
        let wer = Double(distance) / Double(totalWords)
        let accuracy = Int((1.0 - wer)*100)
        print("WER: \(wer)")
        print("Accuracy: \(accuracy)")
        if accuracy < 0 {
            return 0
        } else {
            return accuracy
        }
        
    }
    
    func levenshteinDistance<T: Equatable>(_ lhs: [T], _ rhs: [T]) -> Int {
        var dp = Array(repeating: Array(repeating: 0, count: rhs.count + 1), count: lhs.count + 1)

        for i in 0...lhs.count {
            for j in 0...rhs.count {
                if i == 0 {
                    dp[i][j] = j
                } else if j == 0 {
                    dp[i][j] = i
                } else if lhs[i - 1] == rhs[j - 1] {
                    dp[i][j] = dp[i - 1][j - 1]
                } else {
                    dp[i][j] = 1 + min(dp[i][j - 1], dp[i - 1][j], dp[i - 1][j - 1])
                }
            }
        }

        return dp[lhs.count][rhs.count]
    }
    
    
    
    func calculateSpeechResult(accuracy: Int) -> String {
        var message = ""
        
        if accuracy <= 50 {
            message = "Try Again"
        } else if accuracy <= 80 {
            message = "Good."
        } else if accuracy <= 100 {
            message = "Brilliant!"
        }
        
        return message
    }
}
