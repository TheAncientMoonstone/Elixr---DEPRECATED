//
//  SignInViewControllerExtensions.swift
//  Elixr
//
//  Created by Timothy Richardson on 29/11/16.
//  Copyright © 2016 Timothy Richardson. All rights reserved.
//

import Foundation
import AWSCognitoIdentityProvider
import AWSMobileHubHelper

extension SignInViewController {
    
    func handleCustomSignIn() {
        AWSCognitoUserPoolsSignInProvider.sharedInstance().setInteractiveAuthDelegate(self)
        self.handleLoginWithSignInProvider(signInProvider: AWSCognitoUserPoolsSignInProvider.sharedInstance())
    }
    
    func handleUserPoolSignUp() {
        let storyboard = UIStoryboard(name: "UserPools", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "SignUp")
            self.present(viewController, animated: true, completion: nil);
    }
    
    func handleUserPoolForgotPassword() {
        let storyboard = UIStoryboard(name: "UserPools", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ForgotPassword")
            self.present(viewController, animated: true, completion: nil);
    }
}

extension SignInViewController: AWSCognitoIdentityInteractiveAuthenticationDelegate {
    
    private func startPasswordAuthentication() -> SignInViewController {
        return self 
    }
    
    
    func didCompletePasswordAuthenticationSetepWithError(error: NSError?) {
        if let error = error {
            DispatchQueue.main.async(execute: {
                
                UIAlertView(title: error.userInfo["__type"] as! String?,
                                 message: error.userInfo["message"] as? String,
                                 delegate: nil,
                                 cancelButtonTitle: "Ok").show()
                
            })
        }
    }
 
}

extension SignInViewController: AWSCognitoIdentityPasswordAuthentication {

    /*
    func getDetails(_ authenticationInput: AWSCognitoIdentityPasswordAuthenticationInput, passwordAuthenticationCompletionSource: AWSTaskCompletionSource<AnyObject>) {
        self.passwordAuthenticationCompletion = passwordAuthenticationCompletionSource
    }
    */
    
    func getPasswordAuthenticationDetails(authenticationInput: AWSCognitoIdentityPasswordAuthenticationInput,
                                          passwordAuthenticationCompletionSource: AWSTaskCompletionSource<AnyObject>) {
        self.passwordAuthenticationCompletion = passwordAuthenticationCompletionSource
    }
    
    /*
    func didCompleteStepWithError(_ error: NSError?) {
        if let error = error {
            DispatchQueue.main.async(execute: {
                
                UIAlertView(title: error.userInfo["__type"] as? String,
                            message: error.userInfo["message"] as? String,
                            delegate: nil,
                            cancelButtonTitle: "Ok").show()
            })
        }
    }
    */
    
    func didCompletePasswordAuthenticationStepWithError(error: NSError?) {
        if let error = error {
            DispatchQueue.main.async(execute: {
                
                UIAlertView(title: error.userInfo["__type"] as? String, message: error.userInfo["message"] as! String?, delegate: nil, cancelButtonTitle: "Ok").show()
            })
        }
    }

}

extension SignInViewController: AWSCognitoUserPoolsSignInHandler {
    
    func handleUserPoolSignInFlowStart() {
        guard let username = self.customUserIdField.text, !username.isEmpty,
            let password = self.customPasswordField.text, !password.isEmpty else {
                DispatchQueue.main.async(execute: {
                    UIAlertView(title: "Missing username / password", message: "Please enter a valid username / or password", delegate: nil, cancelButtonTitle: "Ok").show()
                })
                return
        }
        
        self.passwordAuthenticationCompletion?.setResult(AWSCognitoIdentityPasswordAuthenticationDetails.self)
    }
}
