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
    var description: String
    var start_date: String
    var end_date: String
    var picture_url: String
    var event_owner: Int
    var location: [String:String]
    
    init(title:String,description:String,start_date:String,end_date:String,picture_url:String,event_owner:Int,location:[String:String]) {
        self.title = title
        self.description = description
        self.start_date = start_date
        self.end_date = end_date
        self.picture_url = picture_url
        self.event_owner = event_owner
        self.location = location
    }
}
