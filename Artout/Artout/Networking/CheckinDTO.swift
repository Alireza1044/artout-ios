//
//  CheckinDTO.swift
//  Artout
//
//  Created by Pooya Kabiri on 1/27/20.
//  Copyright © 2020 Pooya Kabiri. All rights reserved.
//

import Foundation

class CheckinSingle: Codable {
    let event_id : Int
    init(EventId: Int) {
        self.event_id = EventId
    }
}

class CheckinDTO: Codable {
    let checkin_user: UserDTO
    let checkin_event: EventDetailResponseDTO
    
    init(user: UserDTO, event: EventDetailResponseDTO) {
        self.checkin_user = user
        self.checkin_event = event
    }
}
