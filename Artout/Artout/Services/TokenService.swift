//
//  TokenService.swift
//  Artout
//
//  Created by Alireza Moradi on 11/7/19.
//  Copyright © 2019 Pooya Kabiri. All rights reserved.
//

import Foundation
import KeychainAccess
import RxSwift

class TokenService {
    
    let keychain = Keychain(service: "com.pooyakab.Artout")
    
    func saveToken(access:String, refresh:String){
        keychain["access"] = access
        keychain["refresh"] = refresh
    }
    
    func refreshToken(refresh:String) {
        
    }
}
