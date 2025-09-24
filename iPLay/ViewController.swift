//
//  ViewController.swift
//  iPLay
//
//  Created by javier pineda on 21/08/25.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        signUpButton.layer.cornerRadius = 16
        signInButton.layer.cornerRadius = 16
        signInButton.layer.borderWidth = 1
        signInButton.layer.borderColor = UIColor.white.cgColor
    }

    @IBAction func showSignUp(_ sender: UIButton) {
        let viewController = SignUpViewController(viewModel: SignUpViewModelImplementation())
        present(viewController, animated: true, completion: nil)
    }
    
}

