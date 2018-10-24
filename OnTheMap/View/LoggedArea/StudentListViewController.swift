//
//  StudentListViewController.swift
//  OnTheMap
//
//  Created by Rafael Cunha on 23/10/2018.
//  Copyright © 2018 Rafael Cunha. All rights reserved.
//

import UIKit

class StudentListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Actions

    @IBAction func RefreshPressed(_ sender: Any) {
        getAllLocations()
    }

    // MARK: - Service

    func getAllLocations() {
        Loading(activate: true)
        StudentServiceManager.sharedInstance().getAllStudentsLocation(success: {(studentsLocation) in
            AllStudents.sharedInstance.allStudents.removeAll()
            AllStudents.sharedInstance.allStudents = studentsLocation
            DispatchQueue.main.async {
                self.Loading(activate: false)
                self.tableView.reloadData()
            }
        }, failure: {(serviceError) in
            self.DialogHelper(error: serviceError)
        }, completed: {
            self.Loading(activate: false)
        })
    }

    // MARK: - Models
    
    func DialogHelper(error: ServiceError) {
        let alert = UIAlertController(title: "Ops, Something went wrong", message: error.error, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    func Loading(activate: Bool) {
        self.view.isUserInteractionEnabled = !activate
        if activate {
            activityIndicator.startAnimating()
            self.view.alpha = 0.5
        } else {
            activityIndicator.stopAnimating()
            self.view.alpha = 1
        }
    }
    
}

extension StudentListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AllStudents.sharedInstance.allStudents.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "StudentTableViewCell")
            as? StudentTableViewCell else { return UITableViewCell() }
        cell.StudentNameLabel.text = AllStudents.sharedInstance.allStudents[indexPath.row].fullName()
        cell.selectionStyle = .none
        return cell
    }
}
