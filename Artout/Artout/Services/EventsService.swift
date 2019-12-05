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
    
    func RequestEvents () -> Single<[EventEntity]> {
        return Single<[EventEntity]>.create(subscribe: { single in
            Observable.from(optional: [String].self)
                .map {_ in
                    let url = URL(string: Endpoint.GCPServer.rawValue + APIPaths.FetchEvents.rawValue)!
                    var request = URLRequest(url: url)
                    request.httpMethod = HTTPMethod.GET.rawValue
                    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                    return request
            }
            .flatMap { request in
                URLSession.shared.rx.response(request: request)
            }
            .subscribe(onNext: { [weak self] response, data in
                guard response.statusCode == 200 else{
                    DispatchQueue.main.async {
                        single(.error(HTTPStatusCodes.CredenttialsNotValid))
                    }
                    return
                }
                guard let responseDTO = try? JSONDecoder().decode([DetailEventResponseDTO].self, from: data) else {
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
                    request.httpBody = JSONEncoder().encode(Event.ToDTO())
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
                        single(.error(HTTPStatusCodes.CredenttialsNotValid))
                    }
                    return
                }
                guard let responseDTO = JSONDecoder().decode(AddEventResponseDTO.self, from: data) else {
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
    
    func RequestEventDetail(id: Int) -> Single<EventEntity>{
        
        self.isLoading.onNext(true)
        
        return Single<EventEntity>.create(subscribe: { single in
            Observable.from(optional: [String].self)
                .map {_ in
                    let url = URL(string: Endpoint.GCPServer.rawValue + APIPaths.EventDetail.rawValue + "\(id)/")!
                    var request = URLRequest(url: url)
                    request.httpMethod = HTTPMethod.GET.rawValue
                    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
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
                guard let event = try? JSONDecoder().decode(DetailEventResponseDTO, from: data) else {
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
        
        let rawData = EventDTO(title: title, category: category, description: description, start_date: convertDate(date: start_date), end_date: convertDate(date: end_date), picture_url: picture_url, event_owner: event_owner, location: location)
        
        return Single<String>.create(subscribe: { single in
            Observable.from(optional: [String].self)
                .map {_ in
                    let url = URL(string: Endpoint.GCPServer.rawValue + APIPaths.EventDetail.rawValue + "\(id)/")!
                    var request = URLRequest(url: url)
                    request.httpMethod = HTTPMethod.PUT.rawValue
                    request.httpBody = JSONEncoder().encode(event.ToDTO())
                    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                    return request
            }
            .flatMap { request in
                URLSession.shared.rx.response(request: request)
            }
            .subscribe(onNext: { [weak self] response, data in
                guard response.statusCode == 200 else{
                    DispatchQueue.main.async {
                        self!.isLoading.onNext(false)
                        single(.error(HTTPStatusCodes.CredenttialsNotValid))
                    }
                    return
                }
                guard let responseDTO = JSONDecoder().decode(EventDetailDTO, from: data) else {
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
    
    func convertDate(date: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
        let newDate = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return  dateFormatter.string(from: newDate!)
    }
}
