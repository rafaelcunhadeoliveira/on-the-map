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
    
    class func getSessionURL() -> String {
        return EnvironmentVariables.sharedInstance().baseUdacityUrl + EnvironmentVariables.sharedInstance().sessionUrl
    }

    class func userInformationUrl(key: String) -> String {
        return EnvironmentVariables.sharedInstance().baseUdacityUrl + "/api/users/\(key)"
    }
    
    class func studentsLocationUrl() -> String {
        return EnvironmentVariables.sharedInstance().baseParseUrl + EnvironmentVariables.sharedInstance().locationUrl
    }

    class func storyboardName() -> String {
        return "OnTheMap"
    }
}
