//
//  SearchService.swift
//  Artout
//
//  Created by Alireza Moradi on 12/27/19.
//  Copyright © 2019 Pooya Kabiri. All rights reserved.
//

import Foundation
import RxSwift

class SearchService {
    var disposeBag = DisposeBag()
    func fetchUsersList() -> Single<[UserEntity]>{
        
        return Single<[UserEntity]>.create(subscribe: { single in
            Observable.from(optional: [String].self)
                .map {_ in
                    let url = URL(string: Endpoint.GCPServer.rawValue + APIPaths.Users.rawValue)!
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
}
