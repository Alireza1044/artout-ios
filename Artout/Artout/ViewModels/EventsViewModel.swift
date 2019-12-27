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
    var filteredEvents: [EventDetailEntity]
    var service = EventsService()
    var disposeBag = DisposeBag()
    
    init() {
        self.refresh = PublishSubject<Bool>()
        events = []
        filteredEvents = []
    }
    func filterContentForSearchText(_ searchText: String) {
        filteredEvents = events.filter { (event: EventDetailEntity) -> Bool in
            return event.Title.lowercased().contains(searchText.lowercased())
        }
        
        self.refresh.onNext(true)
    }
    
    func filterContentForSearchText(_ searchText: String, for context: SearchContext? = nil) {
        switch context {
            case .Events:
                filteredEvents = events.filter { (event: EventDetailEntity) -> Bool in
                    return event.Title.lowercased().contains(searchText.lowercased())
            }
            case .Users:
                filteredEvents = events.filter { (event: EventDetailEntity) -> Bool in
                    return event.Category.lowercased().contains(searchText.lowercased())
            }
            default:
                return
        }
        
        self.refresh.onNext(true)
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
