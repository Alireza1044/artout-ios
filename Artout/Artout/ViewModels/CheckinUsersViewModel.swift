//
//  CheckinUsersViewModel.swift
//  Artout
//
//  Created by Pooya Kabiri on 1/7/20.
//  Copyright © 2020 Pooya Kabiri. All rights reserved.
//

import Foundation
import RxSwift

class CheckinUsersViewModel {
    let refresh: PublishSubject<Bool>
    var users: [UserEntity]
    var service = EventsService()
    var disposeBag = DisposeBag()
    
    init() {
        refresh = PublishSubject<Bool>()
        users = []
        
    }
    func FetchEventCheckins(for eventId: Int) {
        //Service Method Call
    }
}



