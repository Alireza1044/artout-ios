//
//  RegisterEntity.swift
//  Artout
//
//  Created by Pooya Kabiri on 12/4/19.
//  Copyright © 2019 Pooya Kabiri. All rights reserved.
//

import Foundation
class RegisterEntity {
    var Username: String
    var Email: String
    var FirstName: String
    var LastName: String
    var Password: String
    
    init(Username: String, Password: String, FirstName: String, LastName: String, Email: String) {
        self.Username = Username
        self.Password = Password
        self.Email = Email
        self.LastName = LastName
        self.FirstName = FirstName
    }
}
