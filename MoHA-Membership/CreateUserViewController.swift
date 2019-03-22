//
//  CreateUserViewController.swift
//  MoHA-Membership
//
//  Created by Robby on 10/13/17.
//  Copyright © 2017 Robby Kraft. All rights reserved.
//

import UIKit

class CreateUserViewController: UIViewController, UITextFieldDelegate {
	
	var phoneNumber:String?{
		didSet{
			if let numberString:String = self.phoneNumber{
				let aIndex = numberString.index(numberString.startIndex, offsetBy: 3)
				let bIndex = numberString.index(numberString.startIndex, offsetBy: 6)
				let a = numberString[numberString.startIndex..<aIndex]
				let b = numberString[aIndex..<bIndex]
				let c = numberString[bIndex..<numberString.endIndex]
				self.phoneNumberLabel.text = "\(a) \(b) \(c)"
			}
		}
	}
	
	let okayButton = UIButton()
//	let moreButton = UIButton()
	let cancelButton = UIButton()
	let newUserLabel = UILabel()
	let phoneNumberLabel = UILabel()
	let firstNameField = UITextField()
//	let lastNameField = UITextField()
	let emailField = UITextField()

	override func viewDidLoad() {
		super.viewDidLoad()
		
		cancelButton.setTitle("×", for: .normal)
		cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 60)
		cancelButton.backgroundColor = .clear
		cancelButton.setTitleColor(.white, for: .normal)
		cancelButton.addTarget(self, action: #selector(cancelButtonDidPress), for: .touchUpInside)
		self.view.addSubview(cancelButton)

		phoneNumberLabel.font = UIFont.systemFont(ofSize: 38)
		phoneNumberLabel.adjustsFontSizeToFitWidth = true
		phoneNumberLabel.textColor = .white
		self.view.addSubview(phoneNumberLabel)

		newUserLabel.font = UIFont.systemFont(ofSize: 150)
		newUserLabel.adjustsFontSizeToFitWidth = true
		newUserLabel.textColor = .black
		self.view.addSubview(newUserLabel)
		
		newUserLabel.text = "Hello, new friend."
		
		firstNameField.font = UIFont.systemFont(ofSize:38)
		firstNameField.tintColor = .white
		firstNameField.textColor = .white
		firstNameField.delegate = self
		firstNameField.attributedPlaceholder = NSAttributedString(string: "Your Name", attributes: [NSAttributedStringKey.foregroundColor : UIColor(white: 1.0, alpha: 0.5)])
		self.view.addSubview(firstNameField)
		
//		lastNameField.font = UIFont.systemFont(ofSize:38)
//		lastNameField.tintColor = .white
//		lastNameField.textColor = .white
//		lastNameField.delegate = self
//		lastNameField.attributedPlaceholder = NSAttributedString(string: "last", attributes: [NSAttributedStringKey.foregroundColor : UIColor(white: 1.0, alpha: 0.5)])
//		self.view.addSubview(lastNameField)

		emailField.font = UIFont.systemFont(ofSize:38)
		emailField.tintColor = .white
		emailField.textColor = .white
		emailField.delegate = self
		emailField.attributedPlaceholder = NSAttributedString(string: "Your Email", attributes: [NSAttributedStringKey.foregroundColor : UIColor(white: 1.0, alpha: 0.5)])
		self.view.addSubview(emailField)

		self.view.backgroundColor = UIColor.mohaBlue
		
		okayButton.backgroundColor = .white
		okayButton.setTitle("Join Us", for: .normal)
		okayButton.setTitleColor(UIColor.mohaBlue, for: .normal)
		okayButton.titleLabel?.font = UIFont.systemFont(ofSize: 38)
		okayButton.addTarget(self, action: #selector(okayButtonHandler), for: .touchUpInside)
		self.view.addSubview(okayButton)
		
//		moreButton.backgroundColor = .lightGray
//		moreButton.setTitle("help us get grant money", for: .normal)
//		moreButton.setTitleColor(.white, for: .normal)
//		moreButton.titleLabel?.font = UIFont.systemFont(ofSize: 38)
		//moreButton.addTarget(self, action: #selector(moreButtonHandler), for: .touchUpInside)
//		self.view.addSubview(moreButton)
		
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		cancelButton.sizeToFit()
		cancelButton.frame = CGRect(x: 5, y: -20, width: cancelButton.frame.size.width, height: cancelButton.frame.size.height)
		
		okayButton.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 80)
//		moreButton.frame = CGRect(x: 0, y: -3, width: self.view.frame.size.width, height: 60)
		
		phoneNumberLabel.sizeToFit()
		newUserLabel.sizeToFit()

		phoneNumberLabel.frame.size.width = self.view.frame.size.width*0.8
		newUserLabel.frame.size.width = self.view.frame.size.width*0.8

		firstNameField.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width*0.8, height: 50)
//		lastNameField.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width*0.8, height: 50)
		emailField.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width*0.8, height: 50)

		phoneNumberLabel.center = self.view.center
		newUserLabel.center = self.view.center
		firstNameField.center = self.view.center
