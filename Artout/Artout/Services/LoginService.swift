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
    let Formatter = DTOFormatter<LoginDTO, LoginResponseDTO>()
    let disposeBag = DisposeBag()
    
    func Login (With username: String, And password: String) -> Single<String> {
        let rawData = LoginDTO(username: username, password: password)
        return Single<String>.create(subscribe: { single in
            Observable.from(optional: [String].self)
                .map {_ in
                let url = URL(string: Endpoint.GCPServer.rawValue + APIPaths.Login.rawValue)!
                var request = URLRequest(url: url)
                request.httpMethod = HTTPMethod.POST.rawValue
                request.httpBody = self.Formatter.Encode(objDTO: rawData)
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                return request
            }
            .flatMap { request in
                URLSession.shared.rx.response(request: request)
            }
            .subscribe(onNext: { [weak self] response, data in
                guard response.statusCode == 200 else{
                    DispatchQueue.main.async {
                        single(.error(NetworkingError.CredenttialsNotValid))
                    }
                    return
                }
                guard let responseDTO = self!.Formatter.Decode(data: data) else {
                    DispatchQueue.main.async {
                        single(.error(NetworkingError.InternalServerError))
                    }
                    return
                }
                self?.TokenHandler.saveToken(access: responseDTO.access, refresh: responseDTO.refresh)
                single(.success(responseDTO.access))
                return
                }, onError: { error in
                    print(error.localizedDescription)
            }).disposed(by: self.disposeBag)
            return Disposables.create()
        })
    }
}
