//
//  LoginViewModel.swift
//  Artout
//
//  Created by Pooya Kabiri on 10/31/19.
//  Copyright © 2019 Pooya Kabiri. All rights reserved.
//

import Foundation
import RxSwift

class LoginViewModel {
    var usernameText: BehaviorSubject<String>
    var passwordText: BehaviorSubject<String>
    var isValid: Observable<Bool>
    var loginStatus: PublishSubject<Bool>
    var loginMessage: PublishSubject<String>
    
    var disposeBag = DisposeBag()
    var service = LoginService()
    
    init() {
        usernameText = BehaviorSubject<String>(value: "")
        passwordText = BehaviorSubject<String>(value: "")
        loginStatus = PublishSubject<Bool>()
        loginMessage = PublishSubject<String>()
        self.isValid = Observable.combineLatest(usernameText.asObservable(),passwordText.asObservable()) { email, password in
            password.count >= 8
        }
    }
    
    func Login() {
        let entity = try? LoginEntity(Username: usernameText.value(), Password: passwordText.value())
        service.Login(With: entity!)
        .subscribe({ event in
            switch event{
                case .success:
                    self.loginStatus.on(.next(true))
                case .error:
                    self.loginStatus.on(.next(false))
                    self.loginMessage.on(.next("Username or Password is not correct"))
            }
            }).disposed(by: disposeBag)
            

    }
    
}
