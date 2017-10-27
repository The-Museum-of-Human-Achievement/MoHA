//
//  ViewController.swift
//  MoHA-Membership
//
//  Created by Robby on 10/13/17.
//  Copyright © 2017 Robby Kraft. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	let welcomeLabel = UILabel()
	
	var tapGesture = UITapGestureRecognizer()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		welcomeLabel.text = "hello"
		welcomeLabel.font = UIFont.systemFont(ofSize: 150)
		welcomeLabel.adjustsFontSizeToFitWidth = true
		self.view.addSubview(welcomeLabel)
		
//		Fire.shared.addData(["name":"November Open Studios", "points":"100"], asChildAt: "events", completionHandler: nil)
		
		welcomeLabel.alpha = 0.1;
		welcomeLabel.textColor = .darkGray
		self.view.backgroundColor = .black
		
		tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapHandler(sender:)))
		self.view.addGestureRecognizer(tapGesture)

		self.didFadeOutHandler()

	}
	
	@objc func tapHandler(sender: UITapGestureRecognizer){
		sender.isEnabled = false
		self.navigationController?.pushViewController(PhoneNumberViewController(), animated: true)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		var screenCenter = self.view.center
		screenCenter.y -= 20
		welcomeLabel.sizeToFit()
		welcomeLabel.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width*0.8, height: welcomeLabel.frame.size.height)
		welcomeLabel.center = screenCenter
		
		// enable tap gesture again
		tapGesture.isEnabled = true
	}
	
	@objc func didFadeOutHandler(){
		UIView.beginAnimations("fadeTitle", context: nil)
		UIView.setAnimationCurve(.easeInOut)
		UIView.setAnimationDuration(2.0)
		UIView.setAnimationDelegate(self)
		UIView.setAnimationDidStop(#selector(self.didFadeInHandler))
		self.welcomeLabel.alpha = 1.0
		UIView.commitAnimations()
	}
	
	@objc func didFadeInHandler(){
		UIView.beginAnimations("fadeTitle", context: nil)
		UIView.setAnimationCurve(.easeInOut)
		UIView.setAnimationDuration(2.0)
		UIView.setAnimationDelegate(self)
		UIView.setAnimationDidStop(#selector(self.didFadeOutHandler))
		self.welcomeLabel.alpha = 0.1
		UIView.commitAnimations()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

