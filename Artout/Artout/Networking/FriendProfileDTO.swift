//
//  FriendProfileDTO.swift
//  Artout
//
//  Created by Alireza Moradi on 12/23/19.
//  Copyright © 2019 Pooya Kabiri. All rights reserved.
//

import Foundation

class FriendProfileDTO: Codable{
    
    var first_name: String
    var last_name: String?
    var username: String
    var avatar: String?
    var followers_count: Int
    var followings_count: Int
    var date_joined: String
    var is_private: Bool
    var events_count: Int
    var id: Int
    var state: Int
    
    var FullName: String {
        return first_name + " " + (last_name ?? "")
    }
    
    init(first_name: String, last_name: String, username: String, avatar: String, followers: Int, followings: Int, id: Int, date_joined: String, is_private: Bool, events_count: Int, state: Int) {
        self.username = username
        self.id = id
        self.avatar = avatar
        self.first_name = first_name
        self.last_name = last_name
        self.followers_count = followers
        self.followings_count = followings
        self.date_joined = date_joined
        self.is_private = is_private
        self.events_count = events_count
        self.state = state
    }
}
