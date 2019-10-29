//
//  File.swift
//  Artout
//
//  Created by Pooya Kabiri on 10/26/19.
//  Copyright © 2019 Pooya Kabiri. All rights reserved.
//

import Foundation
import Combine

class LoginViewModel: ObservableObject {
    var Token : String?
    
    @Published var user = UserModel()
    
    @Published var LoginStatus: Bool = false
    
    @Published var LoginMessage: String = ""
    
    var service = TokenService()
    
    func Login(With email: String, And password: String) -> Bool {
        service.validateLogin(email: email, password: password, user:user, loginStatus: LoginStatus)
        self.LoginMessage = "\(self.LoginStatus)"
        return false
    }
}
