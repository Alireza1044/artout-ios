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
    
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    var signupViewModel = SignUpViewModel()
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _ = usernameTextField.rx.text.map({ $0 ?? ""}).bind(to: signupViewModel.usernameText)
        _ = firstNameTextField.rx.text.map {$0 ?? ""}.bind(to: signupViewModel.firstNameText)
        _ = lastNameTextField.rx.text.map {$0 ?? ""}.bind(to: signupViewModel.lastNameText)
        _ = emailTextField.rx.text.map {$0 ?? ""}.bind(to: signupViewModel.emailText)
        _ = passwordTextField.rx.text.map {$0 ?? ""}.bind(to: signupViewModel.passwordText)
        _ = repeatPasswordTextField.rx.text.map {$0 ?? ""}.bind(to: signupViewModel.repeatPasswordText)
        activityIndicatorView.isHidden = true
        
        signupViewModel.isLoading.subscribe({ loading in
            switch (loading){
            case .next(true):
                self.activityIndicatorView.startAnimating()
                self.activityIndicatorView.isHidden = false
            case .next(false):
                self.activityIndicatorView.stopAnimating()
                self.activityIndicatorView.isHidden = true
            case .error(_):
                self.activityIndicatorView.stopAnimating()
                self.activityIndicatorView.isHidden = true
            case .completed:
                self.activityIndicatorView.stopAnimating()
                self.activityIndicatorView.isHidden = true
            }
        }).disposed(by: disposeBag)
        
        self.signupViewModel.registerStatus.subscribe { (status) in
            switch(status){
            case .next(true):
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "RegisterSuccessful", sender: self)
                }
            default: break
            }
        }.disposed(by: disposeBag)
        
        Observable.combineLatest(signupViewModel.isEmpty,signupViewModel.isSame).map{ !$0 && $1}.subscribe{
            self.registerButton.isEnabled = $0.element!
            print("register: \(self.registerButton.isEnabled)")
        }.disposed(by: disposeBag)
        
        _ = signupViewModel.error.subscribe(onNext: { status in
                let alertController = UIAlertController(title: "Register Failed", message:
                    status.description, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
                self.present(alertController, animated: true, completion: nil)
            }
        )
    }
    
    
    @IBAction func registerButtonPressed(_ sender: Any) {
        signupViewModel.Register()
    }
}
