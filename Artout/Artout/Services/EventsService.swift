//
//  EventsService.swift
//  Artout
//
//  Created by Pooya Kabiri on 11/8/19.
//  Copyright © 2019 Pooya Kabiri. All rights reserved.
//

import Foundation
import RxSwift

class EventsService {
    
    let isLoading = PublishSubject<Bool>()
    let disposeBag = DisposeBag()
    
    func RequestEvents (url:URL) -> Single<[EventDetailEntity]> {
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
    func RequestOwnEvents () -> Single<[EventDetailEntity]> {
        let myId = UserDefaults.standard.string(forKey: "UserId")!
        return Single<[EventDetailEntity]>.create(subscribe: { single in
            Observable.from(optional: [String].self)
                .map {_ in
                    let url = URL(string: Endpoint.GCPServer.rawValue + APIPaths.AddEvent.rawValue + "?owner=\(myId)")!
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
    func AddEvent (With Event: EventEntity) -> Single<String> {
        
        isLoading.onNext(true)
        
        return Single<String>.create(subscribe: { single in
            Observable.from(optional: [String].self)
                .map {_ in
                    let url = URL(string: Endpoint.GCPServer.rawValue + APIPaths.AddEvent.rawValue)!
                    var request = URLRequest(url: url)
                    request.httpMethod = HTTPMethod.POST.rawValue
                    request.httpBody = try? JSONEncoder().encode(Event.ToDTO())
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
                        self!.isLoading.onNext(false)
                        single(.error(HTTPStatusCodes.BadRequest))
                    }
                    return
                }
                guard let responseDTO = try? JSONDecoder().decode(AddEventResponseDTO.self, from: data) else {
                    DispatchQueue.main.async {
                        self!.isLoading.onNext(false)
                        single(.error(HTTPStatusCodes.InternalServerError))
                    }
                    return
                }
                single(.success(responseDTO.title))
                DispatchQueue.main.async {
                    self!.isLoading.onNext(false)
                }
                return
                }, onError: { error in
                    print(error.localizedDescription)
            }).disposed(by: self.disposeBag)
            return Disposables.create()
        })
    }
    
    func RequestEventDetail(id: Int) -> Single<EventDetailEntity> {
        
        self.isLoading.onNext(true)
        
        return Single<EventDetailEntity>.create(subscribe: { single in
            Observable.from(optional: [String].self)
                .map {_ in
                    let url = URL(string: Endpoint.GCPServer.rawValue + APIPaths.AddEvent.rawValue + "\(id)/")!
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
                        single(.error(HTTPStatusCodes.InternalServerError))
                        self?.isLoading.onNext(false)
                    }
                    return
                }
                guard let event = try? JSONDecoder().decode(EventDetailResponseDTO.self, from: data) else {
                    DispatchQueue.main.async {
                        single(.error(HTTPStatusCodes.InternalServerError))
                        self?.isLoading.onNext(false)
                    }
                    return
                }
                DispatchQueue.main.async {
                    self?.isLoading.onNext(false)
                }
                single(.success(event.ToEntity()))
                return
                }, onError: { error in
                    print(error.localizedDescription)
            }).disposed(by: self.disposeBag)
            return Disposables.create()
        })
    }
    
    func EditEvent (for event: EventDetailEntity) -> Single<String> {
        
        isLoading.onNext(true)
        
        return Single<String>.create(subscribe: { single in
            Observable.from(optional: [String].self)
                .map {_ in
                    let url = URL(string: Endpoint.GCPServer.rawValue + APIPaths.AddEvent.rawValue + "\(event.Id)/")!
                    var request = URLRequest(url: url)
                    request.httpMethod = HTTPMethod.PUT.rawValue
                    let dto = event.ToDTO()
                    request.httpBody = try? JSONEncoder().encode(dto)
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
                        self!.isLoading.onNext(false)
                        single(.error(HTTPStatusCodes.BadRequest))
                    }
                    return
                }
                guard let responseDTO = try? JSONDecoder().decode(EventDetailDTO.self, from: data) else {
                    DispatchQueue.main.async {
                        self!.isLoading.onNext(false)
                        single(.error(HTTPStatusCodes.InternalServerError))
                    }
                    return
                }
                single(.success(responseDTO.title))
                DispatchQueue.main.async {
                    self!.isLoading.onNext(false)
                }
                return
                }, onError: { error in
                    print(error.localizedDescription)
            }).disposed(by: self.disposeBag)
            return Disposables.create()
        })
    }
    
    
}
