//
//  TokenService.swift
//  Artout
//
//  Created by Pooya Kabiri on 10/31/19.
//  Copyright © 2019 Pooya Kabiri. All rights reserved.
//

import Foundation
import RxSwift

class TokenService {
    
    struct Credentials: Codable {
        var Password: String
        var Email: String
        init(email: String, password: String) {
            self.Email = email
            self.Password = password
        }
    }
    
    enum TokenError: Error {
        case CouldNotConnectToHostError
    }
    
    let endpoint = "Address Placeholder"
    
    let disposeBag = DisposeBag()
    
    func FetchToken (With email: String, And password: String) -> Single<String> {
        let encoder = JSONEncoder()
        let data = try? encoder.encode(Credentials(email: email, password: password))
        return Single<String>.create(subscribe: { single in
            let url = self.endpoint
            
            Observable.from([url])
            .map {
                let url = URL(string: $0)!
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.httpBody = data
                return request
            }
            .flatMap { request in
                URLSession.shared.rx.response(request: request)
            }
            .subscribe(onNext: { [weak self] response, data in
                let decoder = JSONDecoder()
                guard let json = try? decoder.decode([[String:String]].self, from: data) else {
                    single(.error(TokenError.CouldNotConnectToHostError))
                    return
                }
                if let accessToken = json[0]["Access"] {
                    single(.success(accessToken))
                }
                
            }).disposed(by: self.disposeBag)
            return Disposables.create()
        })
    }
}
