//
//  ViewControllerExtension.swift
//  OnTheMap
//
//  Created by Rafael Cunha de Oliveira on 29/10/18.
//  Copyright © 2018 Rafael Cunha. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    var activityTag: Int { return 999 }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
        view.frame.origin.y = 0
    }
    
    func Loading(activate: Bool) {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityIndicator.color = UIColor.black
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        self.view.isUserInteractionEnabled = !activate
        view.addSubview(activityIndicator)
        if activate {
            activityIndicator.tag = activityTag
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            self.view.alpha = 0.5
        } else {
            if let activityIndicator = self.view.subviews.filter(
                { $0.tag == self.activityTag}).first as? UIActivityIndicatorView {
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()
                self.view.alpha = 1
            }
        }
    }
    
    func DialogHelper(error: ServiceError) {
        let alert = UIAlertController(title: "Ops, Something went wrong", message: error.error, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true)
    }
}
