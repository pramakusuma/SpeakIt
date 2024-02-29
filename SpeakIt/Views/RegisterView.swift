//
//  RegisterView.swift
//  SpeakIt
//
//  Created by Prama Kusuma on 16/11/23.
//

import UIKit

class RegisterView : UIViewController {
    @IBOutlet weak private var emailTextField: UITextField?
    @IBOutlet weak private var usernameTextField: UITextField?
    @IBOutlet weak private var passwordTextField: UITextField?
    @IBOutlet weak private var errorLabel: UILabel!
    
    private var email: String = ""
    private var username: String = ""
    private var password: String = ""
    
    private let userController = UserController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        //Text Field Editing
        emailTextField?.layer.borderWidth = 1
        emailTextField?.layer.cornerRadius = 10
        emailTextField?.layer.borderColor = #colorLiteral(red: 0.9773994088, green: 0.4668315053, blue: 0.02845485508, alpha: 1)
        emailTextField?.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        usernameTextField?.layer.borderWidth = 1
        usernameTextField?.layer.cornerRadius = 10
        usernameTextField?.layer.borderColor = #colorLiteral(red: 0.9773994088, green: 0.4668315053, blue: 0.02845485508, alpha: 1)
        usernameTextField?.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        passwordTextField?.layer.borderWidth = 1
        passwordTextField?.layer.cornerRadius = 10
        passwordTextField?.layer.borderColor = #colorLiteral(red: 0.9773994088, green: 0.4668315053, blue: 0.02845485508, alpha: 1)
        passwordTextField?.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
    }
    
    @IBAction func registerButton(_ sender: UIButton) {
        //Input Validation
        if checkRegisterField() {
            errorLabel.isHidden = true
            email = emailTextField!.text!
            username = usernameTextField!.text!
            password = passwordTextField!.text!
            register(email: email, username: username, password: password) { response in
                if response == "Success" {
                    self.createSpinnerView()
                    print("tologin")
                } else if response == "Error" {
                    self.errorLabel.isHidden = false
                    self.errorLabel.text = "Register Error, Please Try Again"
                    print("register error")
                }
            }
            
        } else {
            errorLabel.isHidden = false
            errorLabel.text = "All fields required"
            print("input required")
        }
        
        
    }
    
    
    @IBAction func loginButton(_ sender: UIButton) {
        goToLogin()
    }
    
    
    func goToLogin() {
        performSegue(withIdentifier: "goToLogin", sender: self)
    }
    
    func register(email: String, username: String, password: String, Completion:@escaping (String) -> ()) {
        userController.register(email: email, username: username, password: password) { response in
            Completion(response)
        }
    }
    
    func checkRegisterField() -> Bool {
        if emailTextField?.text != "" || usernameTextField?.text != "" || passwordTextField?.text != "" {
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
            self.goToLogin()
        }
    }
}
