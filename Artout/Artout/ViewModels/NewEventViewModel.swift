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
    
    var isEmpty: Observable<Bool>
    var descriptionIsEmpty: Observable<Bool>
    var isLoading: PublishSubject<Bool>
    var error: PublishSubject<String>
    
    var disposeBag = DisposeBag()
    
    init() {
        titleText = BehaviorSubject<String>(value: "")
        descriptionText = BehaviorSubject<String>(value: "")
        startDateText = BehaviorSubject<String>(value: "")
        endDateText = BehaviorSubject<String>(value: "")
        startTimeText = BehaviorSubject<String>(value: "")
        endTimeText = BehaviorSubject<String>(value: "")
        isLoading = PublishSubject<Bool>()
        error = PublishSubject<String>()
        
        self.isEmpty = Observable.combineLatest(titleText.asObservable(),startDateText.asObservable(),endDateText.asObservable(),startTimeText.asObservable(),endTimeText.asObservable()) { a,c,d,e,f in
            a.isEmpty ||
                c.isEmpty ||
                d.isEmpty ||
                e.isEmpty ||
                f.isEmpty
        }
        self.descriptionIsEmpty = descriptionText.map{ $0.count >= 50}.asObservable()
        
        print("Fucking: \(self.isEmpty)")
    }
    
    
}
