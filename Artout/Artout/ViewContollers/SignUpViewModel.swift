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
    var firstNameText: BehaviorSubject<String>
    var lastNameText: BehaviorSubject<String>
    var phoneNumberText: BehaviorSubject<String>
    var passwordText: BehaviorSubject<String>
    var repeatPasswordText: BehaviorSubject<String>
    var registerStatus = PublishSubject<Bool>()
    var isLoading = PublishSubject<Bool>()
    
    var isSame: Observable<Bool>
    var isEmpty: Observable<Bool>
    
    var service = RegisterService()
    var disposeBag = DisposeBag()
    
    init() {
        firstNameText = BehaviorSubject<String>(value: "")
        lastNameText = BehaviorSubject<String>(value: "")
        phoneNumberText = BehaviorSubject<String>(value: "")
        passwordText = BehaviorSubject<String>(value: "")
        repeatPasswordText = BehaviorSubject<String>(value: "")
        
        self.isSame = Observable.combineLatest(passwordText.asObservable(),repeatPasswordText.asObservable()) { password, repeatPassword in
            !password.isEmpty && password == repeatPassword
        }
        
        self.isEmpty = Observable.combineLatest(firstNameText.asObservable(),lastNameText.asObservable(),phoneNumberText.asObservable()) { first,last,phone in
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
        
        try? service.Register(firstName: firstNameText.value(), lastName: lastNameText.value(), phoneNumber: phoneNumberText.value(), password: passwordText.value()).subscribe({ event in
            switch event{
            case .success:
                self.registerStatus.on(.next(true))
            case .error:
                self.registerStatus.on(.next(false))
            }
            }).disposed(by: disposeBag)
    }
}
