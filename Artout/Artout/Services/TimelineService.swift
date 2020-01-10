//
//  TimelineService.swift
//  Artout
//
//  Created by Alireza Moradi on 1/10/20.
//  Copyright © 2020 Pooya Kabiri. All rights reserved.
//

import Foundation
import RxSwift

class TimelineService{
    var disposeBag = DisposeBag()
    
    func RequestTimeline (url:URL) -> Single<[EventDetailEntity]> {
        return Single<[EventDetailEntity]>.create(subscribe: { single in
            Observable.from(optional: [String].self)
                .map {_ in
                    var request = URLRequest(url: url)
                    request.httpMethod = HTTPMethod.GET.rawValue
                    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                    request.addValue("Bearer " + UserDefaults.standard.string(forKey: "AccessToken")!, forHTTPHeaderField: "Authorization")
                    return request
            }
        .flatMap { request in
                URLSession.shared.rx.response(request: request)
            }
            .subscribe(onNext: {
                response, data in
                guard response.statusCode == 200 else{
                    DispatchQueue.main.async {
                        single(.error(HTTPStatusCodes.Unauthorized))
                    }
                    return
                }
                guard let responseDTO = try? JSONDecoder().decode([EventDetailResponseDTO].self, from: data) else {
                    DispatchQueue.main.async {
                        single(.error(HTTPStatusCodes.InternalServerError))
                    }
                    return
                }
                single(.success(responseDTO.map { event in
                    event.ToEntity()
                }))
                return
                }, onError: { error in
                    print(error.localizedDescription)
            }).disposed(by: self.disposeBag)
            return Disposables.create()
        })
    }
}
