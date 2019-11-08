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
    let Refresh: PublishSubject<Bool>
    let Events: [EventModel]?
    
    init() {
        self.Refresh = PublishSubject<Bool>()
        Events = []
    }
    
    func FetchEvents() {
        
    }
}
