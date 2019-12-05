//
//  EventsViewModel.swift
//  Artout
//
//  Created by Pooya Kabiri on 11/8/19.
//  Copyright © 2019 Pooya Kabiri. All rights reserved.
//

import Foundation
import RxSwift

class EventsViewModel {
    let refresh: PublishSubject<Bool>
    var events: [EventDetailEntity]
    var service = EventsService()
    var disposeBag = DisposeBag()
    
    init() {
        self.refresh = PublishSubject<Bool>()
        events = []
    }
    
    func AddEvent(event: EventDetailEntity) {
        self.events.append(event)
        self.refresh.onNext(true)
    }
    func FetchEvents() {
        service.RequestEvents()
            .subscribe(onSuccess: { data in
                self.events = data.reversed()
                self.refresh.onNext(true)
            }).disposed(by: disposeBag)
    }
}
