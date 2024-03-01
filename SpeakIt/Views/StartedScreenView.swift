//
//  StartedScreenView.swift
//  SpeakIt
//
//  Created by Prama Kusuma on 16/11/23.
//

import UIKit

class StartedScreenView : UIViewController {
    private let userController = UserController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func startButton(_ sender: UIButton) {
        
        if userController.isUserLoggedIn() {
            goToHome()
        } else {
            goToLogin()
        }
    }
    
    func goToHome() {
        performSegue(withIdentifier: "goToHome", sender: self)
    }
    
    func goToLogin() {
        performSegue(withIdentifier: "goToLogin", sender: self)
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
        }
    }
    
    
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
