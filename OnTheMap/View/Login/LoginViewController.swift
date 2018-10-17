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

    // MARK: - Validations

    func validate() -> Bool{
        guard let userName = emailTextField.text, !userName.isEmpty else {
            return false
        }
        guard let password = passwordTextField.text, !password.isEmpty else {
            return false
        }
        return true
    }
    
    // MARK: - Service
    fileprivate func requestLogin(userName: String, password: String){
        activityIndicator.startAnimating()
        LoginServiceManager.sharedInstance().login(userName: userName,
                                                   password: password,
                                                   success: { (_key) in
                                                    
        }, failure: {(error) in
            self.activityIndicator.stopAnimating()
        }, completion: {
            self.activityIndicator.stopAnimating()
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
