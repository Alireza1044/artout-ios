//
//  TokenService.swift
//  Artout
//
//  Created by Alireza Moradi on 10/28/19.
//  Copyright © 2019 Pooya Kabiri. All rights reserved.
//

import Foundation
import Combine

let baseURL = "https://my.api.mockaroo.com"

class TokenService: ObservableObject {
    //    var didChange = PassthroughSubject<TokenService, Error>()
    
    func validateLogin(email: String, password: String,user: UserModel, loginStatus:Bool) {
        
        let url = URL(string: "\(baseURL)/users.json")!
        
        var request = URLRequest(url: url)
        request.setValue("cee1b8e0", forHTTPHeaderField: "x-api-key")
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
                let parsedData = try JSONDecoder().decode(LoginData.self, from: data)
                DispatchQueue.main.async {
                    user.id = parsedData.id
                    //loginStatus.toggle()
                }
            } catch {
                return
            }
        }.resume()
    }
}

struct LoginData: Decodable{
    var access:String = ""
    var refresh:String = ""
    let id:String = ""
}

