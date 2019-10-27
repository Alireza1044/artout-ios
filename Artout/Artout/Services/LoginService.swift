//
//  File.swift
//  Artout
//
//  Created by Pooya Kabiri on 10/27/19.
//  Copyright © 2019 Pooya Kabiri. All rights reserved.
//

import Foundation
class LoginService {
    func Validator(Email: String, Password: String) -> Bool {
    /* Code */
    
    let serverURL = "To be Announced"
    
    
    let authURL = URL(string: (serverURL + "auth"))!
    var request = URLRequest(url: authURL)
    
    request.httpMethod = "Post"
    
    request.addValue("application/json", forHTTPHeaderField: "content-type")
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    
    let postString = ["username": "alireza1044","password": "FuckThisShit"] as [String:String]
    
    do {
        request.httpBody = try JSONSerialization.data(withJSONObject: postString, options: .prettyPrinted)
    } catch let error {
        print(error.localizedDescription)
        return false
    }
    
    let task = URLSession.shared.dataTask(with: request) {
        (data, response, error) in
        
        if error != nil {
            print(error.debugDescription)
            return
        }
        
        do {
            let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
            
            if let parsedJSON = json {
                let accessToken = parsedJSON["access"] as? String
                let id = parsedJSON["id"] as? String
                print(id!)
                
                if (accessToken?.isEmpty)! {
                    print(error.debugDescription)
                    return
                }
                
            } else {
                print (error.debugDescription)
                return
            }
            
        } catch {
            print(error.localizedDescription)
            return
        }
    }
        task.resume()
        return false;
    }
}
