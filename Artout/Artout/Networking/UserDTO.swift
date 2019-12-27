//
//  UserDTO.swift
//  Artout
//
//  Created by Alireza Moradi on 12/9/19.
//  Copyright © 2019 Pooya Kabiri. All rights reserved.
//

import Foundation

class UserDTO: Codable {
    var first_name: String
    var last_name: String
    var email: String?
    var date_joined: String?
    var is_private: Bool?
    var username: String
    var avatar: String
    var id: Int
        
    init(FirstName: String, LastName: String, UserName: String, Avatar: String, Id: Int) {
        self.username = UserName
        self.id = Id
        self.avatar = Avatar
        self.first_name = FirstName
        self.last_name = LastName
    }
    
    init(FirstName: String, LastName: String, UserName: String, Avatar: String, Id: Int, Email: String?, DateJoined: String?, IsPrivate: Bool?) {
        self.username = UserName
        self.id = Id
        self.avatar = Avatar
        self.first_name = FirstName
        self.last_name = LastName
        self.email = Email
        self.date_joined = DateJoined
        self.is_private = IsPrivate
    }
}
