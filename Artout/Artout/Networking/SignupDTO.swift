//
//  SignupDTO.swift
//  Artout
//
//  Created by Pooya Kabiri on 11/7/19.
//  Copyright © 2019 Pooya Kabiri. All rights reserved.
//

import Foundation

struct RegisterDTO: Codable {
    var username: String
    var first_name: String
    var last_name: String
    var password: String
    var avatar: String = ""
    var email: String
    
    init(username:String, firstName:String,lastName:String,email:String, password:String) {
        self.first_name = firstName
        self.last_name = lastName
        self.username = username
        self.password = password
        self.email = email
    }
}

struct RegisterResponseDTO: Codable {
    var access: String
    var refresh: String
    var id: Int
    init(access: String, refresh: String, id: Int) {
        self.access = access
        self.refresh = refresh
        self.id = id
    }
}
