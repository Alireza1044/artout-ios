//
//  FriendProfileEntity.swift
//  Artout
//
//  Created by Alireza Moradi on 12/23/19.
//  Copyright © 2019 Pooya Kabiri. All rights reserved.
//

import Foundation

class FriendProfileEntity {
    var FirstName: String
    var LastName: String?
    var UserName: String
    var Avatar: String?
    var FollowerCount: Int
    var FollowingCount: Int
    var State: Int
    var Id: Int
    
    var FullName: String {
        return FirstName + " " + (LastName ?? "")
    }
    
    init(FirstName: String, LastName: String?, UserName: String, Avatar: String?, FollowerCount: Int, FollowingCount: Int, Id: Int, State: Int) {
        self.UserName = UserName
        self.Id = Id
        self.Avatar = Avatar
        self.FirstName = FirstName
        self.LastName = LastName
        self.FollowerCount = FollowerCount
        self.FollowingCount = FollowingCount
        self.State = State
    }
}
