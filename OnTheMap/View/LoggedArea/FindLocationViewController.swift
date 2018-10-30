//
//  FindLocationViewController.swift
//  OnTheMap
//
//  Created by Rafael Cunha on 25/10/2018.
//  Copyright © 2018 Rafael Cunha. All rights reserved.
//

import UIKit
import MapKit

class FindLocationViewController: UIViewController {

    let regionRadius: CLLocationDistance = 10000
    var addressPin: CLPlacemark? = nil
    var location: String = ""
    var link: String = ""
    @IBOutlet weak var map: MKMapView!

    //MARK: - life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        centerMapOnLocation(placeMark: addressPin ?? CLPlacemark())
        insertPin()
    }

    //MARK: - Methods

    func insertPin() {
        guard let address = addressPin,
            let coordinate = address.location?.coordinate else { return }
        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        pin.title = address.name
        pin.subtitle = link
        map.addAnnotation(pin)
    }

    func centerMapOnLocation(placeMark: CLPlacemark) {
        guard let location = placeMark.location?.coordinate else { return }
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location,
                                                                  regionRadius, regionRadius)
        map.setRegion(coordinateRegion, animated: true)
    }

    // MARK: - Actions

    @IBAction func submitLocation(_ sender: Any) {
        registerPin()
    }

    // MARK: - Service

    func registerPin() {
        self.Loading(activate: true)
        guard let name = addressPin?.name,
        let latitude = addressPin?.location?.coordinate.latitude,
        let longitude = addressPin?.location?.coordinate.longitude else { return }
        LocationServiceManager.sharedInstance().createPin(map: name,
                                                          mediaURL: link,
                                                          latitude: latitude,
                                                          longitude: longitude,
                                                          success: { () in
                                                            self.backToMap()
        },
                                                          failure: {(error) in
                                                            self.DialogHelper(error: error)
        },
                                                          completed: {
                                                            self.Loading(activate: false)
        })
    }

    func backToMap() {
        let alert = UIAlertController(title: "", message: "Confirm your location?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: {(action) in
            self.navigationController?.popToRootViewController(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}

extension UIViewController: MKMapViewDelegate {
    public func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let string = view.annotation?.subtitle else { return }
        if let notOptionalString = string {
            let urlString = notOptionalString.contains("http") ? notOptionalString : "http://" + notOptionalString
            if let url = URL(string: urlString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
}
