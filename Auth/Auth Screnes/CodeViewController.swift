//
//  CodeViewController.swift
//  Auth
//
//  Created by Karina Sarkisyan on 27.08.2020.
//  Copyright © 2020 Karina Sarkisyan. All rights reserved.
//

import UIKit
import  FirebaseAuth

class CodeViewController: UIViewController {

    var verificationID: String!
    
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var getNewCodeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupConfig()
    }
    
    private func setupConfig() {
        getNewCodeButton.alpha = 0.5
        getNewCodeButton.isEnabled = false
        
        codeTextField.delegate = self
        codeTextField.addTarget(self, action: #selector(codeChanged), for: .editingChanged)
    }

    @IBAction func getNewCodeButtonTapped(_ sender: UIButton) {
    }
    
    @objc private func codeChanged() {
        if let text = codeTextField.text {
            if text.count == 6 {
                codeEntered(code: text)
            }
        }
    }
    
    func codeEntered(code: String) {
        // имея код и верификатор пытаемся авторизоваться
        guard let code = codeTextField.text else { return }
        let credentional = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: code)
        
        Auth.auth().signIn(with: credentional) { (_, error) in
            // если нет ошибки, то авторизуемся
            if error != nil {
                let alertController = UIAlertController(title: error?.localizedDescription, message: nil, preferredStyle: .alert)
                let cancel = UIAlertAction(title: "Отмена", style: .cancel)
                alertController.addAction(cancel)
                self.present(alertController, animated: true)
            } else {
                // если зареган то
                // showHomeViewController()
                // если нет то
                // showCheckInViewController()
                self.showHomeViewController()
            }
        }
        // если зареган то
//        showHomeViewController()
        // если нет то
//        showCheckInViewController()
        
        }

    private func showHomeViewController() {
        let storyboard = UIStoryboard(name: "Auth", bundle: nil)
        let dvc = storyboard.instantiateViewController(identifier: "HomeViewController") as! HomeViewController
        self.present(dvc, animated: true)
    }

    private func showCheckInViewController() {
        let storyboard = UIStoryboard(name: "Auth", bundle: nil)
        let dvc = storyboard.instantiateViewController(identifier: "CheckInViewController") as! CheckInViewController
        self.present(dvc, animated: true)
    }
}

extension CodeViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        return (text.count + (string.count - range.length)) <= 6
    }
}
