//
//  AddFriendDTO.swift
//  Artout
//
//  Created by Pooya Kabiri on 12/16/19.
//  Copyright © 2019 Pooya Kabiri. All rights reserved.
//

import Foundation

class AddFriendDTO: Codable{
    var user: String
    init(Username: String) {
        self.user = Username
    }
}
