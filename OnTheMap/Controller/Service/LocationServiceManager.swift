//
//  LocationServiceManager.swift
//  OnTheMap
//
//  Created by Rafael Cunha on 23/10/2018.
//  Copyright © 2018 Rafael Cunha. All rights reserved.
//

import Foundation

class LocationServiceManager {
    
    class func sharedInstance() -> LocationServiceManager {
        struct Singleton {
            static var sharedInstance = LocationServiceManager()
        }
        return Singleton.sharedInstance
    }

    func getUserLocation(success: @escaping (_ locations: [StudentLocation]) -> Void,
                         failure: @escaping (_ error: ServiceError) -> Void,
                         completed: @escaping ()-> Void) {
        
        let url = Constants.studentsLocationUrl() + "?where={\"uniqueKey\":\"\(User.current.key!)\"}&order=-updatedAt"
        
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
    
    func createPin(map: String,
                        mediaURL: String,
                        latitude: Double,
                        longitude: Double,
                        success: @escaping () -> Void,
                        failure: @escaping (_ error: ServiceError) -> Void,
                        completed: @escaping ()-> Void) {
        
        let parameters: [String: Any] = [
            "uniqueKey" : User.current.key!,
            "firstName": User.current.firstName!,
            "lastName": User.current.lastName!,
            "mapString": map,
            "mediaURL": mediaURL,
            "latitude": latitude,
            "longitude": longitude,
            ]
        
        var method: HTTPMethod?
        var url = ""
        if let id = User.current.location?.objectId {
            url = Constants.studentsLocationUrl() + "/\(id)"
            method = .put
        } else {
            url = Constants.studentsLocationUrl()
            method = .post
        }
        
        ServiceManager.sharedInstance().request(url: url, method: method!, parameters: parameters,
                                                success: { (data) in
            success()
        }, failure: { (erroResponse) in
            failure(erroResponse)
        }, completion: {
            completed()
        })
        
    }
}
