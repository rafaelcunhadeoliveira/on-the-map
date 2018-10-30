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
        self.hideKeyboardWhenTappedAround()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.subscribeForKeyboardNotifications()
        mock()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeForKeyboardNotifications()
    }

    // MARK: - Setup

    func subscribeForKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
    }
    func unsubscribeForKeyboardNotifications(){
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
    }

    //MARK: - Keyboard
    
    @objc func keyboardWillShow(_ notification: Notification){
        if self.passwordTextField.isFirstResponder{
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat{
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height/2
    }

    // MARK: - Validations

    func validate() -> Bool{
        var error = ServiceError.init(code: "404", error: "")
        guard let userName = emailTextField.text, !userName.isEmpty else {
            error.error = "User Name field is empty!"
            DialogHelper(error: error)
            return false
        }
        guard let password = passwordTextField.text, !password.isEmpty else {
            error.error = "Password field is empty!"
            DialogHelper(error: error)
            return false
        }
        return true
    }
    
    // MARK: - Service
    fileprivate func requestLogin(userName: String, password: String){
        Loading(activate: true)
        LoginServiceManager.sharedInstance().login(userName: userName,
                                                   password: password,
                                                   success: { (key) in
                                                    User.current.key = key
                                                    self.getUserInformation(key: key)
                                                    self.performSegue(withIdentifier: "LoginSegue", sender: nil)
        }, failure: {(error) in
            DispatchQueue.main.async {
                self.Loading(activate: false)
            }
            self.DialogHelper(error: error)
        }, completion: {
            DispatchQueue.main.async {
                self.Loading(activate: false)
            }
        })
    }

    fileprivate func getUserInformation(key: String) {
        StudentServiceManager.sharedInstance().getUserInformation(key: key,
                                                                  success: {(user) in
                                                                    User.current = user
        }, failure:{(error) in
            self.DialogHelper(error: error)
        }, completed: {
            //nothing to do
        })
    }

    // MARK: - Mock

    func mock() {
        emailTextField.text = "cunhadeoliveirarafael@gmail.com"
        passwordTextField.text = "Galodoido1313"
    }

    // MARK: - Actions
    @IBAction func loginButtonPressed(_ sender: Any) {
        if validate() {
            requestLogin(userName: emailTextField.text ?? "", password: passwordTextField.text ?? "")
        }
    }

    @IBAction func signUp(_ sender: Any) {
        guard let url = URL.init(string: Constants.udacityRegister()) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
