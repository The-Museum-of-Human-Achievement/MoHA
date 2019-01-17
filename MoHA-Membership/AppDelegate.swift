//
//  AppDelegate.swift
//  MoHA-Membership
//
//  Created by Robby on 10/13/17.
//  Copyright © 2017 Robby Kraft. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

let IS_IPAD:Bool = UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad
let IS_IPHONE:Bool = UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
		
		FirebaseApp.configure()

		_ = Fire.shared
		
		Auth.auth().signIn(withEmail: "zac@themuseumofhumanachievement.com", password: "mohahaha", completion: { (user, error) in
			if(error == nil){
				DispatchQueue.main.async {
					// Success, logging in with email
					self.window = UIWindow()
					self.window?.frame = UIScreen.main.bounds
					self.window?.rootViewController = MasterNavigationController()
					self.window?.makeKeyAndVisible()
				}
			}
		})

		return true
	}

	func applicationWillResignActive(_ application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
	}

	func applicationDidEnterBackground(_ application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	}

	func applicationWillEnterForeground(_ application: UIApplication) {
		// Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
	}

	func applicationDidBecomeActive(_ application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	}

	func applicationWillTerminate(_ application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	}
	
}



extension UIImage{
	public func imageWithTint(_ color:UIColor) -> UIImage{
		UIGraphicsBeginImageContextWithOptions(self.size, false, UIScreen.main.scale)
		let context = UIGraphicsGetCurrentContext()
		context?.translateBy(x: 0, y: self.size.height)
		context?.scaleBy(x: 1.0, y: -1.0)
		let rect:CGRect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
		context?.setBlendMode(.normal)
		context?.draw(self.cgImage!, in: rect)
		context?.setBlendMode(.sourceIn)
		color.setFill()
		context?.fill(rect)
		let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return tintedImage!
	}
}


extension UIColor{
	static let mohaBlue = UIColor(red: 4/255, green: 94/255, blue: 163/255, alpha: 1.0)
}
