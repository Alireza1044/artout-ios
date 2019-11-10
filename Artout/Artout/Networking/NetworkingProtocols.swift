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
}
public enum ContentType: String {
    case JSON = "application/json"
}
public enum NetworkingError: Int, Error {
    case InternalServerError = 500
    case CredenttialsNotValid = 401
//    case InternalServerError = 500
//    case InternalServerError = 500
//    case InternalServerError = 500
    
}
