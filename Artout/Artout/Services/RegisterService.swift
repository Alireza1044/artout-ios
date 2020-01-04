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
    
    
    let disposeBag = DisposeBag()
    let isLoading = PublishSubject<Bool>()
    let registerStatus = PublishSubject<Bool>()
    let error = PublishSubject<String>()
    let tokenService = LoginService()
    

    enum RegisterError: Error {
        case CouldNotConnectToHostError
        case RegisterFailed
    }
    
    
    func Register(with entity: RegisterEntity) -> Single<String> {
        
        isLoading.onNext(true)
                
        return Single<String>.create(subscribe: { single in
            Observable.from(optional: [String].self)
                .map {_ in
                    let url = URL(string: Endpoint.GCPServer.rawValue + APIPaths.Register.rawValue)!
                    var request = URLRequest(url: url)
                    request.httpMethod = HTTPMethod.POST.rawValue
                    request.httpBody = try? JSONEncoder().encode(entity.ToDTO())
                    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                    return request
            }
            .flatMap { request in
                URLSession.shared.rx.response(request: request)
            }
            .subscribe(onNext: { [weak self] response, data in
                
                guard response.statusCode == 201 else{
                    DispatchQueue.main.async {
                        self!.isLoading.onNext(false)
                        self!.error.onNext(try! (JSONDecoder().decode([String:[String]].self, from: data).first?.value.first)!)
                    }
                    single(.error(RegisterError.CouldNotConnectToHostError))
                    return
                }
                
                guard (try? JSONDecoder().decode(RegisterResponseDTO.self, from: data)) != nil else {
                    single(.error(RegisterError.CouldNotConnectToHostError))
                    DispatchQueue.main.async {
                        self!.isLoading.onNext(false)
                        self?.error.on(.next("Data Decode Error"))
                    }
                    return
                }
                
                DispatchQueue.main.async {
                    self!.isLoading.onNext(false)
                    self?.registerStatus.onNext(true)
                }
                
                },onError: { error in
                    print(error.localizedDescription)
            }).disposed(by: self.disposeBag)
            return Disposables.create()
        })
    }
}
