//
//  EventDTO.swift
//  Artout
//
//  Created by Pooya Kabiri on 12/4/19.
//  Copyright © 2019 Pooya Kabiri. All rights reserved.
//

import Foundation

class EventDTO: Codable {
    var title: String
    var category: String
    var description: String
    var start_date: String
    var end_date: String
    var picture_url: String
    var event_owner: Int
    var location: LocationEntity
    
    
    init(title:String, category: String,description:String,start_date:String,end_date:String,picture_url:String,event_owner:Int,location:LocationEntity) {
        self.title = title
        self.category = category
        self.description = description
        self.picture_url = picture_url
        self.event_owner = event_owner
        self.location = location
        self.start_date = start_date
        self.end_date = end_date
    }
}

class EventDetailDTO: Codable {
    var title: String
    var category: String
    var description: String
    var start_date: String
    var end_date: String
    var picture_url: String
    var owner: Int
    var location: LocationEntity
    
    
    init(title:String, category: String,description:String,start_date:String,end_date:String,picture_url:String,owner:Int,location:LocationEntity ) {
        self.title = title
        self.category = category
        self.description = description
        self.picture_url = picture_url
        self.owner = owner
        self.location = location
        self.start_date = start_date
        self.end_date = end_date
        
    }
}

class AddEventResponseDTO: Codable {
    var id: Int
    var title: String
    var category: String
    var description: String
    var start_date: String
    var end_date: String
    var picture_url: String?
    var owner: Int
    var location: LocationEntity
    
    init(id: Int,title:String, category: String,description:String,start_date:String,end_date:String,picture_url:String,event_owner:Int,location:LocationEntity) {
        self.id = id
        self.title = title
        self.category = category
        self.description = description
        self.picture_url = picture_url
        self.owner = event_owner
        self.location = location
        self.start_date = start_date
        self.end_date = end_date
    }
}

class EventDetailResponseDTO: Codable {
    var id: Int
    var title: String
    var category: String
    var description: String
    var start_date: String
    var end_date: String
    var picture_url: String?
    var owner: Int
    var location: LocationEntity
    var checkin_count: Int
    var is_checked_in: Bool
    
    init(id: Int,title:String, category: String,description:String,start_date:String,end_date:String,picture_url:String,event_owner:Int,location:LocationEntity, checkin_count: Int, is_checked_in: Bool) {
        self.id = id
        self.title = title
        self.category = category
        self.description = description
        self.picture_url = picture_url
        self.owner = event_owner
        self.location = location
        self.start_date = start_date
        self.end_date = end_date
        self.checkin_count = checkin_count
        self.is_checked_in = is_checked_in
    }
}
