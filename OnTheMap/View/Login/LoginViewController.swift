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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.subscribeForKeyboardNotifications()

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

    // MARK: - Models

    func DialogHelper(error: ServiceError) {
        let alert = UIAlertController(title: "Ops, Something went wrong", message: error.error, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true)
    }

    func Loading(activate: Bool) {
        self.view.isUserInteractionEnabled = !activate
        if activate {
            activityIndicator.startAnimating()
            self.view.alpha = 0.5
        } else {
            activityIndicator.stopAnimating()
            self.view.alpha = 1
        }
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
                                                   success: { (_key) in
                                                    self.performSegue(withIdentifier: "LoginSegue", sender: nil)
        }, failure: {(error) in
            let error = ServiceError.init(code: "404", error: "Invalid user or password")
            self.DialogHelper(error: error)
        }, completion: {
            self.Loading(activate: false)
        })
    }

    // MARK: - Actions
    @IBAction func loginButtonPressed(_ sender: Any) {
        if validate() {
            requestLogin(userName: emailTextField.text ?? "", password: passwordTextField.text ?? "")
        }
    }

    @IBAction func signUp(_ sender: Any) {
        
    }
}
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        view.frame.origin.y = 0
        return false
    }
}
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
        view.frame.origin.y = 0
    }
}
