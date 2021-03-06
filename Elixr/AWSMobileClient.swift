//
//  AWSMobileClient.swift
//  Elixr
//
//  Created by Timothy Richardson on 4/12/16.
//  Copyright © 2016 Timothy Richardson. All rights reserved.
//

import Foundation
import UIKit
import AWSCore
import AWSCognitoIdentityProvider
import AWSMobileHubHelper

class AWSMobileClient: NSObject {
    
    static let sharedInstance = AWSMobileClient()
    private var isInitialized = Bool()
    
    private override init() {
        isInitialized = false
        super.init()
    }
    
    deinit {
        print("Mobile Client is deinitialized. This should not happen.")
    }
    
    func withApplication(application: UIApplication, withURL url: NSURL, withSourceApplication sourceApplication: String?, withAnnotation annotation: AnyObject) -> Bool {
        print("withApplication:withURL")
        AWSIdentityManager.default().interceptApplication(application, open: url as URL, sourceApplication: sourceApplication, annotation: annotation)
        
        if (!isInitialized) {
            isInitialized = true
        }
        
        return false;
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        print("applicationDidBecomeActive:")
    }
    
    func didFinishLaunching(application: UIApplication, withOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        print("didFinishLaunching:")
        
        setupUserPool()
        
        let didFinishLaunching = AWSIdentityManager.default().interceptApplication(application, didFinishLaunchingWithOptions: launchOptions)
        if (!isInitialized) {
        AWSIdentityManager.default().resumeSession (completionHandler: { (result, error) in
            print("result = \(String(describing: result)), error = \(String(describing: error))")
            })
            self.isInitialized = true
        }
        
        return didFinishLaunching
    }
    
    func setupUserPool() {
        // Register your user pool configuration
        AWSCognitoUserPoolsSignInProvider.setupUserPool(withId: AWSCognitoUserPoolId, cognitoIdentityUserPoolAppClientId: AWSCognitoUserPoolAppClientId, cognitoIdentityUserPoolAppClientSecret: AWSCognitoUserPoolClientSecret, region: AWSCognitoUserPoolRegion)
        
        AWSSignInProviderFactory.sharedInstance().register(signInProvider: AWSCognitoUserPoolsSignInProvider.sharedInstance(), forKey: AWSCognitoUserPoolsSignInProviderKey)
    }
}
