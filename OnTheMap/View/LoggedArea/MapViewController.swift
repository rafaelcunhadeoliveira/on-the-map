//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Rafael Cunha on 19/10/2018.
//  Copyright © 2018 Rafael Cunha. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var map: MKMapView!

    // MARK: - life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setInitialLocation()
    }

    // MARK: - layout

    func setInitialLocation() {
        guard let initialLocation = map.userLocation.location else { return }
        let regionRadius: CLLocationDistance = 1000
        func centerMapOnLocation(location: CLLocation) {
            let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                      regionRadius, regionRadius)
            map.setRegion(coordinateRegion, animated: true)
        }
        centerMapOnLocation(location: initialLocation)
    }
}
