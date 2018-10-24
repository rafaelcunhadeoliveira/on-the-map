//
//  StudentServiceManager.swift
//  OnTheMap
//
//  Created by Rafael Cunha on 23/10/2018.
//  Copyright © 2018 Rafael Cunha. All rights reserved.
//

import Foundation

class StudentServiceManager {

    class func sharedInstance() -> StudentServiceManager {
        struct Singleton {
            static var sharedInstance = StudentServiceManager()
        }
        return Singleton.sharedInstance
    }
    
    func getUserInformation(key: String,
                            success: @escaping (_ student: User) -> Void,
                            failure: @escaping (_ error: ServiceError) -> Void,
                            completed: @escaping ()-> Void) {
        
        let url = Constants.userInformationUrl(key: key)
        
        ServiceManager.sharedInstance().request(url: url, method: .get, success: { (data) in
            
            let newData = data.subdata(in: Range(uncheckedBounds: (5, data.count)))
            let parsedResult = JSONResponse.deserialize(data: newData)
            
            let student = User(dictionary: parsedResult as! [String : AnyObject])
            success(student)
            
        }, failure: { (error) in
            failure(error)
        }, completion: {
            completed()
        })
        
    }
    
    func logout(success: @escaping () -> Void,
                failure: @escaping (_ error: ServiceError) -> Void,
                completed: @escaping ()-> Void){
        
        var xsrfCookie: HTTPCookie? = nil
        
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        
        var header: [String : String] = [:]
        if let xsrfCookie = xsrfCookie {
            header = ["X-XSRF-TOKEN" : xsrfCookie.value ]
        }
        
        
        ServiceManager.sharedInstance().request(url: Constants.getSessionURL(), method: .delete, parameters: nil, headers: header, success: { (data) in
            
            let newData = data.subdata(in: Range(uncheckedBounds: (5, data.count)))
            print(NSString(data: newData, encoding: String.Encoding.utf8.rawValue)!)
            success()
        }, failure: { (error) in
            failure(error)
        }, completion: {
            completed()
        })
        
    }

    func getAllStudentsLocation(withLimit limit: Int = 100, withOrder order: String = "updatedAt",
                             success: @escaping (_ locations: [StudentLocation]) -> Void,
                             failure: @escaping (_ error: ServiceError) -> Void,
                             completed: @escaping ()-> Void) {
        
        
        let url = Constants.studentsLocationUrl() + "?limit=\(limit)&order=-\(order)"
        
        ServiceManager.sharedInstance().request(url: url, method: .get, success: { (data) in
            
            let parsedResult = JSONResponse.deserialize(data: data)
            if let results = parsedResult["results"] as? [[String:AnyObject]] {
                var locations: [StudentLocation] = [StudentLocation]()
                
                for result in results {
                    locations.append(StudentLocation(dictionay: result))
                }
                success(locations)
            }
            
        }, failure: { (error) in
            failure(error)
        }, completion: {
            completed()
        })
    }

}
