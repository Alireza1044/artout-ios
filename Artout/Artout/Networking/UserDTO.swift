//
//  UserDTO.swift
//  Artout
//
//  Created by Alireza Moradi on 12/9/19.
//  Copyright © 2019 Pooya Kabiri. All rights reserved.
//

import Foundation

class UserDTO: Codable {
    var FirstName: String
    var LastName: String
    var UserName: String
    var Avatar: String
    var Id: Int
    
    var FullName: String {
        return FirstName + " " + LastName
    }
    
    init(FirstName: String, LastName: String, UserName: String, Avatar: String, Id: Int) {
        self.UserName = UserName
        self.Id = Id
        self.Avatar = Avatar
        self.FirstName = FirstName
        self.LastName = LastName
    }
}
