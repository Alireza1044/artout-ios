//
//  HttpUtility.swift
//  Artout
//
//  Created by Pooya Kabiri on 11/7/19.
//  Copyright © 2019 Pooya Kabiri. All rights reserved.
//

import Foundation
import RxSwift

protocol HTTPNetworking {
    func request(from: Endpoint, With data: Data) -> Single<String>
}
protocol EndPointType {
    var baseURL: URL {get}
    var path: String {get}
    var httpMethod: HTTPMethod {get}
}
public enum Endpoint : String {
    case GCPServer = "http://35.202.66.168:8000/api/"
}
public enum HTTPMethod: String {
    case GET, POST, PUT, PATCH, DELETE
}
public enum APIPaths: String {
    case Login = "login/"
    case Register = "register/"
    case AddEvent = "event/events/"
    case FetchEvents = "event/eventsd/"
    case EventDetail = "event/eventdetail/"
}
public enum ContentType: String {
    case JSON = "application/json"
}
public enum HTTPStatusCodes: Int, Error {
    case Okay = 200
    case Created = 201
    case Accepted = 202
    
    case Unauthorized = 401
    case NotFound = 404
    case BadRequest = 400
    case Forbidden = 403
    
    case InternalServerError = 500
    case BadGateway = 502
    
}
