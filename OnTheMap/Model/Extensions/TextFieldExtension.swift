//
//  TextFieldExtension.swift
//  OnTheMap
//
//  Created by Rafael Cunha de Oliveira on 29/10/18.
//  Copyright © 2018 Rafael Cunha. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController: UITextFieldDelegate {
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.text = ""
        return true
    }
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        view.frame.origin.y = 0
        return false
    }
}
