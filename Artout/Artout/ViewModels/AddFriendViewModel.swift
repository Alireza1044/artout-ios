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
    
    
    var k: String = ""
    init() {
        addedSuccessfully = PublishSubject<Bool>()
    }
    
    func AddFriend() {
        _ = try? service.AddFriend(with: searchText.value()).subscribe(onSuccess: { (data) in
            self.k = data
        })
        
    }
    
    
    
}
