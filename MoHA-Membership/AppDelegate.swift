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

struct AppFontName {
	static let regular = "TrebuchetMS-Bold"
	static let bold = "TrebuchetMS-Bold"
	static let italic = "Trebuchet-BoldItalic"
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
		
		FirebaseApp.configure()

		_ = Fire.shared
		_ = MoHA.shared
		
		// setup app-wide style settings here
		UIFont.overrideInitialize()

		Auth.auth().signIn(withEmail: "zac@themuseumofhumanachievement.com", password: "mohahaha", completion: { (user, error) in
			if(error == nil){
				DispatchQueue.main.async {
					// Success, logging in with email
					self.window = UIWindow()
					self.window?.frame = UIScreen.main.bounds
					self.window?.rootViewController = MasterNavigationController()
//					let vc = AddPointsViewController()
//					vc.username = "Robby"
//					vc.addedPoints = 5
//					vc.totalPoints = 8
//					self.window?.rootViewController = vc
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


extension UIFontDescriptor.AttributeName {
	static let nsctFontUIUsage = UIFontDescriptor.AttributeName(rawValue: "NSCTFontUIUsageAttribute")
}

extension UIFont {
	@objc class func mySystemFont(ofSize size: CGFloat) -> UIFont {
		return UIFont(name: AppFontName.regular, size: size)!
	}
	@objc class func myBoldSystemFont(ofSize size: CGFloat) -> UIFont {
		return UIFont(name: AppFontName.bold, size: size)!
	}
	@objc class func myItalicSystemFont(ofSize size: CGFloat) -> UIFont {
		return UIFont(name: AppFontName.italic, size: size)!
	}
	@objc convenience init(myCoder aDecoder: NSCoder) {
		guard
			let fontDescriptor = aDecoder.decodeObject(forKey: "UIFontDescriptor") as? UIFontDescriptor,
			let fontAttribute = fontDescriptor.fontAttributes[.nsctFontUIUsage] as? String else {
				self.init(myCoder: aDecoder)
				return
		}
		var fontName = ""
		switch fontAttribute {
		case "CTFontRegularUsage":
			fontName = AppFontName.regular
		case "CTFontEmphasizedUsage", "CTFontBoldUsage":
			fontName = AppFontName.bold
		case "CTFontObliqueUsage":
			fontName = AppFontName.italic
		default:
			fontName = AppFontName.regular
		}
		self.init(name: fontName, size: fontDescriptor.pointSize)!
	}
	
	class func overrideInitialize() {
		guard self == UIFont.self else { return }
		
		if let systemFontMethod = class_getClassMethod(self, #selector(systemFont(ofSize:))),
			let mySystemFontMethod = class_getClassMethod(self, #selector(mySystemFont(ofSize:))) {
			method_exchangeImplementations(systemFontMethod, mySystemFontMethod)
		}
		
		if let boldSystemFontMethod = class_getClassMethod(self, #selector(boldSystemFont(ofSize:))),
			let myBoldSystemFontMethod = class_getClassMethod(self, #selector(myBoldSystemFont(ofSize:))) {
			method_exchangeImplementations(boldSystemFontMethod, myBoldSystemFontMethod)
		}
		
		if let italicSystemFontMethod = class_getClassMethod(self, #selector(italicSystemFont(ofSize:))),
			let myItalicSystemFontMethod = class_getClassMethod(self, #selector(myItalicSystemFont(ofSize:))) {
			method_exchangeImplementations(italicSystemFontMethod, myItalicSystemFontMethod)
		}
		
		if let initCoderMethod = class_getInstanceMethod(self, #selector(UIFontDescriptor.init(coder:))), // Trick to get over the lack of UIFont.init(coder:))
			let myInitCoderMethod = class_getInstanceMethod(self, #selector(UIFont.init(myCoder:))) {
			method_exchangeImplementations(initCoderMethod, myInitCoderMethod)
		}
	}
}

