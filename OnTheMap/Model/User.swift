//
//  User.swift
//  OnTheMap
//
//  Created by Rafael Cunha on 19/10/2018.
//  Copyright © 2018 Rafael Cunha. All rights reserved.
//

import Foundation

struct User {
    static var current = User()
    
    var nick: String?
    var firstName: String?
    var lastName: String?
    var key: String?
    var location: StudentLocation?
    
    init() {
        
    }
    
    init(dictionary: [String : AnyObject]) {
        if let user = dictionary["user"] {
            self.firstName = user["first_name"] as? String ?? ""
            self.lastName = user["last_name"] as? String ?? ""
            self.nick = user["nickname"] as? String ?? ""
            self.key = user["key"] as? String ?? ""
        }
    }}
