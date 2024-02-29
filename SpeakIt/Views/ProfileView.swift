//
//  ProfileView.swift
//  SpeakIt
//
//  Created by Prama Kusuma on 16/11/23.
//

import UIKit



class ProfileView : UIViewController {
    @IBOutlet weak private var emailTextField: UITextField!
    @IBOutlet weak private var usernameTextField: UITextField!
    @IBOutlet weak private var errorLabel: UILabel!
    
    private let userController = UserController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        getCurrentUser()
        
        //Text Field Editing
        emailTextField?.layer.borderWidth = 1
        emailTextField?.layer.cornerRadius = 10
        emailTextField?.layer.borderColor = #colorLiteral(red: 0.9773994088, green: 0.4668315053, blue: 0.02845485508, alpha: 1)
        
        usernameTextField?.layer.borderWidth = 1
        usernameTextField?.layer.cornerRadius = 10
        usernameTextField?.layer.borderColor = #colorLiteral(red: 0.9773994088, green: 0.4668315053, blue: 0.02845485508, alpha: 1)
        
        
        if emailTextField?.text != "" || usernameTextField?.text != "" {
            emailTextField?.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
            usernameTextField?.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        }
        
    }
    
    @IBAction func saveButton(_ sender: UIButton) {
        if emailTextField.text != "" || usernameTextField.text != "" {
            userController.editProfile(email: emailTextField.text!, username: usernameTextField.text!)
            goToHome()
        } else {
            //All fields required
            errorLabel.text = "All Fields Required"
            errorLabel.isHidden = false
            print("All fields required")
        }
        
    }
    
    @IBAction func logoutButton(_ sender: UIButton) {
        userController.logout()
        goToLogin()
    }
    
    @IBAction func resetPasswordButton(_ sender: Any) {
        userController.resetPassword { (response) in
            if response == "Success" {
                self.errorLabel.text = "Password Reset Corfirmation Sent"
                self.errorLabel.isHidden = false
            } else if response == "Error" {
                self.errorLabel.text = "Password Reset Error"
                self.errorLabel.isHidden = false
            }
        }
    }
    
    @IBAction func backButton(_ sender: UIButton) {
       goToHome()
    }
    
    func goToLogin() {
        performSegue(withIdentifier: "goToLogin", sender: self)
    }
    
    func goToHome() {
        performSegue(withIdentifier: "goToHome", sender: self)
    }
    
    func getCurrentUser() {
        userController.getCurrentUser() {(uid, email, username, progress) in
            self.emailTextField.text = email
            self.usernameTextField.text = username
            print("Email: \(email)")
            print("Username: \(username)")
        }

        
    }
}
