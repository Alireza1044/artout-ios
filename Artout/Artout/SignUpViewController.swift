//
//  SignUpViewController.swift
//  
//
//  Created by Alireza Moradi on 11/3/19.
//

import RxSwift
import RxCocoa
import UIKit

class SignUpViewController: UIViewController{
    
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    var signupViewModel = SignUpViewModel()
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _ = firstNameTextField.rx.text.map {$0 ?? ""}.bind(to: signupViewModel.firstNameText)
        _ = lastNameTextField.rx.text.map {$0 ?? ""}.bind(to: signupViewModel.lastNameText)
        _ = phoneNumberTextField.rx.text.map {$0 ?? ""}.bind(to: signupViewModel.phoneNumberText)
        _ = passwordTextField.rx.text.map {$0 ?? ""}.bind(to: signupViewModel.passwordText)
        _ = repeatPasswordTextField.rx.text.map {$0 ?? ""}.bind(to: signupViewModel.repeatPasswordText)
        
        Observable.combineLatest(signupViewModel.isEmpty,signupViewModel.isSame).map{ !$0 && $1}.subscribe{
            self.registerButton.isEnabled = $0.element!
            print("register: \(self.registerButton.isEnabled)")
        }.disposed(by: disposeBag)
    }
}
