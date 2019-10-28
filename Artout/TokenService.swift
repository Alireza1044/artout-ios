//
//  TokenService.swift
//  Artout
//
//  Created by Alireza Moradi on 10/28/19.
//  Copyright © 2019 Pooya Kabiri. All rights reserved.
//

import Foundation
import Combine

let baseURL = "https://34be09c0-58f0-4be2-ad6b-6df87262928b.mock.pstmn.io"

class TokenService: ObservableObject {
    
    //    var didChange = PassthroughSubject<TokenService, Error>()
    
    @Published var login : loginData = nil
    
    func fetchJSON(email: String, password: String) {
        
        let url = URL(string: "\(baseURL)/login")!
        
        var request = URLRequest(url: url)
        
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: ["username":email,"password":password], options: .prettyPrinted)
        } catch {
            return
        }
        
        request.httpMethod = "POST"
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil { return }
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else { return }
            
            guard let data = data else { return }
            
            do{
                let parsedData = try JSONDecoder().decode(loginData.self, from: data)
                self.login = parsedData
            } catch {
                return
            }
        }.resume()
    }
}

class loginData: Decodable{
    var access:String
    var refresh:String
    let id:String
}

