//
//  TokenService.swift
//  Artout
//
//  Created by Pooya Kabiri on 10/31/19.
//  Copyright © 2019 Pooya Kabiri. All rights reserved.
//

import Foundation
import RxSwift

class LoginService {

    let TokenHandler = TokenService()
    let disposeBag = DisposeBag()
    
    func Login (With entity: LoginEntity) -> Single<String> {
        return Single<String>.create(subscribe: { single in
            Observable.from(optional: [String].self)
                .map {_ in
                let url = URL(string: Endpoint.GCPServer.rawValue + APIPaths.Login.rawValue)!
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
                guard response.statusCode == 200 else{
                    DispatchQueue.main.async {
                        single(.error(HTTPStatusCodes.BadRequest))
                    }
                    return
                }
                guard let response = try? JSONDecoder().decode(LoginResponseDTO.self, from: data) else {
                    DispatchQueue.main.async {
                        single(.error(HTTPStatusCodes.InternalServerError))
                    }
                    return
                }
                self?.TokenHandler.saveToken(access: response.access, refresh: response.refresh, userId: response.id)
                single(.success(response.access))
                return
                }, onError: { error in
                    print(error.localizedDescription)
            }).disposed(by: self.disposeBag)
            return Disposables.create()
        })
    }
    func RefreshToken () -> Single<String> {
        let entity = RefreshDTO(Refresh: TokenHandler.GetRefreshToken())
        return Single<String>.create(subscribe: { single in
            Observable.from(optional: [String].self)
                .map {_ in
                    let url = URL(string: Endpoint.GCPServer.rawValue + APIPaths.Refresh.rawValue)!
                    var request = URLRequest(url: url)
                    request.httpMethod = HTTPMethod.POST.rawValue
                    request.httpBody = try? JSONEncoder().encode(entity)
                    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
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
                guard let response = try? JSONDecoder().decode(RefreshResponseDTO.self, from: data) else {
                    DispatchQueue.main.async {
                        single(.error(HTTPStatusCodes.InternalServerError))
                    }
                    return
                }
                self?.TokenHandler.RenewAccessToken(access: response.access)
                single(.success(response.access))
                return
                }, onError: { error in
                    print(error.localizedDescription)
            }).disposed(by: self.disposeBag)
            return Disposables.create()
        })
    }
}
