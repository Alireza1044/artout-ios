//
//  EventModel.swift
//  Artout
//
//  Created by Pooya Kabiri on 11/8/19.
//  Copyright © 2019 Pooya Kabiri. All rights reserved.
//

import Foundation
class EventEntity {
    var Title: String
    var Category: String
    var Description: String
    var StartDate: String
    var EndDate: String
    var Avatar: String
    var EventOwner: Int
    var Location: LocationEntity = ""
    
    init(Title: String,
         Category: String,
         Description: String,
         StartDate: String,
         EndDate: String,
         Avatar: String,
         EventOwner: Int,
         Location: LocationEntity) {
        self.Avatar = Avatar
        self.EndDate = EndDate
        self.StartDate = StartDate
        self.Category = Category
        self.EventOwner = EventOwner
        self.Location = Location
        self.Description = Description
    }
    
}
class EventDetailEntity {
    var Id: Int
    var Title: String
    var Category: String
    var Description: String
    var StartDate: String
    var EndDate: String
    var Avatar: String
    var EventOwner: Int
    var Location: LocationEntity = ""
    
    init(Id: Int,
         Title: String,
         Category: String,
         Description: String,
         StartDate: String,
         EndDate: String,
         Avatar: String,
         EventOwner: Int,
         Location: LocationEntity) {
        self.Id = Id
        self.Avatar = Avatar
        self.EndDate = EndDate
        self.StartDate = StartDate
        self.Category = Category
        self.EventOwner = EventOwner
        self.Location = Location
        self.Description = Description
    }
    
}



