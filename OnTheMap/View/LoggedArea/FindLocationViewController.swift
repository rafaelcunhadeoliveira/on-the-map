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

    let regionRadius: CLLocationDistance = 1000
    var addressPin: CLLocation? = nil

    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var map: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        centerMapOnLocation(location: addressPin ?? CLLocation())
    }

    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius, regionRadius)
        map.setRegion(coordinateRegion, animated: true)
    }


}
