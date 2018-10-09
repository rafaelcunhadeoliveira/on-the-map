//
//  Constants.swift
//  OnTheMap
//
//  Created by Rafael Cunha on 26/09/2018.
//  Copyright © 2018 Rafael Cunha. All rights reserved.
//

import Foundation

class Constants {
    public let udacityUrl =  "https://www.udacity.com/"
    public let apiSession =  "api/session"
    
    public lazy var sessionURL: String = {
        return udacityUrl + apiSession
    }()
}
