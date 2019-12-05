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
    var startDateText: BehaviorSubject<String>
    var endDateText: BehaviorSubject<String>
    var startTimeText: BehaviorSubject<String>
    var endTimeText: BehaviorSubject<String>
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
        startDateText = BehaviorSubject<String>(value: "")
        endDateText = BehaviorSubject<String>(value: "")
        startTimeText = BehaviorSubject<String>(value: "")
        endTimeText = BehaviorSubject<String>(value: "")
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
    
    func EditEvent(id: Int) {
        
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
        
        try? service.EditEvent(id: id, title: self.titleText.value(), category: self.categoryText.value(), description: self.descriptionText.value(), start_date: self.startDateText.value(), end_date: self.endDateText.value(), picture_url: self.eventImageURL.value(), event_owner: 1).subscribe(onSuccess: { response in
            self.addEventStatus.on(.next(true))
        }) { error in
            self.addEventStatus.on(.next(false))
        }.disposed(by: disposeBag)
    }
}
