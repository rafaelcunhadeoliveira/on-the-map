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
    var pinExists: Bool = false
    
    // MARK: - life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        getAllLocations()
    }

    // MARK: - layout

    func insertAllStudentsOnMap(locations: [StudentLocation]){
        for location in locations {
            insertPin(location: location)
        }
    }
    
    // MARK: - Service

    func getAllLocations() {
        Loading(activate: true)
        StudentServiceManager.sharedInstance().getAllStudentsLocation(success: {(studentsLocation) in
            AllStudents.sharedInstance.allStudents.removeAll()
            DispatchQueue.main.async {
                self.Loading(activate: false)
            }
            if studentsLocation.count > 0 {
                AllStudents.sharedInstance.allStudents = studentsLocation
                DispatchQueue.main.async {
                    self.insertAllStudentsOnMap(locations: studentsLocation)
                }
            } else {
                self.removeAllPins()
            }
        }, failure: {(serviceError) in
            self.DialogHelper(error: serviceError, type: .basicError)
        }, completed: {
            self.Loading(activate: false)
        })
    }

    func getCurrentLocation(success: @escaping ()-> Void) {
        Loading(activate: true)
        LocationServiceManager.sharedInstance().getUserLocation(success: { (locations) in
            DispatchQueue.main.async {
                self.Loading(activate: false)
            }
            self.pinExists = User.current.location != nil
            if let location = locations.first{
                User.current.location = location
            }
            success()
            
        }, failure: { (errorResponse) in
            DispatchQueue.main.async {
                self.Loading(activate: false)
            }
            self.DialogHelper(error: errorResponse, type: .basicError)
        }, completed: {
        })
    }

    // MARK: - Actions

    @IBAction func RefreshButton(_ sender: Any) {
        removeAllPins()
        getAllLocations()
    }
    
    @IBAction func insertPinButton(_ sender: Any) {
        if validate() {
            self.DialogHelper(type: .overwriteError)
        } else {
            self.nextViewController()
        }
    }
    // MARK: - Map

    func insertPin(location: StudentLocation) {
        guard let latitude = location.latitude,
            let longitude = location.longitude else { return }
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = location.fullName()
        annotation.subtitle = location.mediaUrl
        map.addAnnotation(annotation)
    }

    func removeAllPins() {
        map.removeAnnotations(map.annotations)
    }

    // MARK: - Validations

    func validate() -> Bool{
        let currentStudent = AllStudents.sharedInstance.allStudents.filter{
            $0.uniqueKey == User.current.key}
        return currentStudent.isEmpty
    }

    // MARK: - Methods

    func nextViewController() {
        if let viewController = UIStoryboard(name: Constants.storyboardName(),
                                             bundle: nil).instantiateViewController(withIdentifier: "PinViewController")
            as? PinViewController {
            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
            }
        }
    }

    // MARK: - Models
    
    func DialogHelper(error: ServiceError = ServiceError(), type: errorType = .basicError) {
        let alert = type == .basicError ? basicDialogHelper(error: error) : overwriteDialogHelper()
        self.present(alert, animated: true)
    }

    func basicDialogHelper(error: ServiceError) -> UIAlertController {
        let alert = UIAlertController(title: "Ops, Something went wrong", message: error.error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    
        return alert
    }

    func overwriteDialogHelper() -> UIAlertController {
        let alert = UIAlertController(title: "", message: "You have already posted a student location. Would you like to overwrite your current location?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Overwrite", style: .default, handler: {(action) in
            self.nextViewController()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        return alert
    }
}
