//
//  LessonModel.swift
//  SpeakIt
//
//  Created by Prama Kusuma on 26/11/23.
//

import Foundation

struct LessonModel {
    let id: String
    let name: String
    let topicCount: Int
    let imageURL: String
    
    init(id: String, name: String, topicCount: Int, imageURL: String) {
        self.id = id
        self.name = name
        self.topicCount = topicCount
        self.imageURL = imageURL
    }
}
