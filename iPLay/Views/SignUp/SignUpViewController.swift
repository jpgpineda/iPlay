//
//  SignUpViewController.swift
//  iPLay
//
//  Created by javier pineda on 09/09/25.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    var viewModel: SignUpViewModel
    
    init(viewModel: SignUpViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.attachView(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Init with coder has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func requestSignUp(_ sender: UIButton) {
        print("Hacer login")
        viewModel.requestLogin()
    }
    
    func validateFields() {
        signUpButton.isEnabled = viewModel.validateFields()
    }
}

extension SignUpViewController: SignUpView {
    func showFAilureMessage() {
        
    }
    func showLoader() {
        
    }
}

extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            guard let text = emailTextField.text else {
                return false
            }
            viewModel.email = text
        } else {
            guard let text = passwordTextField.text else {
                return false
            }
            viewModel.password = text
        }
        
        validateFields()
        return true
    }
}
