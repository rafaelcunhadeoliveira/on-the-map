//
//  LoginServiceManager.swift
//  OnTheMap
//
//  Created by Rafael Cunha on 17/10/2018.
//  Copyright © 2018 Rafael Cunha. All rights reserved.
//

import Foundation

class LoginServiceManager {
    
    class func sharedInstance() -> LoginServiceManager {
        struct Singleton {
            static var sharedInstance = LoginServiceManager()
        }
        return Singleton.sharedInstance
    }

    func login(userName: String,
               password: String,
               success: @escaping (_ key: String) -> Void,
               failure: @escaping (_ error: ServiceError) -> Void,
               completion: @escaping () -> Void) {
        
        let params = [
            "udacity": [
                "username": userName,
                "password": password
            ]
        ]
        ServiceManager.sharedInstance().request(url: Constants.getSessionURL(),
                                                method: .post,
                                                parameters: params,
            success:{ (data) in
                let newData = data.subdata(in: Range(uncheckedBounds: (5, data.count)))
                let parsedResult = JSONResponse.deserialize(data: newData) as! [String : AnyObject]
                
                if let account = parsedResult["account"], let key = account["key"] as? String{
                    success(key)
                } else {
                    failure(ServiceError(code: "", error: "Key not found."))
                }
                
        }, failure:{ (error) in
            failure(error)
        }, completion: {
            completion()
        })
    }

}
