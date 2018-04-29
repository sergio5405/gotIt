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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		setFonts()
        FirebaseApp.configure()
		GMSServices.provideAPIKey("AIzaSyBR5VThTUbANiibDRCkNproUVdE8PaBfJI")
        // Override point for customization after application launch.
        return true
    }
	
	func setFonts(){
		UILabel.appearance().fontFamily = "Roboto"
		UITextView.appearance().fontFamily = "Roboto"		

	}
}

