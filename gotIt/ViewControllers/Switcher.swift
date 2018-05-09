//
//  Switcher.swift
//  gotIt
//
//  Created by Sergio Hernandez Jr on 09/05/18.
//  Copyright © 2018 Sergio Hernandez. All rights reserved.
//

import Foundation
import FBSDKLoginKit
import GoogleSignIn
import FirebaseFacebookAuthUI

class Switcher {
	
	static func updateRootVC(){
		var rootVC : UIViewController?
		print("Switcher update")
		if Auth.auth().currentUser != nil{
			rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RootTBC") as! UITabBarController
			print("MenuView \(Auth.auth().currentUser?.uid)")
		} else {
			rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginView") as! LoginVC
			FBSDKAccessToken.setCurrent(nil)
			GIDSignIn.sharedInstance().disconnect()
			print("LoginView")
		}
		
		
		
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		appDelegate.window?.rootViewController = rootVC
		
	}
}
