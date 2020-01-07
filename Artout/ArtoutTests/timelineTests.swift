//
//  timelineTests.swift
//  ArtoutTests
//
//  Created by Alireza Moradi on 1/6/20.
//  Copyright © 2020 Pooya Kabiri. All rights reserved.
//

import XCTest
import RxSwift

@testable import Artout

class timelineTests: XCTestCase {
    
    var disposeBag = DisposeBag()
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let service = EventsService()
        let url = URL(string: "http://localhost:8080/api/v1.0/events/")!
        let sd = expectation(description: "Network service was successful")
        service.RequestEvents(url: url).subscribe(onSuccess: { (events) in
            var isSuccess = false
            let mockEvent = EventDetailEntity.createMockEvents()
            for i in 0...events.count - 1 {
                if(events[i].Avatar == mockEvent[i].Avatar &&
                    events[i].Category == mockEvent[i].Category &&
                    events[i].Description == mockEvent[i].Description &&
                    events[i].EndDate == mockEvent[i].EndDate &&
                    events[i].Id == mockEvent[i].Id &&
                    events[i].Location.latitude == mockEvent[i].Location.latitude &&
                    events[i].Owner == mockEvent[i].Owner &&
                    events[i].StartDate == mockEvent[i].StartDate &&
                    events[i].Title == mockEvent[i].Title){
                    isSuccess = true
                }
                else {
                    isSuccess = false
                    break
                }
            }
            XCTAssertTrue(isSuccess)
            sd.fulfill()
        },onError: { _ in
            sd.fulfill()}).disposed(by: disposeBag)
        wait(for: [sd], timeout: 1)
    }
}

extension EventDetailEntity{
    static func createMockEvents() -> [EventDetailEntity]{
        return [EventDetailEntity(Id: 1, Title: "first event", Category: "funny category", Description: "This is the first event description from the test server", StartDate: "2019-12-17 19:45", EndDate: "2019-12-19 20:45", Avatar: "", EndTime: "", StartTime: "", Location: LocationEntity(latitude: 1.0, longitude: 1.0,id: 16)),EventDetailEntity(Id: 2, Title: "second event", Category: "test category", Description: "This is the first event description from the test server i hope it works", StartDate: "2018-10-17 19:45", EndDate: "2020-12-13 20:45", Avatar: "", EndTime: "", StartTime: "", Location: LocationEntity(latitude: 1.0, longitude: 1.0, id: 17))]
    }
}
