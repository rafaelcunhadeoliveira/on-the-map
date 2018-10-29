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
    var addressPin: CLLocation? = nil
    var location: String = ""
    var link: String = ""
    @IBOutlet weak var map: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        centerMapOnLocation(location: addressPin ?? CLLocation())
        insertPin()
    }

    func insertPin() {
        guard let coordinate = addressPin?.coordinate else { return }
        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        pin.title = location
        pin.subtitle = link
        map.addAnnotation(pin)
    }

    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius, regionRadius)
        map.setRegion(coordinateRegion, animated: true)
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
