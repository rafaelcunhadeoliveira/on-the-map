//
//  EnvironmentVariables.swift
//  OnTheMap
//
//  Created by Rafael Cunha on 09/10/2018.
//  Copyright © 2018 Rafael Cunha. All rights reserved.
//

import Foundation

class EnvironmentVariables {
    
    // MARK: - init
    class func sharedInstance() -> EnvironmentVariables {
        struct Singleton {
            static var sharedInstance = EnvironmentVariables()
        }
        return Singleton.sharedInstance
    }

    let parseApplicationId: String = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    let parseRestApiKey: String = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    let baseUdacityUrl: String = "https://www.udacity.com"
    let baseParseUrl: String = "https://parse.udacity.com"
    let sessionUrl: String = "/api/session"
    let locationUrl: String = "/parse/classes/StudentLocation"

    var udacitySession: String {
        return baseUdacityUrl + sessionUrl
    }
    
    func getURLUserInfo(userKey: String) -> String {
        return baseUdacityUrl + "/api/users/\(userKey)"
    }

    func getStudentsLocationURL() -> String {
        return baseParseUrl + locationUrl
    }
}
