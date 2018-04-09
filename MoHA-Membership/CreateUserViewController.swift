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
    let moreButton = UIButton()
	let cancelButton = UIButton()
	let newUserLabel = UILabel()
	let phoneNumberLabel = UILabel()
	let nameField = UITextField()
	let emailField = UITextField()

    override func viewDidLoad() {
        super.viewDidLoad()
		
		cancelButton.setTitle("×", for: .normal)
		cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 60)
		cancelButton.backgroundColor = .clear
		cancelButton.setTitleColor(.white, for: .normal)
		cancelButton.addTarget(self, action: #selector(cancelButtonDidPress), for: .touchUpInside)
		self.view.addSubview(cancelButton)

		phoneNumberLabel.font = UIFont.systemFont(ofSize: 150)
		phoneNumberLabel.adjustsFontSizeToFitWidth = true
		phoneNumberLabel.textColor = .gray
		self.view.addSubview(phoneNumberLabel)

		newUserLabel.font = UIFont.systemFont(ofSize: 150)
		newUserLabel.adjustsFontSizeToFitWidth = true
		self.view.addSubview(newUserLabel)
		
		newUserLabel.text = "welcome, new friend"
		
		nameField.font = UIFont.systemFont(ofSize:40)
		nameField.tintColor = .white
		nameField.textColor = .white
		nameField.delegate = self
		nameField.attributedPlaceholder = NSAttributedString(string: "name", attributes: [NSAttributedStringKey.foregroundColor : UIColor.darkGray])
		self.view.addSubview(nameField)

		emailField.font = UIFont.systemFont(ofSize:40)
		emailField.tintColor = .white
		emailField.textColor = .white
		emailField.delegate = self
		emailField.attributedPlaceholder = NSAttributedString(string: "email", attributes: [NSAttributedStringKey.foregroundColor : UIColor.darkGray])
		self.view.addSubview(emailField)

		newUserLabel.textColor = .white
		self.view.backgroundColor = .black
		
		okayButton.backgroundColor = .gray
		okayButton.setTitle("okay", for: .normal)
		okayButton.setTitleColor(.white, for: .normal)
		okayButton.titleLabel?.font = UIFont.systemFont(ofSize: 40)
		okayButton.addTarget(self, action: #selector(okayButtonHandler), for: .touchUpInside)
		self.view.addSubview(okayButton)
        
        moreButton.backgroundColor = .lightGray
        moreButton.setTitle("help us get grant money", for: .normal)
        moreButton.setTitleColor(.white, for: .normal)
        moreButton.titleLabel?.font = UIFont.systemFont(ofSize: 40)
        //moreButton.addTarget(self, action: #selector(moreButtonHandler), for: .touchUpInside)
        self.view.addSubview(moreButton)
        
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		cancelButton.sizeToFit()
		cancelButton.frame = CGRect(x: 5, y: -20, width: cancelButton.frame.size.width, height: cancelButton.frame.size.height)
		
		okayButton.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 60)
        moreButton.frame = CGRect(x: 0, y: -3, width: self.view.frame.size.width, height: 60)

		
		phoneNumberLabel.sizeToFit()
		newUserLabel.sizeToFit()

		phoneNumberLabel.frame.size.width = self.view.frame.size.width*0.8
		newUserLabel.frame.size.width = self.view.frame.size.width*0.8

		nameField.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width*0.8, height: 50)
		emailField.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width*0.8, height: 50)

		phoneNumberLabel.center = self.view.center
		newUserLabel.center = self.view.center
		nameField.center = self.view.center
		emailField.center = self.view.center

		newUserLabel.center.y = 30
		phoneNumberLabel.center.y = 90
		nameField.center.y = 200
		emailField.center.y = 260
        moreButton.center.y = self.view.frame.size.height - 200
		okayButton.center.y = self.view.frame.size.height - 44 - 22 - 60
		
		if(IS_IPAD){
			newUserLabel.center.y = 80
			phoneNumberLabel.center.y = 200
			nameField.center.y = 360
			emailField.center.y = 440
			okayButton.center.y = 600
//			okayButton.center.y = self.view.frame.size.height - 44 - 22 - 60

		}
		
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		nameField.becomeFirstResponder()
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
				if let name = nameField.text{
					if name.trimmingCharacters(in: .whitespaces) == ""{
						let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
						let dismissAction = UIAlertAction(title: "we need a name", style: .default, handler: nil)
						alert.addAction(dismissAction)
						self.present(alert, animated: true, completion: nil)
						self.okayButton.isEnabled = true
						return
					}

					let userDictionary = ["name":name, "email":email, "phone":phone]
					Fire.shared.addData(userDictionary, asChildAt: "users") { (success, newUserKeyOptional, ref) in
						if let newUserKey = newUserKeyOptional{
							// user created
							// check if there is an event
							
							Fire.shared.getData("current_event") { (data) in
								if let eventKey:String = data as? String{
									Fire.shared.getData("events/"+eventKey, completionHandler: { (data) in
										if let currentEvent = data as? [String:Any]{
											if let eventPoints:String = currentEvent["points"] as? String{
												let vc = AddPointsViewController()
												vc.user = userDictionary
												vc.totalPoints = Int(eventPoints)
												vc.addedPoints = Int(eventPoints)
												Fire.shared.setData([eventKey], at: "users/\(newUserKey)/events", completionHandler: { (success, ref) in
													Fire.shared.setData(eventPoints, at: "users/\(newUserKey)/points", completionHandler: { (success, ref) in
														self.navigationController?.pushViewController(vc, animated: true)
													})
												})
											}
										}
									})
								} else{
									// no event. just make the account and return home
									
								}
							}

						}
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
