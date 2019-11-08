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
    var adddEventErrorMessage: PublishSubject<String>
    
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
        adddEventErrorMessage = PublishSubject<String>()
        
        self.isEmpty = Observable.combineLatest(titleText.asObservable(),categoryText.asObservable(),startDateText.asObservable(),endDateText.asObservable(),startTimeText.asObservable(),endTimeText.asObservable()) { a,b,c,d,e,f in
            a.isEmpty ||
                b.isEmpty ||
                c.isEmpty ||
                d.isEmpty ||
                e.isEmpty ||
                f.isEmpty
        }
        self.descriptionIsEmpty = descriptionText.map{ $0.count >= 50}.asObservable()
        
        print("Fucking: \(self.isEmpty)")
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
        
        _ = try? service.AddEvents(title: titleText.value(),category: categoryText.value(), description: descriptionText.value(), start_date: startDateText.value(), end_date: endDateText.value(), picture_url: "", event_owner: 1).subscribe{
            event in
            switch(event){
            case .success:
                self.addEventStatus.on(.next(true))
            case .error:
                self.addEventStatus.on(.next(false))
                self.adddEventErrorMessage.on(.next("Failed to add event \(try! self.titleText.value())"))
            }
        }.disposed(by: disposeBag)
    }
}