//		lastNameField.center = self.view.center
		emailField.center = self.view.center

		let scale:CGFloat = (IS_IPAD) ? 2 : 1
		newUserLabel.center.y = 30 * scale
		phoneNumberLabel.center.y = 90 * scale
		firstNameField.center.y = phoneNumberLabel.center.y + 50 * scale
//		lastNameField.center.y = firstNameField.center.y + 50 * scale
		emailField.center.y = firstNameField.center.y + 50 * scale
		okayButton.center.y = emailField.center.y + 80 * scale
		
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		firstNameField.becomeFirstResponder()
	}

	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return false
	}
	
	@objc func cancelButtonDidPress(){
		self.navigationController?.popToRootViewController(animated: true)
	}

	@objc func okayButtonHandler(){
		self.okayButton.isEnabled = false
		
		if let phone = self.phoneNumber{
			if let email = emailField.text{
				if !isValidEmail(testStr: email){
					let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
					let dismissAction = UIAlertAction(title: "email doesn't appear valid", style: .default, handler: nil)
					alert.addAction(dismissAction)
					self.present(alert, animated: true, completion: nil)
					self.okayButton.isEnabled = true
					return
				}
				
				guard let firstName = self.firstNameField.text else { return }
//				guard let lastName = self.lastNameField.text else { return }
				if firstName.trimmingCharacters(in: .whitespaces) == ""{
					let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
					let dismissAction = UIAlertAction(title: "can we get a name?", style: .default, handler: nil)
					alert.addAction(dismissAction)
					self.present(alert, animated: true, completion: nil)
					self.okayButton.isEnabled = true
					return
				}
//				if lastName.trimmingCharacters(in: .whitespaces) == ""{
//					let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
//					let dismissAction = UIAlertAction(title: "can we get a last name?", style: .default, handler: nil)
//					alert.addAction(dismissAction)
//					self.present(alert, animated: true, completion: nil)
//					self.okayButton.isEnabled = true
//					return
//				}
				MoHA.shared.updateMailchimp(first: firstName, last: "", email: email, phone: phone)
				MoHA.shared.updateFirebase(first: firstName, last: "", email: email, phone: phone) { (success, points) in
					if success && points != 0 {
						let vc = AddPointsViewController()
						vc.username = firstName
						vc.totalPoints = points
						vc.addedPoints = points
						self.navigationController?.pushViewController(vc, animated: true)
					} else{
						// no event. just make the account and return home
						let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
						let dismissAction = UIAlertAction(title: "Thanks! You're a friend.", style: .default, handler: { (action) in
							self.navigationController?.popToRootViewController(animated: true)
						})
						alert.addAction(dismissAction)
						self.present(alert, animated: true, completion: nil)
						self.okayButton.isEnabled = true
						return
					}
				}
			}
		}
	}
	
	func isValidEmail(testStr:String) -> Bool {
		let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
		let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
		let result = emailTest.evaluate(with:testStr)
		return result
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
}
