//
//  Mappers.swift
//  Artout
//
//  Created by Pooya Kabiri on 12/4/19.
//  Copyright © 2019 Pooya Kabiri. All rights reserved.
//

import Foundation

extension LoginEntity {
    func ToDTO() -> LoginDTO {
        return LoginDTO(username: self.Username, password: self.Password)
    }
}
extension RegisterEntity {
    func ToDTO() -> RegisterDTO {
        return RegisterDTO(username: self.Username,
                           firstName: self.FirstName,
                           lastName: self.LastName,
                           email: self.Email,
                           password: self.Password)
    }
}
extension EventEntity {
    func ToDTO() -> EventDTO {
        return EventDTO(title: self.Title,
                        category: self.Category,
                        description: self.Description,
                        start_date: self.StartDate,
                        end_date: self.EndDate,
                        picture_url: self.Avatar,
                        event_owner: self.EventOwner,
                        location: self.Location)
    }
}
extension EventDetailEntity {
    func ToDTO() -> EventDetailDTO {
        return EventDetailDTO(
            id: self.Id
            title: self.Title,
            category: self.Category,
            description: self.Description,
            start_date: self.StartDate,
            end_date: self.EndDate,
            picture_url: self.Avatar,
            event_owner: self.EventOwner,
            location: self.Location)
    }
}
extension DetailEventResponseDTO {
    func ToEntity() -> EventEntity {
        return EventEntity(Title: self.title,
                           Category: self.category,
                           Description: self.description,
                           StartDate: self.start_date,
                           EndDate: self.end_date,
                           Avatar: self.picture_url,
                           EventOwner: self.event_owner,
                           Location: self.location)
    }
    
}

