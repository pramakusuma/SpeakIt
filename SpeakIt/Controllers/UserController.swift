//
//  ViewController.swift
//  SpeakIt
//
//  Created by Prama Kusuma on 15/11/23.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class UserController {

    var ref: DocumentReference? = nil
    let db = Firestore.firestore()
    
    func isUserLoggedIn() -> Bool {
        return Auth.auth().currentUser != nil
    }
    
    func login(email: String, password: String, Completion:@escaping (String) -> ()) {
        Auth.auth().signIn(withEmail: email, password: password) { user, error in
            if user != nil {
                Completion("Success")
            } else {
                Completion("Error")
            }
        }
    }
    
    func register(email: String, username: String, password: String, Completion:@escaping (String) -> ()) {
        var response = ""
        
            Auth.auth().createUser(withEmail: email, password: password) { user, error in
            if user != nil {
                let uid = Auth.auth().currentUser?.uid
                let userDetail = [
                    "email": email,
                    "username": username,
                    "progress": 0,
                    "topicDone": []
                ] as [String : Any]
                //Add data to UserModel
                self.db.collection("UserModel").document(uid!).setData(userDetail) { error in
                    if let error = error {
                        print("Error adding document: \(error)")
                    } else {
                        print("Document added succesfully")
                    }
                }
                Auth.auth().currentUser?.sendEmailVerification() {error in
                    if let error = error {
                        print("Error email verification: \(error)")
                    } else {
                        print("Email verification sent")
                    }
                }
                Completion("Success")
            } else  {
                Completion("Error")
            }
        }
        Completion(response)
    }
    
    func editProfile(email: String, username: String) {
        
        //Update Email
        let uid = Auth.auth().currentUser?.uid
        if email != "" {
            Auth.auth().currentUser?.updateEmail(to: email) {error in
                if let error = error {
                    print("Error update email: \(error)")
                } else {
                    print("Email updated successfully")
                }
            }
            
            //Update Username
            if username != "" {
                self.db.collection("UserModel").document(uid!).setData(["email": email, "username": username], merge: true) { error in
                    if let error = error {
                        print("Error adding document: \(error)")
                    } else {
                        print("Document edited succesfully")
                    }
                }
            } else {
                
            }
        } else {
            
        }
        
        
    }
    
    func resetPassword(Completion:@escaping (String) -> ()){

        getCurrentUser() { (uid, email, username, progress) in
            Auth.auth().sendPasswordReset(withEmail: email) {
                error in
                if error != nil {
                    Completion("Error")
                } else {
                    Completion("Success")
                }
            }
        }
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Sign out error")
        }
    }
    
    func getCurrentUser(Completion:@escaping (String, String, String, Int) -> ()) {
        let currentUserId = (Auth.auth().currentUser?.uid)
        if currentUserId != nil {
            db.collection("UserModel").document(currentUserId!).getDocument() { (querySnapshot, error) in
                if error != nil {
                    print("Error getting document: \(String(describing: error))")
                    return
                } else {
                    let currentEmail = querySnapshot?.get("email") as! String
                    let currentUsername = querySnapshot?.get("username") as! String
                    let currentProgress = querySnapshot?.get("progress") as! Int

                    Completion(currentUserId!, currentEmail, currentUsername, currentProgress)
                    print("\(currentUserId), \(currentEmail), \(currentUsername), \(currentProgress)")
                }
                
            }
        }
        

        
    }
    
    func updateProgress(topicId: String) {
        var topicDone: [String] = []
        let currentUserId = (Auth.auth().currentUser?.uid)
        db.collection("UserModel").document(currentUserId!).getDocument { QuerySnapshot, error in
            if error != nil {
                print("Error getting document: \(String(describing: error))")
                return
            } else {
                let currentTopicDone = QuerySnapshot?.get("topicDone") as! [String]
                topicDone = currentTopicDone
                if topicDone.contains(topicId) {
                    
                } else {
                    topicDone.append(topicId)
                    print("topicDone : \(topicDone)")
                    self.db.collection("UserModel").document(currentUserId!).setData(["progress": topicDone.count, "topicDone": topicDone], merge: true) { error in
                        if let error = error {
                            print("Error adding document: \(error)")
                        } else {
                            print("Document edited succesfully")
                        }
                    }
                }
                
            }
        }
        
        
        
        
    }
    
    func getProgress() {
        
    }
    
    
    
        
}

    



