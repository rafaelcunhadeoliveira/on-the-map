//
//  PinViewController.swift
//  OnTheMap
//
//  Created by Rafael Cunha on 25/10/2018.
//  Copyright © 2018 Rafael Cunha. All rights reserved.
//

import UIKit
import MapKit

class PinViewController: UIViewController {

    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    var location: CLPlacemark?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }

    func getLocation() {
        let geoCoder = CLGeocoder()
        let locationError = ServiceError(code: "404", error: "Location not found")
        let LinkError = ServiceError(code: "404", error: "Please, insert a link")
        Loading(activate: true)
        guard let address = locationTextField.text else {
            DialogHelper(error: locationError)
            return
        }
        geoCoder.geocodeAddressString(address, completionHandler: { (placemarks, _) in
            guard let placemarks = placemarks,
                let location = placemarks.first else {
                    self.DialogHelper(error: locationError)
                    return
            }
            self.location = location
            self.Loading(activate: false)
            if (self.linkTextField.text) != nil {
                self.performSegue(withIdentifier: "goToFindLocation", sender: nil)
            } else {
                self.DialogHelper(error: LinkError)
            }
        })
    }

    
    @IBAction func findOnTheMap(_ sender: Any) {
        getLocation()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToFindLocation" {
            let vc = segue.destination as? FindLocationViewController
            vc?.addressPin = location
            vc?.link = linkTextField.text ?? ""
            vc?.location = locationTextField.text ?? ""
        }
    }
}
