//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Rafael Cunha on 25/09/2018.
//  Copyright © 2018 Rafael Cunha. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Service
    fileprivate func requestLogin(userName: String, password: String){
        
    }

    // MARK: - Actions
    @IBAction func loginButtonPressed(_ sender: Any) {
        
    }

    @IBAction func signUp(_ sender: Any) {
        
    }
}
