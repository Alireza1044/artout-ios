//
//  EventDetailViewModel.swift
//  Artout
//
//  Created by Alireza Moradi on 11/11/19.
//  Copyright © 2019 Pooya Kabiri. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class EventDetailViewModel{
    var eventImageURL: BehaviorSubject<String>
    var titleText: BehaviorSubject<String>
    var categoryText: BehaviorSubject<String>
    var dateText: BehaviorSubject<String>
    var descriptionText: BehaviorSubject<String>
    
    var event: BehaviorSubject<EventDetailEntity>
    
    var service = EventsService()
    var disposeBag = DisposeBag()
    var id: Int = 0
    
    init() {
        eventImageURL = BehaviorSubject<String>(value: "")
        titleText = BehaviorSubject<String>(value: "")
        categoryText = BehaviorSubject<String>(value: "")
        dateText = BehaviorSubject<String>(value: "")
        descriptionText = BehaviorSubject<String>(value: "")
        event = BehaviorSubject<EventDetailEntity>(value: EventDetailEntity(Id: 0, Title: "", Category: "", Description: "", StartDate: "", EndDate: "", Avatar: "", EventOwner: 0, Location: LocationEntity(latitude: 0.0, longitude: 0.0)))
    }
    
    func RequestEventDetail(id:Int) {
        service.RequestEventDetail(id: id).subscribe(onSuccess: { (event) in
            self.event.onNext(event)
            }).disposed(by: disposeBag)
    }
}
