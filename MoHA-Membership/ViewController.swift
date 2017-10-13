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
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		welcomeLabel.text = "hello"
		welcomeLabel.font = UIFont.systemFont(ofSize: 150)
		welcomeLabel.adjustsFontSizeToFitWidth = true
		self.view.addSubview(welcomeLabel)
		
//		Fire.shared.addData(["name":"robby kraft", "phone": "940-765-1810", "email":"robbykraft@gmail.com"], asChildAt: "users", completionHandler: nil)
		
		welcomeLabel.textColor = .darkGray
		self.view.backgroundColor = .black
		
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapHandler(sender:)))
		self.view.addGestureRecognizer(tapGesture)
	}
	
	@objc func tapHandler(sender: UITapGestureRecognizer){
		self.navigationController?.pushViewController(PhoneNumberViewController(), animated: true)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		var screenCenter = self.view.center
		screenCenter.y -= 20
		welcomeLabel.sizeToFit()
		welcomeLabel.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width*0.8, height: welcomeLabel.frame.size.height)
		welcomeLabel.center = screenCenter
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

