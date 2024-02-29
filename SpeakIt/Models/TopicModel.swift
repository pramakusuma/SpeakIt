//
//  TopicModel.swift
//  SpeakIt
//
//  Created by Prama Kusuma on 28/11/23.
//

import Foundation

struct TopicModel {
    let id: String
    let lessonId: String
    let name: String
    let description: String
    let pronounciationCount: Int
    let imageURL: String
    let difficulity: String
    
    init(id: String, lessonId: String, name: String, description: String, pronounciationCount: Int, imageURL: String, difficulity: String) {
        self.id = id
        self.lessonId = lessonId
        self.name = name
        self.description = description
        self.pronounciationCount = pronounciationCount
        self.imageURL = imageURL
        self.difficulity = difficulity
    }
}
