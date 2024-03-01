//
//  TopicDetailView.swift
//  SpeakIt
//
//  Created by Prama Kusuma on 06/12/23.
//

import UIKit
import AVFoundation

class TopicDetailView : UIViewController {
    
    @IBOutlet weak private var topicSentenceStackView: UIStackView!
    @IBOutlet weak private var topicTitleLabel: UILabel!
    @IBOutlet weak private var topicImageView: UIImageView!
    
    @IBOutlet weak private var topicTitleNavLabel: UILabel!
    @IBOutlet weak private var topicDescriptionLabel: UILabel!
    @IBOutlet weak private var topicHeaderLabel: UILabel!
    
    @IBOutlet weak private var topicHeaderView: UIView!
    @IBOutlet weak private var speakLabel: UILabel!
    
    @IBOutlet weak private var sentenceLabel: UILabel!
    
    @IBOutlet weak private var guideLabel: UILabel!
    @IBOutlet weak private var sentenceResultLabel: UILabel!
    @IBOutlet weak private var accuracyLabel: UILabel!
    @IBOutlet weak private var resultLabel: UILabel!
    
    @IBOutlet weak private var topicProgressView: UIProgressView!
    @IBOutlet weak private var continueButton: UIButton!
    @IBOutlet weak var startSpeechButton: UIButton!
    
    private var isStart: Bool = false
    var topicId = ""
    var lessonId = ""
    
    private var lessonController = LessonController()
    private var speechController = SpeechController()
    private var userController = UserController()
    private var pronounciationData: [PronounciationModel]?
    private var counter = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //View
        topicHeaderView.layer.cornerRadius = 10
        topicProgressView.layer.borderWidth = 1
        topicProgressView.layer.borderColor = #colorLiteral(red: 1, green: 0.7354277968, blue: 0.5653079152, alpha: 1)
        topicProgressView.layer.cornerRadius = 5
        
        
        speechController.requestPermission()
        getAllPronounciation(topicId: self.topicId)
        getTopicDetail(topicId: self.topicId)
        
