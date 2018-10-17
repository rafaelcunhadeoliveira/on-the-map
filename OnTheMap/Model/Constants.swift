//
//  Constants.swift
//  OnTheMap
//
//  Created by Rafael Cunha on 26/09/2018.
//  Copyright © 2018 Rafael Cunha. All rights reserved.
//

import Foundation

class Constants {
    
    class func sharedInstance() -> Constants {
        struct Singleton {
            static var sharedInstance = Constants()
        }
        return Singleton.sharedInstance
    }
    public let udacityUrl =  "https://www.udacity.com/"
    public let apiSession =  "api/session"
    
    class func getSessionURL() -> String {
        return Constants.sharedInstance().udacityUrl + Constants.sharedInstance().apiSession
    }
}
