//
//  CheckinService.swift
//  Artout
//
//  Created by Pooya Kabiri on 1/27/20.
//  Copyright © 2020 Pooya Kabiri. All rights reserved.
//

import Foundation
import RxSwift

class CheckinService {
    var disposeBag = DisposeBag()
    func Checkin(with eventId: Int, for url: String = "\(Endpoint.GCPServer.rawValue)checkins/") -> Single<Bool>{
        let body = CheckinSingle(EventId: eventId)
        return Single<Bool>.create(subscribe: { single in
            Observable.from(optional: [String].self)
                .map { _ in
                    var request = URLRequest(url: URL(string: url)!)
                    request.httpMethod = HTTPMethod.POST.rawValue
                    request.httpBody = try! JSONEncoder().encode(body)
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
    func GetCheckinsForUser(with userId: Int, for url: String = "\(Endpoint.GCPServer.rawValue)checkins/") -> Single<[CheckinEntity]>{
        return Single<[CheckinEntity]>.create(subscribe: { single in
            Observable.from(optional: [String].self)
                .map { _ in
                    var request = URLRequest(url: URL(string: url + "?user=\(userId)")!)
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
                let vals = try! JSONDecoder().decode([CheckinDTO].self, from: data)
                    .map({ (checkinDTO) in
                        checkinDTO.ToCheckinEntity()
                    })
                single(.success(vals))
                return
                }, onError: { error in
                    print(error.localizedDescription)
            }).disposed(by: self.disposeBag)
            return Disposables.create()
        })
        
    }
    func GetCheckinsForEvent(with eventId: Int, for url: String = "\(Endpoint.GCPServer.rawValue)checkins/") -> Single<[CheckinEntity]>{
        return Single<[CheckinEntity]>.create(subscribe: { single in
            Observable.from(optional: [String].self)
                .map { _ in
                    var request = URLRequest(url: URL(string: url + "?event=\(eventId)")!)
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
                let vals = try! JSONDecoder().decode([CheckinDTO].self, from: data)
                    .map({ (checkinDTO) in
                        checkinDTO.ToCheckinEntity()
                    })
                single(.success(vals))
                return
                }, onError: { error in
                    print(error.localizedDescription)
            }).disposed(by: self.disposeBag)
            return Disposables.create()
        })
        
    }
}
