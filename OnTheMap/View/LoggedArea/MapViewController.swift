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
            self.DialogHelper(error: serviceError)
        }, completed: {
            self.Loading(activate: false)
        })
    }

    // MARK: - Actions

    @IBAction func RefreshButton(_ sender: Any) {
        removeAllPins()
        getAllLocations()
    }
    
    @IBAction func logoutButton(_ sender: Any) {
        self.Loading(activate: true)
        StudentServiceManager.sharedInstance().logout(success: {() in
            self.Loading(activate: false)
            self.nextViewController(isLogout: true)
        }, failure: {(error) in
            self.DialogHelper(error: error)
        }, completed: {
            self.Loading(activate: false)
        })
    }

    
    @IBAction func insertPinButton(_ sender: Any) {
        if validate() {
            self.overwriteDialogHelper()
        } else {
            self.nextViewController(isLogout: false)
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

    func nextViewController(isLogout: Bool) {
        let viewControllerString = isLogout ? "LoginViewController" : "PinViewController"
        let viewController = UIStoryboard(name: Constants.storyboardName(),
                                          bundle: nil).instantiateViewController(withIdentifier: viewControllerString)
        if isLogout {
            self.present(viewController, animated: false, completion: nil)
        } else {
            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
            }
        }
        
    }

    // MARK: - Models

    func overwriteDialogHelper() {
        let alert = UIAlertController(title: "", message: "You have already posted a student location. Would you like to overwrite your current location?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Overwrite", style: .default, handler: {(action) in
            self.nextViewController(isLogout: false)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}
