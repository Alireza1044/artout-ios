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
    
    let Formatter = DTOFormatter<EventModel, EventResponse>()
    let isLoading = PublishSubject<Bool>()
    let disposeBag = DisposeBag()
    
    func RequestEvents () -> Single<[EventResponse]> {
        return Single<[EventResponse]>.create(subscribe: { single in
            Observable.from(optional: [String].self)
                .map {_ in
                    let url = URL(string: Endpoint.GCPServer.rawValue + APIPaths.FetchEvents.rawValue)!
                    var request = URLRequest(url: url)
                    request.httpMethod = HTTPMethod.GET.rawValue
                    //                    request.httpBody = self.Formatter.Encode(objDTO: rawData)
                    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                    return request
            }
            .flatMap { request in
                URLSession.shared.rx.response(request: request)
            }
            .subscribe(onNext: { [weak self] response, data in
                guard response.statusCode == 200 else{
                    DispatchQueue.main.async {
                        //                        self!.isLoading.onNext(false)
                        single(.error(NetworkingError.CredenttialsNotValid))
                    }
                    return
                }
                let decoder = JSONDecoder()
                guard let responseDTO = try? decoder.decode([EventResponse].self, from: data) else {
                    DispatchQueue.main.async {
                        //                        self!.isLoading.onNext(false)
                        single(.error(NetworkingError.InternalServerError))
                    }
                    return
                }
                single(.success(responseDTO))
                return
                }, onError: { error in
                    print(error.localizedDescription)
            }).disposed(by: self.disposeBag)
            return Disposables.create()
        })
    }
    
    func AddEvent (title:String, category: String,description:String,start_date:String,end_date:String,picture_url:String,event_owner:Int,location:LocationEntity = LocationEntity(latitude: 0.0, longitude: 0.0)) -> Single<String> {
        
        isLoading.onNext(true)
        
        let rawData = EventModel(title: title, category: category, description: description, start_date: convertDate(date: start_date), end_date: convertDate(date: end_date), picture_url: picture_url, event_owner: event_owner, location: location)
        
        return Single<String>.create(subscribe: { single in
            Observable.from(optional: [String].self)
                .map {_ in
                    let url = URL(string: Endpoint.GCPServer.rawValue + APIPaths.AddEvent.rawValue)!
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
                guard response.statusCode == 201 else{
                    DispatchQueue.main.async {
                        self!.isLoading.onNext(false)
                        single(.error(NetworkingError.CredenttialsNotValid))
                    }
                    return
                }
                guard let responseDTO = self!.Formatter.Decode(data: data) else {
                    DispatchQueue.main.async {
                        self!.isLoading.onNext(false)
                        single(.error(NetworkingError.InternalServerError))
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
    
    func RequestEventDetail(id: Int) -> Single<EventResponse>{
        
        self.isLoading.onNext(true)
        
        return Single<EventResponse>.create(subscribe: { single in
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
                        single(.error(NetworkingError.InternalServerError))
                        self?.isLoading.onNext(false)
                    }
                    return
                }
                guard let responseDTO = self!.Formatter.Decode(data: data) else {
                    DispatchQueue.main.async {
                        single(.error(NetworkingError.InternalServerError))
                        self?.isLoading.onNext(false)
                    }
                    return
                }
                DispatchQueue.main.async {
                    self?.isLoading.onNext(false)
                }
                single(.success(responseDTO))
                return
                }, onError: { error in
                    print(error.localizedDescription)
            }).disposed(by: self.disposeBag)
            return Disposables.create()
        })
    }
    
    func EditEvent (id: Int, title:String, category: String,description:String,start_date:String,end_date:String,picture_url:String,event_owner:Int,location:LocationEntity = LocationEntity(latitude: 0.0, longitude: 0.0)) -> Single<String> {
        
        isLoading.onNext(true)
        
        let rawData = EventModel(title: title, category: category, description: description, start_date: convertDate(date: start_date), end_date: convertDate(date: end_date), picture_url: picture_url, event_owner: event_owner, location: location)
        
        return Single<String>.create(subscribe: { single in
            Observable.from(optional: [String].self)
                .map {_ in
                    let url = URL(string: Endpoint.GCPServer.rawValue + APIPaths.EventDetail.rawValue + "\(id)/")!
                    var request = URLRequest(url: url)
                    request.httpMethod = HTTPMethod.PUT.rawValue
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
                        self!.isLoading.onNext(false)
                        single(.error(NetworkingError.CredenttialsNotValid))
                    }
                    return
                }
                guard let responseDTO = self!.Formatter.Decode(data: data) else {
                    DispatchQueue.main.async {
                        self!.isLoading.onNext(false)
                        single(.error(NetworkingError.InternalServerError))
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
    
    //    func Login (With username: String, And password: String) -> Single<String> {
    //        let rawData = LoginDTO(username: username, password: password)
    //        return Single<String>.create(subscribe: { single in
    //            Observable.from(optional: [String].self)
    //                .map {_ in
    //                    let url = URL(string: Endpoint.GCPServer.rawValue + APIPaths.Login.rawValue)!
    //                    var request = URLRequest(url: url)
    //                    request.httpMethod = HTTPMethod.POST.rawValue
    //                    request.httpBody = self.Formatter.Encode(objDTO: rawData)
    //                    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    //                    return request
    //            }
    //            .flatMap { request in
    //                URLSession.shared.rx.response(request: request)
    //            }
    //            .subscribe(onNext: { [weak self] response, data in
    //                guard response.statusCode == 200 else{
    //                    DispatchQueue.main.async {
    //                        single(.error(NetworkingError.CredenttialsNotValid))
    //                    }
    //                    return
    //                }
    //                guard let responseDTO = try? self!.Formatter.Decode(data: data) else {
    //                    DispatchQueue.main.async {
    //                        single(.error(NetworkingError.InternalServerError))
    //                    }
    //                    return
    //                }
    //                single(.success(responseDTO.access))
    //                return
    //                }, onError: { error in
    //                    print(error.localizedDescription)
    //            }).disposed(by: self.disposeBag)
    //            return Disposables.create()
    //        })
    //    }
}
