//
//  MainViewController.swift
//  Elixr
//
//  Created by Timothy Richardson on 28/11/16.
//  Copyright © 2016 Timothy Richardson. All rights reserved.
//

import UIKit
import AWSMobileHubHelper
import FBSDKCoreKit
import FBSDKLoginKit

class MainViewController: UIViewController {
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Present the Sign In View Controller.
        presentSignInViewController()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    // MARK:- Sign In View Controller.
    // Present the Sign In View Controller.
    func presentSignInViewController() {
        if !AWSIdentityManager.default().isLoggedIn {
            let storyboard = UIStoryboard(name: "SignIn", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "Sign In")
            self.present(viewController, animated: true, completion: nil)
        }
    }
    
}
