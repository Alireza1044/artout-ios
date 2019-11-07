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
    
    let Formatter = DTOFormatter<RegisterDTO, RegisterResponseDTO>()
    
    let endpoint = "http://35.202.66.168:8000/api/register/"
    let disposeBag = DisposeBag()
    let isLoading = PublishSubject<Bool>()
    let error = PublishSubject<String>()
    let tokenService = LoginService()
    
    struct Registerar: Codable {
        var username: String
        var first_name: String
        var last_name: String
        var password: String
        var avatar: String = ""
        var email: String
        
        init(username:String, firstName:String,lastName:String,email:String, password:String) {
            self.first_name = firstName
            self.last_name = lastName
            self.username = username
            self.password = password
            self.email = email
        }
    }
    
    enum RegisterError: Error {
        case CouldNotConnectToHostError
        case RegisterFailed
    }
    
    
    func Register(username:String, firstName:String,lastName:String,email:String, password:String) -> Single<String> {
        
        isLoading.onNext(true)
        
        let rawData = RegisterDTO(username: username, firstName: firstName, lastName: lastName, email: email, password: password)
//        let jsonData = try! JSONEncoder().encode()
        
        return Single<String>.create(subscribe: { single in
            Observable.from([String].self)
                .map {_ in
                    let url = URL(string: Endpoint.GCPServer.rawValue + APIPaths.Register.rawValue)!
                    var request = URLRequest(url: url)
                    request.httpMethod = HTTPMethod.POST.rawValue
                    request.httpBody = self.Formatter.Encode(objDTO: rawData)
                    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                    return request
            }
            .flatMap { request in
                //                print("fuck")
                URLSession.shared.rx.response(request: request).debug("test")//.rx.response(request: request)
            }
            .subscribe(onNext: { [weak self] response, data in
                let decoder = JSONDecoder()
                
                guard response.statusCode == 201 else{
                    DispatchQueue.main.async {
                        self!.error.onNext(try! (decoder.decode([String:[String]].self, from: data).first?.value.first)!)
                    }
                    single(.error(RegisterError.CouldNotConnectToHostError))
                    DispatchQueue.main.async {
                        self!.isLoading.onNext(false)
                    }
                    print("my")
                    return
                }
                
                guard let json = try? decoder.decode([String:String].self, from: data) else {
                    single(.error(RegisterError.CouldNotConnectToHostError))
                    DispatchQueue.main.async {
                        self!.isLoading.onNext(false)
                    }
                    print("oh")
                    return
                }
                
                if let accessToken = json["access"] {
                    DispatchQueue.main.async {
                        self!.isLoading.onNext(false)
                    }
                    single(.success(accessToken))
                    print("god")
                    return
                }
                
                },onError: { error in
                    print(error.localizedDescription)
            }).disposed(by: self.disposeBag)
            return Disposables.create()
        })
    }
}
