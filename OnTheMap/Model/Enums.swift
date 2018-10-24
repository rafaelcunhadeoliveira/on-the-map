//
//  Enums.swift
//  OnTheMap
//
//  Created by Rafael Cunha on 09/10/2018.
//  Copyright © 2018 Rafael Cunha. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum errorType: Int {
    case basicError = 0, overwriteError
}
