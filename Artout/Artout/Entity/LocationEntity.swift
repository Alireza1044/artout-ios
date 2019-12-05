//
//  LocationEntity.swift
//  Artout
//
//  Created by Alireza Moradi on 11/10/19.
//  Copyright © 2019 Pooya Kabiri. All rights reserved.
//

import Foundation

class LocationEntity: Codable {
    var Longitude: Float
    var Latitude: Float
    
    init(latitude: Float, longitude: Float) {
        self.Latitude = latitude
        self.Longitude = longitude
    }
}
