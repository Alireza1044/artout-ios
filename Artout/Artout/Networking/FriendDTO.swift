//
//  FriendDTO.swift
//  Artout
//
//  Created by Alireza Moradi on 12/8/19.
//  Copyright © 2019 Pooya Kabiri. All rights reserved.
//

import Foundation


class FriendDTO: Codable {
    var User: UserDTO
    var State: FollowingState
    
    init(User: UserDTO, State: FollowingState) {
        self.User = User
        self.State  = State
    }
}
