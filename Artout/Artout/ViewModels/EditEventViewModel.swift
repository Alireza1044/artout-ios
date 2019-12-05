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
    
    var event: BehaviorSubject<EventDetailEntity>
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
        event = BehaviorSubject<EventDetailEntity>(value: EventDetailEntity(Id: 0, Title: "", Category: "", Description: "", StartDate: "", EndDate: "", Avatar: "", EventOwner: 0, Location: LocationEntity(latitude: 0.0, longitude: 0.0)))
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
        let event = try? EventDetailEntity(Id: id, Title: self.titleText.value(), Category: self.categoryText.value(), Description: self.descriptionText.value(), StartDate: self.startDateText.value(), EndDate: self.endDateText.value(), Avatar: self.eventImageURL.value(), EventOwner: 1, Location: LocationEntity(latitude: 1, longitude: 1))
        
        
        try? service.EditEvent(for: event!).subscribe(onSuccess: { response in
            self.addEventStatus.on(.next(true))
        }) { error in
            self.addEventStatus.on(.next(false))
        }.disposed(by: disposeBag)
    }
}
