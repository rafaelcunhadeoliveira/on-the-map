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
    }

    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
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
            self.DialogDefinition(error: serviceError, type: .basicError)
        }, completed: {
            self.Loading(activate: false)
        })
    }

    // MARK: - Actions

    @IBAction func RefreshButton(_ sender: Any) {
        removeAllPins()
        getAllLocations()
    }
    
    @IBAction func insertPinButton(_ sender: Any) {
        if validate() {
            self.DialogDefinition(type: .overwriteError)
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
        return !currentStudent.isEmpty
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
    
    func DialogDefinition(error: ServiceError = ServiceError(), type: errorType = .basicError) {
        if type == .basicError {
            self.DialogHelper(error: error)
        } else {
            overwriteDialogHelper()
        }
    }

    func overwriteDialogHelper() {
        let alert = UIAlertController(title: "", message: "You have already posted a student location. Would you like to overwrite your current location?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Overwrite", style: .default, handler: {(action) in
            self.nextViewController()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}
