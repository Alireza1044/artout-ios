//
//  FollowingService.swift
//  Artout
//
//  Created by Alireza Moradi on 12/9/19.
//  Copyright © 2019 Pooya Kabiri. All rights reserved.
//

import Foundation
import RxSwift

class FollowingService {
    
    var disposeBag = DisposeBag()
    
    func fetchFollowingList(entity: FriendEntity) -> Single<[FriendEntity]>{
        
        return Single<[FriendEntity]>.create(subscribe: { single in
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
                guard let response = try? JSONDecoder().decode([FriendDTO].self, from: data) else {
                    DispatchQueue.main.async {
                        single(.error(HTTPStatusCodes.InternalServerError))
                    }
                    return
                }
                single(.success(response.map { friend in
                    friend.ToEntity()
                }))
                return
                }, onError: { error in
                    print(error.localizedDescription)
            }).disposed(by: self.disposeBag)
            return Disposables.create()
        })
        
    }
}
