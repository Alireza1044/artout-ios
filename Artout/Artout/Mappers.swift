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
        
        let startDateTime = convertDateToDTO(date: self.StartDate, time: self.StartTime)
        let endDateTime = convertDateToDTO(date: self.EndDate, time: self.EndTime)
        return EventDTO(title: self.Title,
                        category: self.Category,
                        description: self.Description,
                        start_date: startDateTime,
                        end_date: endDateTime,
                        picture_url: self.Avatar,
                        event_owner: self.Owner,
                        location: self.Location)
    }
}

extension UserEntity {
    func ToDTO() -> UserDTO {
        return UserDTO(FirstName: self.FirstName,
                       LastName: self.LastName,
                       UserName: self.UserName,
                       Avatar: self.Avatar,
                       Id: self.Id)
    }
}

extension FriendEntity {
    func ToDTO() -> FriendDTO {
        return FriendDTO(User: self.User.ToDTO(),
                         State: self.State)
    }
}

extension FriendDTO {
    func ToEntity() -> FriendEntity {
        return FriendEntity(User: self.User.ToEntity(),
                            State: self.State)
    }
}

extension UserDTO {
    func ToEntity() -> UserEntity {
        return UserEntity(FirstName: self.first_name,
                          LastName: self.last_name,
                          UserName: self.username,
                          Avatar: self.avatar,
                          Id: self.id,
                          DateJoined: self.date_joined,
                          IsPrivate: self.is_private,
                          Email: self.email)
    }
}

extension EventDetailEntity {
    func ToDTO() -> EventDetailDTO {
        let startDateTime = convertDateToDTO(date: self.StartDate, time: self.StartTime)
        let endDateTime = convertDateToDTO(date: self.EndDate, time: self.EndTime)
        return EventDetailDTO(
            title: self.Title,
            category: self.Category,
            description: self.Description,
            start_date: startDateTime,
            end_date: endDateTime,
            picture_url: self.Avatar,
            owner: self.Owner,
            location: self.Location)
    }
}
extension EventDetailResponseDTO {
    func ToEntity() -> EventDetailEntity {
        let startDate = convertDateToEntity(date: self.start_date)
        let endDate = convertDateToEntity(date: self.end_date)
        let startTime =  convertTimeToEntity(date: self.start_date)
        let endTime =  convertTimeToEntity(date: self.end_date)
        return EventDetailEntity(
            Id: self.id,
                            Title: self.title,
                           Category: self.category,
                           Description: self.description,
                           StartDate: startDate,
                           EndDate: endDate,
                           Avatar: self.picture_url ?? "",
                           EndTime: endTime,
                           StartTime: startTime,
                           Location: self.location)
    }
}

extension FriendProfileDTO {
    func ToEntity() -> FriendProfileEntity {
        return FriendProfileEntity(FirstName: self.first_name,
                                   LastName: self.last_name,
                                   UserName: self.username,
                                   Avatar: self.avatar,
                                   FollowerCount: self.followers,
                                   FollowingCount: self.followings,
                                   Id: self.id)
    }
}

func convertDateToDTO(date: String, time: String) -> String{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
    if let newDate = dateFormatter.date(from: date){
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.string(from: newDate)
        return date + " " + time
    }
    return ""
}

func convertDateToEntity(date: String) -> String{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    if let newDate = dateFormatter.date(from: date) {
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let date = dateFormatter.string(from: newDate)
        return date
    }
    return ""
}

func convertTimeToEntity(date: String) -> String{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    if let newDate = dateFormatter.date(from: date) {
        dateFormatter.dateFormat = "HH:mm"
        let date = dateFormatter.string(from: newDate)
        return date
    }
    return ""
}
