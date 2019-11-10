//
//  LoginDTO.swift
//  Artout
//
//  Created by Pooya Kabiri on 11/7/19.
//  Copyright © 2019 Pooya Kabiri. All rights reserved.
//

import Foundation

struct LoginDTO: Codable {
    var password: String
    var username: String
    init(username: String, password: String) {
        self.username = username
        self.password = password
    }
}

struct LoginResponseDTO: Codable {
    var access: String
    var refresh: String
    var id: Int
    init(access: String, refresh: String, id: Int) {
        self.access = access
        self.refresh = refresh
        self.id = id
    }
}
