//
//  CheckinEventsViewModel.swift
//  Artout
//
//  Created by Pooya Kabiri on 1/7/20.
//  Copyright © 2020 Pooya Kabiri. All rights reserved.
//

import Foundation
import RxSwift

class CheckinViewModel {
    let refresh: PublishSubject<Bool>
    var events: [EventDetailEntity]
    var users: [UserEntity]
    var service = CheckinService()
    var disposeBag = DisposeBag()
    var checkinObjects: [CheckinEntity]
    
    var reload = PublishSubject<Bool>()
    
    init() {
        refresh = PublishSubject<Bool>()
        events = []
        users = []
        checkinObjects = []
    }
    func FetchUserCheckins(for userId: Int) {
        _ = service.GetCheckinsForUser(with: userId)
            .subscribe(onSuccess: { (data) in
                self.checkinObjects = data
                self.reload.onNext(true)
//                print("Shit")
        })
    }
    func FetchEventCheckins(for eventId: Int) {
        _ = service.GetCheckinsForEvent(with: eventId)
            .subscribe(onSuccess: { (data) in
                self.checkinObjects = data
                self.reload.onNext(true)
            })
    }
    func Checkin(for eventId: Int) {
        _ = service.Checkin(with: eventId)
            .subscribe(onSuccess: { (result) in
                self.reload.onNext(result)
            })
    }
    func Checkout(for eventId: Int) {
        //Service Method Call
    }
}



