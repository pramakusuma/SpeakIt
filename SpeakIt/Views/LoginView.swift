//
//  LoginView.swift
//  SpeakIt
//
//  Created by Prama Kusuma on 16/11/23.
//

import UIKit
import Firebase

class LoginView : UIViewController {
    @IBOutlet weak private var emailTextField: UITextField!
    @IBOutlet weak private var passwordTextField: UITextField!
    @IBOutlet weak private var errorLabel: UILabel!
    
    private var email: String = ""
    private var password: String = ""
    
    private let userController = UserController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()

        //Text Field Editing
        emailTextField.layer.borderWidth = 1
        emailTextField.layer.cornerRadius = 10
        emailTextField.layer.borderColor = #colorLiteral(red: 0.9773994088, green: 0.4668315053, blue: 0.02845485508, alpha: 1)
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        passwordTextField.layer.borderWidth = 1
        passwordTextField.layer.cornerRadius = 10
        passwordTextField.layer.borderColor = #colorLiteral(red: 0.9773994088, green: 0.4668315053, blue: 0.02845485508, alpha: 1)
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        
        
       
        
    }
    @IBAction func loginButton(_ sender: UIButton) {
        
        //validasi input
        if checkLoginField() {
            errorLabel.isHidden = true
            email = emailTextField.text!
            password = passwordTextField.text!
            login(email: email, password: password) {response in
                print("login response: \(response)")
                if response == "Success" {
                    self.createSpinnerView()
                } else if response == "Error" {
                    self.errorLabel.isHidden = false
                    self.errorLabel.text = "Username or Password incorrect"
                    print("Login Error")
                }
            }
            
        } else {
            errorLabel.isHidden = false
            errorLabel.text = "All fields required"
            print("input required")
        }
        
        
    }
    @IBAction func registerButton(_ sender: UIButton) {
        goToRegister()
    }
    
    
    
    func goToRegister() {
        performSegue(withIdentifier: "goToRegister", sender: self)
    }
    
    func goToHome() {
        performSegue(withIdentifier: "goToHome", sender: self)
    }
    
    func login(email: String, password: String, Completion:@escaping (String) -> ()) {
        userController.login(email: email, password: password) { response in
            Completion(response)
        }
        
    }
    
    func checkLoginField() -> Bool {
        if emailTextField.text != "" || emailTextField.text != "" {
            return true
        } else {
            return false
        }
    }
    
    func createSpinnerView() {
        let child = SpinnerView()
        
        print("Run Spinner")
        
        addChild(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
            self.goToHome()
        }
    }
}
