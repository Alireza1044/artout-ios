//
//  FriendEntity.swift
//  Artout
//
//  Created by Pooya Kabiri on 12/7/19.
//  Copyright © 2019 Pooya Kabiri. All rights reserved.
//
import Foundation

enum FollowingState: String {
    case Following = "Following"
    case Requested = "Requested"
    case NotFollowing = "Follow"
}

class FriendEntity {
    var User: UserEntity
    var State: FollowingState
    
    init(User: UserEntity, State: FollowingState) {
        self.User = User
        self.State = State
    }
}
