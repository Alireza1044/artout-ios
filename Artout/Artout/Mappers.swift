//
//  Mappers.swift
//  Artout
//
//  Created by Pooya Kabiri on 12/4/19.
//  Copyright © 2019 Pooya Kabiri. All rights reserved.
//

import Foundation

extension LoginEntity {
    func ToDTO() -> LoginDTO {
        return LoginDTO(username: self.Username, password: self.Password)
    }
}
extension RegisterEntity {
    func ToDTO() -> RegisterDTO {
        return RegisterDTO(username: self.Username,
                           firstName: self.FirstName,
                           lastName: self.LastName,
                           email: self.Email,
                           password: self.Password)
    }
}