        self.guideLabel.text = "Click to begin"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToTopic" {
            let topicDetailView = segue.destination as! TopicView
            topicDetailView.lessonId = self.lessonId
        } else if segue.identifier == "goToTopicFinished" {
            let topicFinishedView = segue.destination as! TopicFinishedView
            topicFinishedView.topicId = self.topicId
            topicFinishedView.lessonid = self.lessonId
            
        }
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        if counter == 0 {
            goToTopic()
        } else {
            counter = counter - 1
            showPronounciation()
        }
    }
    
    
    @IBAction func playSpeechButton(_ sender: UIButton) {
        if pronounciationData?[counter].header != "" {
            let speechReference = pronounciationData?[counter].sentence
            speechController.playSentence(sentence: speechReference!)
        } else if pronounciationData?[counter].header == "" {
            let speechReference = pronounciationData?[counter].word
            speechController.playSentence(sentence: speechReference!)
        }
        
    }
    
    
    @IBAction func startSpeechButton(_ sender: UIButton) {
        
        let pulseEffect = LFTPulseAnimation(repeatCount: Float.infinity, radius:50, position:self.startSpeechButton.center)
        pulseEffect.name = "pulseEffect"
        view.layer.insertSublayer(pulseEffect, below: self.startSpeechButton.layer)
        
        self.isStart = !self.isStart
        
        if self.isStart {
            startSpeechRecognition()
        } else {
            view.layer.sublayers?.forEach {
                if $0 is LFTPulseAnimation {
                    $0.removeFromSuperlayer()
                }
            }
            cancelSpeechRecognition()
        }
        
    }
    
    
    @IBAction func continueButton(_ sender: UIButton) {
        if counter + 1 == pronounciationData!.count {
            updateProgress()
            goToTopicFinished()
        } else {
            counter += 1
            
            showPronounciation()
        }
    }
    
    func showPronounciation() {
        print("Pronounciation: \(pronounciationData![counter])")
        if pronounciationData?[counter].header != "" {
            self.topicHeaderView.isHidden = false
            self.topicTitleNavLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.topicTitleLabel.isHidden = false
            self.topicImageView.isHidden = false
            self.topicHeaderLabel.isHidden = false
            self.speakLabel.text = "Speak this sentence"
            self.topicHeaderLabel.text = pronounciationData?[counter].header
            self.sentenceLabel.text = pronounciationData?[counter].sentence
            self.sentenceResultLabel.text = ""
            self.resultLabel.text = ""
            self.accuracyLabel.text = "Accuracy: "
            
            //Display Progress Bar
            self.topicProgressView.progress = (Float(counter)+1) / (Float(pronounciationData!.count))
            print("Progress view : \(self.topicProgressView.progress)")
            print("Counter / Pronounciation Count : \(counter+1) / \(pronounciationData!.count)")
            

            self.continueButton.isEnabled = false
        } else if pronounciationData?[counter].header == "" {
            self.topicSentenceStackView.isHidden = true
            self.topicSentenceStackView.heightAnchor.constraint(equalToConstant: 0).isActive = true
            self.topicHeaderView.isHidden = true
            self.topicTitleLabel.isHidden = true
            self.topicImageView.isHidden = true
            self.topicDescriptionLabel.isHidden = true
            self.topicHeaderLabel.isHidden = true
            self.speakLabel.text = "Speak this word"
            
            self.sentenceLabel.text = pronounciationData?[counter].word
            self.sentenceResultLabel.text = ""
            self.resultLabel.text = ""
            self.accuracyLabel.text = "Accuracy: "
            
            //Display Progress Bar
            self.topicProgressView.progress = (Float(counter)+1) / (Float(pronounciationData!.count))
            print("Progress view : \(self.topicProgressView.progress)")
            print("Counter / Pronounciation Count : \(counter+1) / \(pronounciationData!.count)")
            
            self.continueButton.isEnabled = false
        }
        
    }
    
    
    func getTopicDetail(topicId: String) {
        lessonController.getTopicDetail(topicId: topicId) { (topicData) in
            var topicData = topicData
            print("TopicData: \(topicData)")
            self.topicTitleLabel.text = topicData.name
            self.topicTitleNavLabel.text = topicData.name
            let imageURL = URL(string: topicData.imageURL)
            URLSession.shared.dataTask(with: imageURL!) { (data, respose, error) in
                guard let imageData = data else { return }
                DispatchQueue.main.async {
                    self.topicImageView.image = UIImage(data: imageData)
                }
                
            }.resume()
            self.topicDescriptionLabel.text = topicData.description
        }
        
    }
    
    func getAllPronounciation(topicId: String) {
        lessonController.getAllPronounciation(topicId: topicId) { (pronounciationData) in
            self.pronounciationData = pronounciationData
            self.showPronounciation()
            print("PronounciationData: \(String(describing: self.pronounciationData))")
        }
    }
    
    func startSpeechRecognition() {
        self.sentenceResultLabel.text = ""
        speechController.startSpeechRecognition()
        self.guideLabel.text = "Go ahead, I'm listening. Click again to stop"
        print("speech started")
    }
    
    func cancelSpeechRecognition() {
        let speechMessage = speechController.cancelSpeechRecogniton()
        var speechReference = ""
        if pronounciationData?[counter].header != "" {
            speechReference = (pronounciationData?[counter].sentence)!
        } else if pronounciationData?[counter].header == "" {
            speechReference = (pronounciationData?[counter].word!)!
        }
        self.guideLabel.text = "Click to begin"
        self.sentenceResultLabel.text = speechMessage
        calculateSpeechAccuracy(message: speechMessage, reference: speechReference)
        print("speech stopped")
    }
    
    func getSpeechResult() {
        
    }
    
    func calculateSpeechAccuracy(message: String, reference: String) {
        let accuracy = speechController.calculateSpeechAccuracy(hyphotesis: message, reference: reference)
        self.accuracyLabel.text = "Accuracy: \(accuracy)%"
        calculateSpeechResult(accuracy: accuracy)
    }
    
    func calculateSpeechResult(accuracy: Int) {
        let result = speechController.calculateSpeechResult(accuracy: accuracy)
        self.resultLabel.text = result
        
        if result == "Try Again" {
            self.resultLabel.textColor = UIColor.red
            self.continueButton.isEnabled = false
        } else if result == "Good." {
            self.resultLabel.textColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
            self.continueButton.isEnabled = true
        } else if result == "Brilliant!" {
            self.resultLabel.textColor = UIColor.green
            self.continueButton.isEnabled = true
        }
    }
    
    func updateProgress() {
        userController.updateProgress(topicId: self.topicId)
    }
    
    func goToTopicFinished() {
        performSegue(withIdentifier: "goToTopicFinished", sender: self)
    }
    
    func goToTopic() {
        performSegue(withIdentifier: "goToTopic", sender: self)
    }
}
