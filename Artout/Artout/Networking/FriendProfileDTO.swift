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
    var last_name: String
    var username: String
    var avatar: String
    var followers: String
    var followings: String
    var id: Int
    
    var FullName: String {
        return first_name + " " + last_name
    }
    
    init(first_name: String, last_name: String, username: String, avatar: String, followers: String, followings: String, id: Int) {
        self.username = username
        self.id = id
        self.avatar = avatar
        self.first_name = first_name
        self.last_name = last_name
        self.followers = followers
        self.followings = followings
    }
}
