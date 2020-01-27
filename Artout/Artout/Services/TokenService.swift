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
    
    let keychainInstance = Keychain(service: "com.pooyakab.Artout")
    func saveToken(access:String, refresh:String, userId: Int) {
        
        keychainInstance["AccessToken"] = access
        keychainInstance["RefreshToken"] = refresh
        keychainInstance["IsUserLggedIn"] = "true"
        UserDefaults.standard.set(access, forKey: "AccessToken")
        UserDefaults.standard.set(refresh, forKey: "RefreshToken")
        UserDefaults.standard.set(true, forKey: "IsUserLoggedIn")
        UserDefaults.standard.set(userId, forKey: "UserId")
    }
    
    func RenewAccessToken(access:String) {
        keychainInstance["AccessToken"] = access
        UserDefaults.standard.set(access, forKey: "AccessToken")
    }
    
    func GetRefreshToken() -> String {
        if let refresh = UserDefaults.standard.string(forKey: "RefreshToken") {
            return refresh
        }
        return ""
    }
    
}
    
    

