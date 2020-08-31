//
//  AuthViewController.swift
//  Auth
//
//  Created by Karina Sarkisyan on 26.08.2020.
//  Copyright © 2020 Karina Sarkisyan. All rights reserved.
//

import UIKit
import FirebaseAuth
import FlagPhoneNumber

class AuthViewController: UIViewController {
    
    var phoneNumber: String?
    
    var listController: FPNCountryListViewController!

    @IBOutlet weak var phoneNumberTextField: FPNTextField!
    
    @IBOutlet weak var continueButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupConfig()
    }
    
    // изначальные настройки
    private func setupConfig() {
        continueButton.alpha = 0.5
        continueButton.isEnabled = false
        
        phoneNumberTextField.displayMode = .list
        phoneNumberTextField.delegate = self
        
        listController = FPNCountryListViewController(style: .grouped)
        listController.setup(repository: phoneNumberTextField.countryRepository)
        listController.didSelect = { country in
            self.phoneNumberTextField.setFlag(countryCode: country.code)
        }
    }
    
    @IBAction func closeSegue(_ sender: UIStoryboardSegue) {
        phoneNumberTextField.text = ""
    }
    
    // получаем код
    @IBAction func continueButtonTapped(_ sender: UIButton) {
        guard phoneNumber != nil else { return }
        
        // передаем номер телефона и получаем верификатор verificationID
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber!, uiDelegate: nil) { (verificationID, error) in
            if error != nil {
                print(error?.localizedDescription ?? "error")
            } else {
                guard verificationID != nil else { return }
                
                // передаем на след втю контроллер верификатор
                self.showCodeViewController(verificationID: verificationID!)
            }
        }
        
        
    }
    
    private func showCodeViewController(verificationID: String) {
        let storyboard = UIStoryboard(name: "Auth", bundle: nil)
        let dvc = storyboard.instantiateViewController(identifier: "CodeViewController") as! CodeViewController
        dvc.verificationID = verificationID
        self.present(dvc, animated: true, completion: nil)
    }

}

extension AuthViewController: FPNTextFieldDelegate {
    
    // что будет происходить после нажатия на страну
    func fpnDidSelectCountry(name: String, dialCode: String, code: String) {
    }
    
    // делаем кнопку активной / не активной. Срабатывает каждый раз, когда мы меняем значение в поле текст филд
    func fpnDidValidatePhoneNumber(textField: FPNTextField, isValid: Bool) {
        if isValid {
            continueButton.alpha = 1
            continueButton.isEnabled = true
            
            phoneNumber = phoneNumberTextField.getFormattedPhoneNumber(format: FPNFormat.International)
        } else {
            continueButton.alpha = 0.5
            continueButton.isEnabled = false
        }
    }
    
    // для отображения лист контроллера
    func fpnDisplayCountryList() {
        let navigationController = UINavigationController(rootViewController: listController)
        listController.title = "Страны"
        phoneNumberTextField.text = ""
        self.present(navigationController, animated: true)
    }
    
    

}
