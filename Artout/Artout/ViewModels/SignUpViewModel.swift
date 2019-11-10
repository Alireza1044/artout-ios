//
//  SignUpViewModel.swift
//  Artout
//
//  Created by Alireza Moradi on 11/3/19.
//  Copyright © 2019 Pooya Kabiri. All rights reserved.
//

import Foundation
import RxSwift

class SignUpViewModel{
    var usernameText: BehaviorSubject<String>
    var firstNameText: BehaviorSubject<String>
    var lastNameText: BehaviorSubject<String>
    var emailText: BehaviorSubject<String>
    var passwordText: BehaviorSubject<String>
    var repeatPasswordText: BehaviorSubject<String>
    var registerStatus: PublishSubject<Bool>
    var isLoading: PublishSubject<Bool>
    var error: PublishSubject<String>
    
    var isSame: Observable<Bool>
    var isEmpty: Observable<Bool>
    
    var service = RegisterService()
    var disposeBag = DisposeBag()
    
    init() {
        usernameText = BehaviorSubject<String>(value: "")
        firstNameText = BehaviorSubject<String>(value: "")
        lastNameText = BehaviorSubject<String>(value: "")
        emailText = BehaviorSubject<String>(value: "")
        passwordText = BehaviorSubject<String>(value: "")
        repeatPasswordText = BehaviorSubject<String>(value: "")
        
        registerStatus = PublishSubject<Bool>()
        isLoading = PublishSubject<Bool>()
        error = PublishSubject<String>()
        
        self.isSame = Observable.combineLatest(passwordText.asObservable(),repeatPasswordText.asObservable()) { password, repeatPassword in
            password.count >= 8 && password == repeatPassword
        }
        
        self.isEmpty = Observable.combineLatest(firstNameText.asObservable(),lastNameText.asObservable(),emailText.asObservable()) { first,last,phone in
            first.isEmpty &&
                last.isEmpty &&
                phone.isEmpty
        }
    }
    
    func Register() {
        
        service.isLoading.subscribe({
            switch $0{
            case .next(true):
                self.isLoading.on(.next(true))
            case .next(false):
                self.isLoading.on(.next(false))
            default:
                self.isLoading.on(.next(false))
            }
        }).disposed(by: disposeBag)
        
        service.error.subscribe({
            self.error.on(.next($0.element!))
            }).disposed(by: disposeBag)
        
        try? service.Register(username: usernameText.value(),firstName: firstNameText.value(), lastName: lastNameText.value(), email: emailText.value(), password: passwordText.value()).subscribe({ event in
            switch event{
            case .success:
                self.registerStatus.on(.next(true))
            case .error:
                self.registerStatus.on(.next(false))
            }
        }).disposed(by: disposeBag)
    }
}
