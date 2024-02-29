//
//  UserModel.swift
//  SpeakIt
//
//  Created by Prama Kusuma on 16/11/23.
//

import Foundation

struct UserModel {
    let id: String
    let email : String
    let username: String
    let progress: Int
    let topicDone: [String]
    
    init(id: String, email: String, username: String, progress: Int, topicDone: [String]) {
        self.id = id
        self.email = email
        self.username = username
        self.progress = progress
        self.topicDone = topicDone
    }
    

}
