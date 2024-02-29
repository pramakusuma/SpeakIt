//
//  PronounciationModel.swift
//  SpeakIt
//
//  Created by Prama Kusuma on 06/12/23.
//

import Foundation

struct PronounciationModel {
    let id: String
    let topicId: String
    let header: String?
    let sentence: String?
    let word: String?
    
    init(id: String, topicId: String, header: String?, sentence: String?, word: String?) {
        self.id = id
        self.topicId = topicId
        self.header = header
        self.sentence = sentence
        self.word = word
    }
}
