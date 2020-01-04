//
//  AddFriendViewModel.swift
//  Artout
//
//  Created by Pooya Kabiri on 12/7/19.
//  Copyright © 2019 Pooya Kabiri. All rights reserved.
//

import Foundation
import RxSwift

class AddFriendViewModel {
    var disposeBag = DisposeBag()
    var searchText = BehaviorSubject<String>(value: "")
    var addedSuccessfully: PublishSubject<Bool>
    let service = FriendService()
    
    init() {
        addedSuccessfully = PublishSubject<Bool>()
    }
    
    func AddFriend() {
        _ = try? service.GetUserbyUsername(username: searchText.value()).subscribe(onSuccess: { (id) in
            _ = self.service.AddFriend(with: id).subscribe(onSuccess: { (bool) in
                self.addedSuccessfully.onNext(true)
            }, onError: { (Error) in
                self.addedSuccessfully.onNext(false)
            })
        })
        
        
    }
    
    
    
}
