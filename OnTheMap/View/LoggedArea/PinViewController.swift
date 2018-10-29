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

    @IBOutlet weak var locationTextField: UITextField!
    var location: CLLocation?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }

    func getLocation() {
        let geoCoder = CLGeocoder()
        let error = ServiceError(code: "404", error: "Location not found")
        guard let address = locationTextField.text else {
            DialogHelper(error: error)
            return
        }
        geoCoder.geocodeAddressString(address, completionHandler: { (placemarks, _) in
            guard let placemarks = placemarks,
                let location = placemarks.first?.location else {
                    self.DialogHelper(error: error)
                    return
            }
            self.location = location
            self.performSegue(withIdentifier: "goToFindLocation", sender: nil)
        })
    }

    
    @IBAction func findOnTheMap(_ sender: Any) {
        getLocation()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToFindLocation" {
            let vc = segue.destination as? FindLocationViewController
            vc?.addressPin = location
        }
    }
}

