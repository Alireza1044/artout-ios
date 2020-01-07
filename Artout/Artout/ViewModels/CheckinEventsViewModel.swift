//
//  CheckinEventsViewModel.swift
//  Artout
//
//  Created by Pooya Kabiri on 1/7/20.
//  Copyright © 2020 Pooya Kabiri. All rights reserved.
//

import Foundation
import RxSwift

class CheckinEventsViewModel {
    let refresh: PublishSubject<Bool>
    var events: [EventDetailEntity]
    var service = EventsService()
    var disposeBag = DisposeBag()
    
    init() {
        refresh = PublishSubject<Bool>()
        events = []
        
    }
    func FetchUserCheckins(for userId: Int) {
        //Service Method Call
    }
}



