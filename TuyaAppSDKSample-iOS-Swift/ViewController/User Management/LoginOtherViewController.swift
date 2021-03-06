//
//  LoginOtherViewController.swift
//  TuyaAppSDKSample-iOS-Swift
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

import UIKit
import TuyaSmartBaseKit
import AuthenticationServices
import Toaster

class LoginOtherViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signInWithApple(_ sender: Any) {
        if #available(iOS 13.0, *)  {
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let appleIDRequest = appleIDProvider.createRequest()
            appleIDRequest.requestedScopes = [ASAuthorization.Scope.fullName, ASAuthorization.Scope.email];
            let authorizationController = ASAuthorizationController(authorizationRequests: [appleIDRequest])
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self
            authorizationController.performRequests()
        } else {
            Toast(text: "This function needs to be used on ios13 and above").show()
        }
    }
    
    @IBAction func signInWithGoogle(_ sender: Any) {
        TuyaSmartUser.sharedInstance().loginByAuth2(withType: "gg", countryCode: "01", accessToken: "396638861696-ssojp62m5tn6i2n9tq8fs28je48g6vtq.apps.googleusercontent.com", extraInfo: ["pubVersion": 1]) {
            [weak self] in
                guard let self = self else { return }
                let storyboard = UIStoryboard(name: "TuyaSmartMain", bundle: nil)
                let vc = storyboard.instantiateInitialViewController()
                self.window?.rootViewController = vc
        } failure: { error in
            print(error?.localizedDescription ?? "")
        }

    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension LoginOtherViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    @available(iOS 13.0, *)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let cred = authorization.credential as? ASAuthorizationAppleIDCredential {
            let user = cred.user
            //let familyName = cred.fullName?.familyName ?? ""
            let givenName = cred.fullName?.nickname ?? ""
            let email = cred.email ?? ""
            let identityToken = cred.identityToken!
            
            TuyaSmartUser.sharedInstance().loginByAuth2(withType: "ap", countryCode: "01", accessToken: String(data: identityToken, encoding: .utf8)!, extraInfo: ["userIdentifier": user, "email": email, "nickname": givenName, "snsNickname": givenName]) {
                [weak self] in
                    guard let self = self else { return }
                    let storyboard = UIStoryboard(name: "TuyaSmartMain", bundle: nil)
                    let vc = storyboard.instantiateInitialViewController()
                    self.window?.rootViewController = vc
            } failure: { error in
                
            }

            
        }else if let _ =  authorization.credential as? ASPasswordCredential {
            //let user = cred.user
            //let password = cred.password
        }else{
            print("Authorization information is inconsistent")
            
        }
    }
    
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("error: \(error.localizedDescription ?? "")")
    }
}




