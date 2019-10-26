//
//  File.swift
//  Artout
//
//  Created by Pooya Kabiri on 10/26/19.
//  Copyright © 2019 Pooya Kabiri. All rights reserved.
//

import Foundation
import Combine

class LoginViewModel: ObservableObject, Identifiable {
    var Token : String?
    func Validator(Email: String, Password: String) -> Bool {
        /* Code */
        return false;
    }
}
