//
//  SpinnerView.swift
//  SpeakIt
//
//  Created by Prama Kusuma on 17/01/24.
//

import UIKit

class SpinnerView: UIViewController {
    var spinner = UIActivityIndicatorView(style: .large)
    var frame = UIView()
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor.clear
//        view.frame.size.width = 80
//        view.frame.size.height = 80
        
        frame.translatesAutoresizingMaskIntoConstraints = false
        frame.backgroundColor = UIColor.white
        view.addSubview(frame)
        frame.widthAnchor.constraint(equalToConstant: 100).isActive = true
        frame.heightAnchor.constraint(equalToConstant: 100).isActive = true
        frame.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        frame.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        frame.layer.cornerRadius = 20
        
        
        spinner.color = UIColor.orange
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        view.addSubview(spinner)

        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}
