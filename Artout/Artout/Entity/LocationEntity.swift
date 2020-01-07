//
//  LocationEntity.swift
//  Artout
//
//  Created by Alireza Moradi on 11/10/19.
//  Copyright © 2019 Pooya Kabiri. All rights reserved.
//

import Foundation

class LocationEntity: Codable {
    var longitude: Float
    var latitude: Float
    var id: Int
    
    init(latitude: Float, longitude: Float, id: Int) {
        self.latitude = latitude
        self.longitude = longitude
        self.id = id
    }
}
