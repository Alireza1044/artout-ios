//
//  ProfileService.swift
//  Artout
//
//  Created by Alireza Moradi on 12/22/19.
//  Copyright © 2019 Pooya Kabiri. All rights reserved.
//

import Foundation
import RxSwift

class ProfileService{
    
    let isLoading = PublishSubject<Bool>()
    let disposeBag = DisposeBag()
    
    func RequestProfile(id: Int) -> Single<FriendProfileEntity> {
        
        self.isLoading.onNext(true)
        
        return Single<FriendProfileEntity>.create(subscribe: { single in
            Observable.from(optional: [String].self)
                .map {_ in
                    let url = URL(string: Endpoint.GCPServer.rawValue + "users/profile/?user=" + "\(id)")!
                    var request = URLRequest(url: url)
                    request.httpMethod = HTTPMethod.GET.rawValue // edit http method
                    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                    request.addValue("Bearer " + UserDefaults.standard.string(forKey: "AccessToken")!, forHTTPHeaderField: "Authorization")
                    return request
            }
            .flatMap { request in
                URLSession.shared.rx.response(request: request)
            }
            .subscribe(onNext: { [weak self] response, data in
                guard response.statusCode == 200 else{
                    DispatchQueue.main.async {
                        single(.error(HTTPStatusCodes.InternalServerError))
                        self?.isLoading.onNext(false)
                    }
                    return
                }
                guard let profile = try? JSONDecoder().decode(FriendProfileDTO.self, from: data) else {
                    DispatchQueue.main.async {
                        single(.error(HTTPStatusCodes.InternalServerError))
                        self?.isLoading.onNext(false)
                    }
                    return
                }
                DispatchQueue.main.async {
                    self?.isLoading.onNext(false)
                }
                single(.success(profile.ToEntity()))
                return
                }, onError: { error in
                    print(error.localizedDescription)
            }).disposed(by: self.disposeBag)
            return Disposables.create()
        })
    }
    
    func RequestMyProfile(id: Int) -> Single<FriendProfileEntity> {
        
        self.isLoading.onNext(true)
        
        return Single<FriendProfileEntity>.create(subscribe: { single in
            Observable.from(optional: [String].self)
                .map {_ in
                    let url = URL(string: Endpoint.GCPServer.rawValue + "users/profile/")!
                    var request = URLRequest(url: url)
                    request.httpMethod = HTTPMethod.GET.rawValue // edit http method
                    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                    request.addValue("Bearer " + UserDefaults.standard.string(forKey: "AccessToken")!, forHTTPHeaderField: "Authorization")
                    return request
            }
            .flatMap { request in
                URLSession.shared.rx.response(request: request)
            }
            .subscribe(onNext: { [weak self] response, data in
                guard response.statusCode == 200 else{
                    DispatchQueue.main.async {
                        single(.error(HTTPStatusCodes.InternalServerError))
                        self?.isLoading.onNext(false)
                    }
                    return
                }
                guard let profile = try? JSONDecoder().decode(FriendProfileDTO.self, from: data) else {
                    DispatchQueue.main.async {
                        single(.error(HTTPStatusCodes.InternalServerError))
                        self?.isLoading.onNext(false)
                    }
                    return
                }
                DispatchQueue.main.async {
                    self?.isLoading.onNext(false)
                }
                single(.success(profile.ToEntity()))
                return
                }, onError: { error in
                    print(error.localizedDescription)
            }).disposed(by: self.disposeBag)
            return Disposables.create()
        })
    }
}
