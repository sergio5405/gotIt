//
//  AppDelegate.swift
//  gotIt
//
//  Created by Sergio Hernandez Jr on 01/04/18.
//  Copyright © 2018 Sergio Hernandez. All rights reserved.
//

import UIKit
import Firebase
import GoogleMaps
import GoogleSignIn
import FBSDKLoginKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
	
	func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
		print("sign in google")
		if error != nil { return }
		if user == nil { return }
		guard let authentication = user.authentication else { return }
		
		let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
		Auth.auth().signIn(with: credential) { (user, error) in
			if error != nil {
				return
			}
			Switcher.updateRootVC()
		}
	}
	
	func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
		if error == nil { return }
		if user == nil { return }
		
		do {
			try Auth.auth().signOut()
		} catch {
			print("error")
		}
	}
	
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		setFonts()
		self.window = UIWindow(frame: UIScreen.main.bounds)
        FirebaseApp.configure()
		GMSServices.provideAPIKey("AIzaSyBR5VThTUbANiibDRCkNproUVdE8PaBfJI")
		GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
		GIDSignIn.sharedInstance().delegate = self
		FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
		Switcher.updateRootVC()
        // Override point for customization after application launch.
        return true
    }
	
	@available(iOS 9.0, *)
	func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
		return GIDSignIn.sharedInstance().handle(url, sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: [:])
	}
	
	func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
		let handleGoogle = GIDSignIn.sharedInstance().handle(url, sourceApplication: sourceApplication, annotation: annotation)
		let handleFacebook = FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
		
		return handleGoogle || handleFacebook
	}
	
	func setFonts(){
		UILabel.appearance().fontFamily = "Roboto"
		UITextView.appearance().fontFamily = "Roboto"
	}
}

