//
//  LoginVC.swift
//  gotIt
//
//  Created by Sergio Hernandez Jr on 09/05/18.
//  Copyright © 2018 Sergio Hernandez. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FirebaseFacebookAuthUI
import GoogleSignIn

class LoginVC: UIViewController, FBSDKLoginButtonDelegate, GIDSignInUIDelegate{
	
	@IBOutlet weak var googleLoginBtn: GIDSignInButton!
	@IBOutlet weak var fbLoginBtn: FBSDKLoginButton!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		fbLoginBtn.delegate = self
		GIDSignIn.sharedInstance().uiDelegate = self
		
		
		print("Hola LoginVC")
	}
	
	func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
		print ("user goodbye")
		
		do {
			try Auth.auth().signOut()
		} catch {
			print("error")
		}
	}
	
	func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error?) {
		if let error = error {
			print(error.localizedDescription)
			return
		}
		
		guard FBSDKAccessToken.current() != nil  else{
			print("quit")
			return
		}
		
		let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
		
		Auth.auth().signIn(with: credential) { (user, error) in
			if error != nil {
				// ...
				return
			}
			print("ok")
			// User is signed in
			print("\(user)")
			Switcher.updateRootVC()
			//            self.present(menuTVC, animated: true, completion: nil)
		}
		
	}
	
	
}


