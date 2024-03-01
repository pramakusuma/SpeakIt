//
//  LessonController.swift
//  SpeakIt
//
//  Created by Prama Kusuma on 24/11/23.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseFirestore

class LessonController {
    var ref: DocumentReference? = nil
    let db = Firestore.firestore()
    
    
    func getAllLesson(Completion:@escaping ([LessonModel]) -> ()) {
        var lessonData = [LessonModel]()
        self.db.collection("LessonModel").getDocuments() { (querySnapshot, error) in
            if error != nil {
                print("Error getting document: \(String(describing: error))")
                return
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let id = document.documentID
                    let name = data["name"] as? String ?? ""
                    let imageURL = data["imageURL"] as? String ?? ""
                    let topicCount = data["topicCount"] as? Int ?? 0
                    let newLesson = LessonModel(id: id, name: name, topicCount: topicCount, imageURL: imageURL)
                    lessonData.append(newLesson)
                    Completion(lessonData)
                    print("lesson data db: \(lessonData)")
                }
            }
        }
        
    }
    
    func getAllTopic(lessonId: String, Completion:@escaping ([TopicModel]) -> ()) {
        var topicData = [TopicModel]()
        self.db.collection("TopicModel").order(by: "lessonId").whereField("lessonId", isEqualTo: lessonId).getDocuments() { (querySnapshot, error) in
            if error != nil {
                print("Error getting document: \(String(describing: error))")
                return
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let id = document.documentID
                    let lessonId = data["lessonId"] as? String ?? ""
                    let name = data["name"] as? String ?? ""
                    let description = data["description"] as? String ?? ""
                    let difficulity = data["difficulity"] as? String ?? ""
                    let imageURL = data["imageURL"] as? String ?? ""
                    let pronounciationCount = data["pronounciationCount"] as? Int ?? 0
                    let newTopic = TopicModel(id: id, lessonId: lessonId, name: name, description: description, pronounciationCount: pronounciationCount, imageURL: imageURL, difficulity: difficulity)
                    topicData.append(newTopic)
                    Completion(topicData)
                    print("topic data db: \(topicData)")
                }
                
            }
            
        }
    }
    
    func getLessonDetail(lessonId: String, Completion:@escaping (LessonModel) -> ()) {
        self.db.collection("LessonModel").getDocuments() { querySnapshot, error in
            if error != nil {
                print("Error getting document: \(String(describing: error))")
                return
            } else {
                for document in querySnapshot!.documents {
                    if document.documentID == lessonId {
                        let data = document.data()
                        let id = document.documentID
                        let name = data["name"] as? String ?? ""
                        let imageURL = data["imageURL"] as? String ?? ""
                        let topicCount = data["topicCount"] as? Int ?? 0
                        let newLesson = LessonModel(id: id, name: name, topicCount: topicCount, imageURL: imageURL)
                        Completion(newLesson)
                    }
                }
            }
        }
    }
    
    func getTopicDetail(topicId: String ,Completion:@escaping (TopicModel) -> ()) {
        self.db.collection("TopicModel").getDocuments { querySnapshot, error in
            if error != nil {
                print("Error getting document: \(String(describing: error))")
                return
            } else {
                for document in querySnapshot!.documents {
                    if document.documentID == topicId {
                        let data = document.data()
                        let id = document.documentID
                        let lessonId = data["lessonId"] as? String ?? ""
                        let name = data["name"] as? String ?? ""
                        let description = data["description"] as? String ?? ""
                        let difficulity = data["difficulity"] as? String ?? ""
                        let imageURL = data["imageURL"] as? String ?? ""
                        let pronounciationCount = data["pronounciationCount"] as? Int ?? 0
                        let newTopic = TopicModel(id: id, lessonId: lessonId, name: name, description: description, pronounciationCount: pronounciationCount, imageURL: imageURL, difficulity: difficulity)
                        Completion(newTopic)
                    }
                    
                }
            }
        }
    }
    
    func getAllPronounciation(topicId: String, Completion:@escaping ([PronounciationModel]) -> ()) {
        var pronounciationData = [PronounciationModel]()
        self.db.collection("PronounciationModel").getDocuments { querySnapshot, error in
            if error != nil {
                print("Error getting document: \(String(describing: error))")
                return
            } else {
                for document in querySnapshot!.documents {
                    if document.data()["topicId"] as! String == topicId {
                        let data = document.data()
                        let id = document.documentID
                        let topicId = data["topicId"] as? String ?? ""
                        let header = data["header"] as? String ?? ""
                        let sentence = data["sentence"] as? String ?? ""
                        let word = data["word"] as? String ?? ""
                        let newPronounciation = PronounciationModel(id: id, topicId: topicId, header: header, sentence: sentence, word: word)
                        pronounciationData.append(newPronounciation)
                        
                    }
                    
                }
                Completion(pronounciationData)
            }
        }
    }
}
