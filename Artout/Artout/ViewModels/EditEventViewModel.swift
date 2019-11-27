//
//  EditEventViewModel.swift
//  Artout
//
//  Created by Alireza Moradi on 11/26/19.
//  Copyright © 2019 Pooya Kabiri. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class EditEventViewModel{
    var eventImageURL: BehaviorSubject<String>
    var titleText: BehaviorSubject<String>
    var categoryText: BehaviorSubject<String>
    var dateText: BehaviorSubject<String>
    var descriptionText: BehaviorSubject<String>
    
    var isLoading: PublishSubject<Bool>
    var addEventStatus: PublishSubject<Bool>
    
    var event: BehaviorSubject<EventResponse>
    var disposeBag = DisposeBag()
    var service = EventsService()
    
    init() {
        eventImageURL = BehaviorSubject<String>(value: "")
        titleText = BehaviorSubject<String>(value: "")
        categoryText = BehaviorSubject<String>(value: "")
        dateText = BehaviorSubject<String>(value: "")
        descriptionText = BehaviorSubject<String>(value: "")
        isLoading = PublishSubject<Bool>()
        addEventStatus = PublishSubject<Bool>()
        event = BehaviorSubject<EventResponse>(value: EventResponse(id: 0, title: "", category: "", description: "", start_date: "", end_date: "", picture_url: "", event_owner: 0, location: LocationEntity(latitude: 0.0, longitude: 0.0)))
    }
    
    func RequestEventDetail(id:Int) {
        
        service.isLoading.subscribe({
            switch $0{
            case .next(true):
                self.isLoading.on(.next(true))
            case .next(false):
                self.isLoading.on(.next(false))
            default:
                self.isLoading.on(.next(false))
            }
        }).disposed(by: disposeBag)
        
        service.RequestEventDetail(id: id).subscribe(onSuccess: { event in
            self.event.onNext(event)
        }).disposed(by: disposeBag)
    }
}
