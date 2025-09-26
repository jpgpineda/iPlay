//
//  SignUpViewController.swift
//  iPLay
//
//  Created by javier pineda on 09/09/25.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var emailTextField: FloatingLabeledTextField!
    @IBOutlet weak var signUpButton: IPlayButton!
    @IBOutlet weak var passwordTextField: FloatingLabeledTextField!
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
        emailTextField.isValid = viewModel.validateFields(type: .email)
        passwordTextField.isValid = viewModel.validateFields(type: .password)
        signUpButton.isActive = viewModel.validateFields(type: .button)
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
        view.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            guard let text = emailTextField.text,
                  !text.isEmpty else {
                viewModel.email = ""
                return false
            }
            viewModel.email = text
        } else {
            guard let text = passwordTextField.text,
                  !text.isEmpty else {
                viewModel.password = ""
                return false
            }
            viewModel.password = text
        }
        
        validateFields()
        return true
    }
}
