//
//  RegisterViewController.swift
//  TuyaAppSDKSample-iOS-Swift
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

import UIKit
import TuyaSmartBaseKit
import AuthenticationServices
import Toaster

class RegisterViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func signUpWithApple(_ sender: Any) {
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
    
    @IBAction func signUpWithGoogle(_ sender: Any) {
        let countryCode = "01"
        TuyaSmartUser.sharedInstance().loginByAuth2(withType: "gg", countryCode: countryCode, accessToken: "396638861696-ssojp62m5tn6i2n9tq8fs28je48g6vtq.apps.googleusercontent.com", extraInfo: ["pubVersion": 1]) {
            [weak self] in
                guard let self = self else { return }
                let storyboard = UIStoryboard(name: "TuyaSmartMain", bundle: nil)
                let vc = storyboard.instantiateInitialViewController()
                self.window?.rootViewController = vc
        } failure: { error in
            print(error?.localizedDescription ?? "")
        }
    }
    
    
    @IBAction func signIn(_ sender: Any) {
        guard let vcs = navigationController?.viewControllers else {
            return
        }
        for vc in vcs {
            if vc is LoginTableViewController {
                navigationController?.popToViewController(vc, animated: true)
                return
            }
        }
        let sb = UIStoryboard(name: "Login", bundle: nil)
        let loginVC = sb.instantiateViewController(withIdentifier: "LoginTableViewController")
        navigationController?.pushViewController(loginVC, animated: true)
    }
}

extension CALayer {
    func setBorderColorFromUIColor(color: UIColor) {
        self.borderColor = color.cgColor
    }
}

extension RegisterViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
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
            let countryCode = "01"
            TuyaSmartUser.sharedInstance().loginByAuth2(withType: "ap", countryCode: countryCode, accessToken: String(data: identityToken, encoding: .utf8)!, extraInfo: ["userIdentifier": user, "email": email, "nickname": givenName, "snsNickname": givenName]) {
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





