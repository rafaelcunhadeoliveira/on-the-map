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
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        getAllLocations()
    }

    // MARK: - Actions

    @IBAction func RefreshPressed(_ sender: Any) {
        getAllLocations()
    }

    @IBAction func addPin(_ sender: Any) {
        if validate() {
            self.DialogHelper(type: .overwriteError)
        } else {
            self.nextViewController(isLogout: false)
        }
    }

    @IBAction func logoutButton(_ sender: Any) {
        self.Loading(activate: true)
        StudentServiceManager.sharedInstance().logout(success: {() in
            self.nextViewController(isLogout: true)
        }, failure: {(error) in
            self.DialogHelper(error: error)
        }, completed: {
            self.Loading(activate: false)
        })
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
        if let navigator = navigationController {
            navigator.pushViewController(viewController, animated: true)
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
            self.nextViewController(isLogout: false)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        return alert
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
