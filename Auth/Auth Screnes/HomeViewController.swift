//
//  HomeViewController.swift
//  Auth
//
//  Created by Karina Sarkisyan on 27.08.2020.
//  Copyright © 2020 Karina Sarkisyan. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func logOutButton(_ sender: Any) {
        performSegue(withIdentifier: "closeSegue", sender: self)
    }
    


}
