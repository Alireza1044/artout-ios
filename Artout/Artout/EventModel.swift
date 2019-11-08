//
//  EventModel.swift
//  Artout
//
//  Created by Pooya Kabiri on 11/8/19.
//  Copyright © 2019 Pooya Kabiri. All rights reserved.
//

import Foundation
struct EventModel: Codable {
    var title: String
    var category: String
    var description: String
    var start_date: String
    var end_date: String
    var picture_url: String
    var event_owner: Int
    var location: [String:Float]
    
    init(title:String, category: String,description:String,start_date:String,end_date:String,picture_url:String,event_owner:Int,location:[String:Float]) {
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

struct EventResponse: Codable {
    var id: Int
    var title: String
    var category: String
    var description: String
    var start_date: String
    var end_date: String
    var picture_url: String
    var event_owner: Int
    var location: [String:Float]
    
    init(id: Int,title:String, category: String,description:String,start_date:String,end_date:String,picture_url:String,event_owner:Int,location:[String:Float]) {
        self.id = id
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


