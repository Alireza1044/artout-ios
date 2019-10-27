//
//  File.swift
//  Artout
//
//  Created by Pooya Kabiri on 10/27/19.
//  Copyright © 2019 Pooya Kabiri. All rights reserved.
//

import Foundation
import Combine

let baseURL = "https://34be09c0-58f0-4be2-ad6b-6df87262928b.mock.pstmn.io/login"

class LoginService {
    
    var manager = HttpAuth()

    func Validator(Email: String, Password: String) -> Bool {
        /* Code */
        manager.checkDetails(username: Email, password: Password)
        return false
    }
}

class HttpAuth: ObservableObject {
    var didChange = PassthroughSubject<HttpAuth, Never>()
    
    var authenticated = false {
        didSet { didChange.send(self)}
    }
    
    func checkDetails(username: String, password: String) {
        guard let url = URL(string: baseURL) else { return }
        
        let body: [String: String] = ["username" : username, "password" : password]
        
        let serializedBody = try! JSONSerialization.data(withJSONObject: body)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = serializedBody
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            
            guard let data = data else { return }
            
            let parsedData = try! JSONDecoder().decode(User.self, from: data)
            
            print (parsedData)
            
        }.resume()
    }
}

struct User: Decodable {
    let refresh,access,id: String
}
