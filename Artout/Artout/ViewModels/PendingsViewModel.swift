//
//  PendingsViewModel.swift
//  Artout
//
//  Created by Pooya Kabiri on 12/16/19.
//  Copyright © 2019 Pooya Kabiri. All rights reserved.
//

import Foundation
import RxSwift
class PendingsViewModel {
    var Pendings: [UserEntity]
    let service = FriendService()
    let refresh: PublishSubject<Bool>
    
    init() {
        self.Pendings = []
        refresh = PublishSubject<Bool>()
    }
    
    func FetchPendings() {
        _ = service.FetchPendings().subscribe(onSuccess: { (data) in
            self.Pendings = data
            self.refresh.onNext(true)
        })
    }
    
    func AcceptWithID(Id: String) {
        _ = service.Accept(with: Id).subscribe(onSuccess: { (bool) in
            print(bool)
        })
    }
    func RejectWithID(Id: String) {
        _ = service.Reject(with: Id).subscribe(onSuccess: { (bool) in
            print(bool)
        })
    }
}
