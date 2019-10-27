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
    
    let didChange = PassthroughSubject<LoginViewModel,Never>()
    
    @Published private(set) var LoginStatus: Bool
    
    @Published var LoginMessage: String = ""
    
    var service: LoginService
    
    init(service: LoginService) {
        self.service = service
        self.LoginStatus = false
        self.LoginMessage = ""
    }
    
    func Login(With email: String, And password: String) -> Bool {
        service.Validator(Email: email, Password: password)
        self.LoginStatus.toggle()
        return false
    }
    
    }
