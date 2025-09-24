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
    let viewModel: SignUpViewModel
    
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
        viewModel.requestLogin()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func requestSignUp(_ sender: UIButton) {
        if viewModel.validateFields() {
            print("Hacer Login")
        } else {
            print("Hubo un error")
        }
    }
}

extension SignUpViewController: SignUpView {
    func showFAilureMessage() {
        
    }
    
    func showLoader() {
        
    }
}
