//
//  UserEntity.swift
//  Artout
//
//  Created by Pooya Kabiri on 12/6/19.
//  Copyright © 2019 Pooya Kabiri. All rights reserved.
//

import Foundation

class UserEntity {
    var FirstName: String
    var LastName: String
    var UserName: String
    var DateJoined: String?
    var IsPrivate: Bool?
    var Email: String?
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
    init(FirstName: String, LastName: String, UserName: String, Avatar: String, Id: Int, DateJoined: String?, IsPrivate: Bool?, Email: String?) {
        self.UserName = UserName
        self.Id = Id
        self.Avatar = Avatar
        self.FirstName = FirstName
        self.LastName = LastName
        self.IsPrivate = IsPrivate
        self.Email = Email
        self.DateJoined = DateJoined
    }
}
