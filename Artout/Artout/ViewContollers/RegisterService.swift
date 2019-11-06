//
//  RegisterService.swift
//  Artout
//
//  Created by Alireza Moradi on 11/3/19.
//  Copyright © 2019 Pooya Kabiri. All rights reserved.
//

import Foundation
import RxSwift



class RegisterService {
    
    let endpoint = "35.202.66.168:8000/api/register/"
    let disposeBag = DisposeBag()
    let isLoading = PublishSubject<Bool>()
    
    struct Registerar: Codable {
        var first_name: String
        var last_name: String
        var username: String
        var password: String
        var avatar: String = ""
        var email: String = ""
        
        init(firstName:String,lastName:String,phoneNumber:String, password:String) {
            self.first_name = firstName
            self.last_name = lastName
            self.username = phoneNumber
            self.password = password
        }
    }
    
    enum RegisterError: Error {
        case CouldNotConnectToHostError
    }
    
    func Register(firstName:String,lastName:String,phoneNumber:String, password:String) -> Single<String> {

        isLoading.onNext(true)
        
        let jsonData = try! JSONEncoder().encode(Registerar(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber, password: password))
        
        return Single<String>.create(subscribe: { single in
            let url = self.endpoint
            
            Observable.from([url])
            .map {
                let url = URL(string: $0)!
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.httpBody = jsonData
                return request
                }
            .flatMap { request in
                URLSession.shared.rx.response(request: request)
                }
            .subscribe(onNext: { [weak self] response, data in
                let decoder = JSONDecoder()
                guard let json = try? decoder.decode([[String:String]].self, from: data) else {
                    single(.error(RegisterError.CouldNotConnectToHostError))
                    self?.isLoading.onNext(false)
                    return
                }
                guard response.statusCode == 201 else{
                    single(.error(RegisterError.CouldNotConnectToHostError))
                    self?.isLoading.onNext(false)
                    return
                }
                if let accessToken = json[0]["Access"] {
                    self?.isLoading.onNext(false)
                    single(.success(accessToken))
                    return
                }
                
                }).disposed(by: self.disposeBag)
            return Disposables.create()
            })
    }
}
