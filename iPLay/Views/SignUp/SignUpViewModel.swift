//
//  SignUpViewModel.swift
//  iPLay
//
//  Created by javier pineda on 18/09/25.
//

import Foundation

protocol SignUpView: AnyObject {
    func showFAilureMessage()
    func showLoader()
}

protocol SignUpViewModel {
    var email: String { get set }
    var password: String { get set }
    func attachView(_ view: SignUpView)
    func requestLogin()
    func validateFields() -> Bool
}

class SignUpViewModelImplementation: SignUpViewModel {
    private weak var view: SignUpView?
    var email: String = ""
    var password: String = ""
    
    func attachView(_ view: SignUpView) {
        self.view = view
    }
    
    func requestLogin() {
        view?.showLoader()
    }
    
    func validateFields() -> Bool {
        return !email.isEmpty && !password.isEmpty
    }
}
