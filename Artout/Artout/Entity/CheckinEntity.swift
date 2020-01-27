//
//  CheckinEntity.swift
//  Artout
//
//  Created by Pooya Kabiri on 1/27/20.
//  Copyright © 2020 Pooya Kabiri. All rights reserved.
//

import Foundation

class CheckinEntity {
    
    let User: UserEntity
    let Event: EventDetailEntity
    
    init(User: UserEntity, Event: EventDetailEntity) {
        self.User = User
        self.Event = Event
    }
    
}
