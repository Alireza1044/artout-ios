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
    
    let endpoint = "TBA"
    let disposeBag = DisposeBag()
    let isLoading = PublishSubject<Bool>()
    
    struct Registerar: Codable {
        var firstName: String
        var lastName: String
        var phoneNumber: String
        var password: String
        
        init(firstName:String,lastName:String,phoneNumber:String, password:String) {
            self.firstName = firstName
            self.lastName = lastName
            self.phoneNumber = phoneNumber
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
                    self?.isLoading.onNext(false)
                    single(.error(RegisterError.CouldNotConnectToHostError))
                    return
                }
                if let accessToken = json[0]["Access"] {
                    self?.isLoading.onNext(false)
                    single(.success(accessToken))
                }
                
            }).disposed(by: self.disposeBag)
            return Disposables.create()
        })
    }
}
