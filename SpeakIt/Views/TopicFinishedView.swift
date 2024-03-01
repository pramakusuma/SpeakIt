//
//  TopicFinishedView.swift
//  SpeakIt
//
//  Created by Prama Kusuma on 22/12/23.
//

import UIKit
import AVFoundation

class TopicFinishedView: UIViewController {
    @IBOutlet weak private var topicTitleLabel: UILabel!
    @IBOutlet weak private  var topicImageView: UIImageView!
    var topicId = ""
    var lessonid = ""
    private var lessonController = LessonController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getTopicDetail(topicId: topicId)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToTopic" {
            let topicView = segue.destination as! TopicView
            topicView.lessonId = self.lessonid
        }
    }
    
    @IBAction func finishButton(_ sender: UIButton) {
        goToTopic()
    }
    
    func goToTopic() {
        performSegue(withIdentifier: "goToTopic", sender: self)
    }
    
    func getTopicDetail(topicId: String) {
        lessonController.getTopicDetail(topicId: topicId) { (topicData) in
            self.topicTitleLabel.text = topicData.name
            let imageURL = URL(string: topicData.imageURL)
            URLSession.shared.dataTask(with: imageURL!) { (data, respose, error) in
                guard let imageData = data else { return }
                DispatchQueue.main.async {
                    self.topicImageView.image = UIImage(data: imageData)
                }
                
            }.resume()
        }
    }
}
