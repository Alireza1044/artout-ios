//
//  NewEventViewModel.swift
//  Artout
//
//  Created by Alireza Moradi on 11/8/19.
//  Copyright © 2019 Pooya Kabiri. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class NewEventViewModel{
    
    var titleText: BehaviorSubject<String>
    var descriptionText: BehaviorSubject<String>
    var startDateText: BehaviorSubject<String>
    var endDateText: BehaviorSubject<String>
    var startTimeText: BehaviorSubject<String>
    var endTimeText: BehaviorSubject<String>
    var categoryText: BehaviorSubject<String>
    
    var isEmpty: Observable<Bool>
    var descriptionIsEmpty: Observable<Bool>
    var isLoading: PublishSubject<Bool>
    
    var addEventStatus: PublishSubject<Bool>
    var addEventErrorMessage: PublishSubject<String>
    
    var service = EventsService()
    var disposeBag = DisposeBag()
    
    init() {
        titleText = BehaviorSubject<String>(value: "")
        descriptionText = BehaviorSubject<String>(value: "")
        startDateText = BehaviorSubject<String>(value: "")
        endDateText = BehaviorSubject<String>(value: "")
        startTimeText = BehaviorSubject<String>(value: "")
        endTimeText = BehaviorSubject<String>(value: "")
        categoryText = BehaviorSubject<String>(value: "")
        isLoading = PublishSubject<Bool>()
        addEventStatus = PublishSubject<Bool>()
        addEventErrorMessage = PublishSubject<String>()
        
        self.isEmpty = Observable.combineLatest(titleText.asObservable(),categoryText.asObservable(),startDateText.asObservable(),endDateText.asObservable(),startTimeText.asObservable(),endTimeText.asObservable()) { a,b,c,d,e,f in
            a.isEmpty ||
                b.isEmpty ||
                c.isEmpty ||
                d.isEmpty ||
                e.isEmpty ||
                f.isEmpty
        }
        self.descriptionIsEmpty = descriptionText.map{ $0.count >= 50}.asObservable()
    }
    
    func AddEvent(){
        
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
        
        let entity = EventEntity(Title: try! titleText.value(),
                                 Category: try! categoryText.value(),
                                 Description: try! descriptionText.value(),
                                 StartDate: try! startDateText.value(),
                                 EndDate: try! endDateText.value(),
                                 Avatar: "",
                                 EventOwner: 1,
                                 Location: LocationEntity(latitude: 0.0, longitude: 0.0))
        
        _ = try? service.AddEvent(With: entity).subscribe{
            event in
            switch(event){
            case .success:
                self.addEventStatus.on(.next(true))
            case .error:
                self.addEventStatus.on(.next(false))
                self.addEventErrorMessage.on(.next("Failed to add event \(try! self.titleText.value())"))
                print("Failed to add event \(try! self.titleText.value())")
            }
        }.disposed(by: disposeBag)
    }
}
