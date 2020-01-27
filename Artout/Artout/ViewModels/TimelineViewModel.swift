//
//  TimelineViewModel.swift
//  Artout
//
//  Created by Alireza Moradi on 1/10/20.
//  Copyright © 2020 Pooya Kabiri. All rights reserved.
//

import Foundation
import RxSwift

class TimelineViewModel{
    var service = TimelineService()
    var disposeBag = DisposeBag()
    let refresh: PublishSubject<Bool>
    var events: [EventDetailEntity]
    
    init(){
        self.refresh = PublishSubject<Bool>()
        events = []
    }
    
    func FetchEvents(pageNo: Int, pageSize: Int) {
        let url = URL(string: Endpoint.GCPServer.rawValue + APIPaths.AddEvent.rawValue + APIPaths.Timeline.rawValue + "?page=\(pageNo)&page_size=\(pageSize)")!
        service.RequestTimeline(url: url)
            .subscribe(onSuccess: { data in
                self.events.append(contentsOf: data.reversed())
                self.refresh.onNext(true)
            }).disposed(by: disposeBag)
    }
}
