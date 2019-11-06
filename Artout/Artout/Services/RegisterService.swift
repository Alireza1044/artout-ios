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
    
    let endpoint = "http://35.202.66.168:8000/api/register/"
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
                    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                    return request
            }
            .flatMap { request in
                //                print("fuck")
                URLSession.shared.rx.response(request: request).debug("test")//.rx.response(request: request)
            }
            .subscribe(onNext: { [weak self] response, data in
                guard response.statusCode == 201 else{
                    single(.error(RegisterError.CouldNotConnectToHostError))
                    DispatchQueue.main.async {
                        self!.isLoading.onNext(false)
                    }
                    print("my")
                    return
                }
                
                let decoder = JSONDecoder()
                guard let json = try? decoder.decode([[String:String]].self, from: data) else {
                    single(.error(RegisterError.CouldNotConnectToHostError))
                    DispatchQueue.main.async {
                        self!.isLoading.onNext(false)
                    }
                    print("oh")
                    return
                }
                
                if let accessToken = json[0]["Access"] {
                    DispatchQueue.main.async {
                        self!.isLoading.onNext(false)
                    }
                    single(.success(accessToken))
                    print("god")
                    return
                }
                
            }).disposed(by: self.disposeBag)
            return Disposables.create()
        })
    }
}
