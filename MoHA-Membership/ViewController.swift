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
	let instructionLabel = UILabel()
	let mohaLogo = UIImageView()
	
	var tapGesture = UITapGestureRecognizer()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		mohaLogo.image = #imageLiteral(resourceName: "moha").imageWithTint(.white)
		mohaLogo.frame = CGRect(x: self.view.bounds.size.width*0.1,
								y: self.view.bounds.size.width*0.1,
								width: self.view.bounds.size.width*0.3333,
								height: self.view.bounds.size.width*0.3333)
		self.view.addSubview(mohaLogo)
		
		welcomeLabel.text = "Welcome to\nMoHA"
		welcomeLabel.numberOfLines = 2
		welcomeLabel.font = UIFont.systemFont(ofSize: 150)
		welcomeLabel.adjustsFontSizeToFitWidth = true
		welcomeLabel.textColor = .white
		self.view.addSubview(welcomeLabel)
		
		instructionLabel.text = "Please continue by entering your phone number on the next screen."
		instructionLabel.numberOfLines = 3
		instructionLabel.font = UIFont.systemFont(ofSize: 50)
		instructionLabel.adjustsFontSizeToFitWidth = true
		instructionLabel.textColor = .black
		self.view.addSubview(instructionLabel)

		Fire.shared.addData(["name":"November Open Studios", "points":"100"], asChildAt: "events", completionHandler: nil)
		
		self.view.backgroundColor = UIColor.mohaBlue
		
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
		welcomeLabel.frame = CGRect(x: self.view.bounds.size.width*0.1, y: 0, width: self.view.frame.size.width*0.8, height: welcomeLabel.frame.size.height)
		welcomeLabel.sizeToFit()
//		welcomeLabel.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width*0.8, height: welcomeLabel.frame.size.height)
		welcomeLabel.center.y = screenCenter.y
		
		instructionLabel.frame = CGRect(x: self.view.bounds.size.width*0.1, y: 0, width: self.view.frame.size.width*0.8, height: instructionLabel.frame.size.height)
		instructionLabel.sizeToFit()
//		instructionLabel.frame.origin.y = welcomeLabel.frame.origin.y + welcomeLabel.frame.size.height + 40
		instructionLabel.frame.origin.y = self.view.bounds.size.height * 0.666

		// enable tap gesture again
		tapGesture.isEnabled = true
	}
	
	@objc func didFadeOutHandler(){
		UIView.beginAnimations("fadeTitle", context: nil)
		UIView.setAnimationCurve(.easeInOut)
		UIView.setAnimationDuration(3.0)
		UIView.setAnimationDelegate(self)
		UIView.setAnimationDidStop(#selector(self.didFadeInHandler))
		self.welcomeLabel.alpha = 1.0
		self.mohaLogo.alpha = 1.0
		UIView.commitAnimations()
	}
	
	@objc func didFadeInHandler(){
		UIView.beginAnimations("fadeTitle", context: nil)
		UIView.setAnimationCurve(.easeInOut)
		UIView.setAnimationDuration(3.0)
		UIView.setAnimationDelegate(self)
		UIView.setAnimationDidStop(#selector(self.didFadeOutHandler))
		self.welcomeLabel.alpha = 0.6
		self.mohaLogo.alpha = 0.6
		UIView.commitAnimations()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

