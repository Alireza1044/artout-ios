//
//  FriendService.swift
//  Artout
//
//  Created by Pooya Kabiri on 12/16/19.
//  Copyright © 2019 Pooya Kabiri. All rights reserved.
//

import Foundation
import RxSwift

class FriendService {
    var disposeBag = DisposeBag()
    
    func fetchFollowingList() -> Single<[UserEntity]>{
        
        return Single<[UserEntity]>.create(subscribe: { single in
            Observable.from(optional: [String].self)
                .map {_ in
                    let url = URL(string: Endpoint.GCPServer.rawValue + APIPaths.MyFollowings.rawValue)!
                    var request = URLRequest(url: url)
                    request.httpMethod = HTTPMethod.GET.rawValue
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
                        single(.error(HTTPStatusCodes.BadRequest))
                    }
                    return
                }
                guard let response = try? JSONDecoder().decode([UserDTO].self, from: data) else {
                    DispatchQueue.main.async {
                        single(.error(HTTPStatusCodes.InternalServerError))
                    }
                    return
                }
                single(.success(response.map { user in
                    user.ToEntity()
                }))
                return
                }, onError: { error in
                    print(error.localizedDescription)
            }).disposed(by: self.disposeBag)
            return Disposables.create()
        })
        
    }
    func Accept(with id: String) -> Single<Bool>{
        return Single<Bool>.create(subscribe: { single in
            Observable.from(optional: [String].self)
                .map {_ in
                    let url = URL(string: Endpoint.GCPServer.rawValue + APIPaths.PendingRequests.rawValue + id + "/")!
                    var request = URLRequest(url: url)
                    request.httpMethod = HTTPMethod.PUT.rawValue
                    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                    request.addValue("Bearer " + UserDefaults.standard.string(forKey: "AccessToken")!, forHTTPHeaderField: "Authorization")
                    return request
            }
            .flatMap { request in
                URLSession.shared.rx.response(request: request)
            }
            .subscribe(onNext: { [weak self] response, data in
                guard response.statusCode == 201 else{
                    DispatchQueue.main.async {
                        single(.error(HTTPStatusCodes.BadRequest))
                    }
                    return
                }
                single(.success(true))
                return
                }, onError: { error in
                    print(error.localizedDescription)
            }).disposed(by: self.disposeBag)
            return Disposables.create()
        })
        
    }
    
    
    func fetchFollowersList() -> Single<[UserEntity]>{
        
        return Single<[UserEntity]>.create(subscribe: { single in
            Observable.from(optional: [String].self)
                .map {_ in
                    let url = URL(string: Endpoint.GCPServer.rawValue + APIPaths.MyFollowers.rawValue)!
                    var request = URLRequest(url: url)
                    request.httpMethod = HTTPMethod.GET.rawValue
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
                        single(.error(HTTPStatusCodes.BadRequest))
                    }
                    return
                }
                guard let response = try? JSONDecoder().decode([UserDTO].self, from: data) else {
                    DispatchQueue.main.async {
                        single(.error(HTTPStatusCodes.InternalServerError))
                    }
                    return
                }
                single(.success(response.map { user in
                    user.ToEntity()
                }))
                return
                }, onError: { error in
                    print(error.localizedDescription)
            }).disposed(by: self.disposeBag)
            return Disposables.create()
        })
        
    }
    func Reject(with id: String) -> Single<Bool>{
        return Single<Bool>.create(subscribe: { single in
            Observable.from(optional: [String].self)
                .map {_ in
                    let url = URL(string: Endpoint.GCPServer.rawValue + APIPaths.PendingRequests.rawValue + id + "/")!
                    var request = URLRequest(url: url)
                    request.httpMethod = HTTPMethod.DELETE.rawValue
                    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                    request.addValue("Bearer " + UserDefaults.standard.string(forKey: "AccessToken")!, forHTTPHeaderField: "Authorization")
                    return request
            }
            .flatMap { request in
                URLSession.shared.rx.response(request: request)
            }
            .subscribe(onNext: { [weak self] response, data in
                guard response.statusCode == 201 else{
                    DispatchQueue.main.async {
                        single(.error(HTTPStatusCodes.BadRequest))
                    }
                    return
                }
                single(.success(true))
                return
                }, onError: { error in
                    print(error.localizedDescription)
            }).disposed(by: self.disposeBag)
            return Disposables.create()
        })
        
    }
    func FetchPendings() -> Single<[UserEntity]>{
        
        return Single<[UserEntity]>.create(subscribe: { single in
            Observable.from(optional: [String].self)
                .map {_ in
                    let url = URL(string: Endpoint.GCPServer.rawValue + APIPaths.PendingRequests.rawValue)!
                    var request = URLRequest(url: url)
                    request.httpMethod = HTTPMethod.GET.rawValue
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
                        single(.error(HTTPStatusCodes.BadRequest))
                    }
                    return
                }
                guard let response = try? JSONDecoder().decode([UserDTO].self, from: data) else {
                    DispatchQueue.main.async {
                        single(.error(HTTPStatusCodes.InternalServerError))
                    }
                    return
                }
                single(.success(response.map { user in
                    user.ToEntity()
                }))
                return
                }, onError: { error in
                    print(error.localizedDescription)
            }).disposed(by: self.disposeBag)
            return Disposables.create()
        })
        
    }
    func AddFriend(id: String) -> Single<String>{
        let friendDTO = AddFriendDTO(Username: id)
        return Single<String>.create(subscribe: { single in
            Observable.from(optional: [String].self)
                .map {_ in
                    let url = URL(string: Endpoint.GCPServer.rawValue + APIPaths.AddFriend.rawValue)!
                    var request = URLRequest(url: url)
                    request.httpMethod = HTTPMethod.POST.rawValue
                    request.httpBody = try? JSONEncoder().encode(friendDTO)
                    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                    request.addValue("Bearer " + UserDefaults.standard.string(forKey: "AccessToken")!, forHTTPHeaderField: "Authorization")
                    return request
            }
            .flatMap { request in
                URLSession.shared.rx.response(request: request)
            }
            .subscribe(onNext: { [weak self] response, data in
                guard response.statusCode == 201 else{
                    DispatchQueue.main.async {
                        single(.error(HTTPStatusCodes.BadRequest))
                    }
                    return
                }
                single(.success("Fuck"))
                return
                }, onError: { error in
                    print(error.localizedDescription)
            }).disposed(by: self.disposeBag)
            return Disposables.create()
        })
        
    }
    func Unfollow(with id: String) -> Single<Bool>{
        return Single<Bool>.create(subscribe: { single in
            Observable.from(optional: [String].self)
                .map {_ in
                    let url = URL(string: Endpoint.GCPServer.rawValue + APIPaths.MyFollowings.rawValue + id + "/")!
                    var request = URLRequest(url: url)
                    request.httpMethod = HTTPMethod.DELETE.rawValue
                    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                    request.addValue("Bearer " + UserDefaults.standard.string(forKey: "AccessToken")!, forHTTPHeaderField: "Authorization")
                    return request
            }
            .flatMap { request in
                URLSession.shared.rx.response(request: request)
            }
            .subscribe(onNext: { [weak self] response, data in
                guard response.statusCode == 204 else{
                    DispatchQueue.main.async {
                        single(.error(HTTPStatusCodes.BadRequest))
                    }
                    return
                }
                single(.success(true))
                return
                }, onError: { error in
                    print(error.localizedDescription)
            }).disposed(by: self.disposeBag)
            return Disposables.create()
        })
        
    }
    func AddFriend(with username: String) -> Single<String>{
        let friendDTO = AddFriendDTO(Username: username)
        return Single<String>.create(subscribe: { single in
            Observable.from(optional: [String].self)
                .map {_ in
                    let url = URL(string: Endpoint.GCPServer.rawValue + APIPaths.AddFriend.rawValue)!
                    var request = URLRequest(url: url)
                    request.httpMethod = HTTPMethod.POST.rawValue
                    request.httpBody = try? JSONEncoder().encode(friendDTO)
                    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                    request.addValue("Bearer " + UserDefaults.standard.string(forKey: "AccessToken")!, forHTTPHeaderField: "Authorization")
                    return request
            }
            .flatMap { request in
                URLSession.shared.rx.response(request: request)
            }
            .subscribe(onNext: { [weak self] response, data in
                guard response.statusCode == 201 else{
                    DispatchQueue.main.async {
                        single(.error(HTTPStatusCodes.BadRequest))
                    }
                    return
                }
                single(.success("Fuck"))
                return
                }, onError: { error in
                    print(error.localizedDescription)
            }).disposed(by: self.disposeBag)
            return Disposables.create()
        })
        
    }
    
}
