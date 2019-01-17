//
//  PhoneNumberViewController.swift
//  MoHA-Membership
//
//  Created by Robby on 10/13/17.
//  Copyright © 2017 Robby Kraft. All rights reserved.
//

import UIKit
import FirebaseDatabase

class PhoneNumberViewController: UIViewController, UITextFieldDelegate {

	let phoneField = UITextField()
	var phoneNumbers:[UILabel] = []
	let instructionLabel = UILabel()
	
	var currentEventKey:String?
	var currentEvent:[String:Any]?

    override func viewDidLoad() {
        super.viewDidLoad()
		
		phoneField.backgroundColor = .clear
		phoneField.textAlignment = .center
		phoneField.keyboardType = .numberPad
		phoneField.tintColor = .white
		phoneField.alpha = 0.0;
		phoneField.delegate = self
		phoneField.addTarget(self, action: #selector(self.textFieldChanged), for: .editingChanged)
		self.view.addSubview(phoneField)
		
		let letterFont = (IS_IPAD)
			? UIFont.systemFont(ofSize: 160)
			: UIFont.systemFont(ofSize: 80)

		for _ in 0..<10{
			let letter = UILabel()
			letter.font = letterFont
			letter.text = "_"
			letter.textColor = .white
			self.view.addSubview(letter)
			self.phoneNumbers.append(letter)
		}
		
		self.instructionLabel.text = "your phone number"
		self.instructionLabel.textColor = .black
		self.instructionLabel.font = .systemFont(ofSize:20)
		self.view.addSubview(self.instructionLabel)

		phoneField.textColor = .white
		self.view.backgroundColor = UIColor.mohaBlue
		
		// load and store current event, its name and its points
		Fire.shared.getData("current_event") { (data) in
			if let eventKey:String = data as? String{
				self.currentEventKey = eventKey
				if let key:String = self.currentEventKey{
					Fire.shared.getData("events/"+key, completionHandler: { (data) in
						if let d = data as? [String:Any]{
							self.currentEvent = d
						}
					})
				}
			}
		}
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		self.instructionLabel.sizeToFit()
		self.instructionLabel.center = CGPoint(x:self.view.center.x, y:self.view.frame.size.height*0.07)

		phoneField.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width*0.8, height: 40)
		phoneField.center = CGPoint(x:self.view.center.x, y:self.view.frame.size.height*0.33)
		
		for i in 0..<10{
			self.phoneNumbers[i].text = "0"
			self.phoneNumbers[i].sizeToFit()
			self.phoneNumbers[i].text = "_"
		}
		
		let w = self.view.frame.size.width
		let h = self.view.frame.size.height
		self.phoneNumbers[0].center = CGPoint(x: w*0.25, y: h*0.2)
		self.phoneNumbers[1].center = CGPoint(x: w*0.5, y: h*0.2)
		self.phoneNumbers[2].center = CGPoint(x: w*0.75, y: h*0.2)

		self.phoneNumbers[3].center = CGPoint(x: w*0.25, y: h*0.4)
		self.phoneNumbers[4].center = CGPoint(x: w*0.5, y: h*0.4)
		self.phoneNumbers[5].center = CGPoint(x: w*0.75, y: h*0.4)

		self.phoneNumbers[6].center = CGPoint(x: w*(0.5-0.2*1.5), y: h*0.6)
		self.phoneNumbers[7].center = CGPoint(x: w*(0.5-0.2*0.5), y: h*0.6)
		self.phoneNumbers[8].center = CGPoint(x: w*(0.5+0.2*0.5), y: h*0.6)
		self.phoneNumbers[9].center = CGPoint(x: w*(0.5+0.2*1.5), y: h*0.6)

		phoneField.becomeFirstResponder()
	}
	
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		if string == "0" ||
			string == "1" ||
			string == "2" ||
			string == "3" ||
			string == "4" ||
			string == "5" ||
			string == "6" ||
			string == "7" ||
			string == "8" ||
			string == "9" {
			return true
		}
		return false
	}
	
	@objc func textFieldChanged() {
		if let phoneNumberString = self.phoneField.text{
			if(phoneNumberString.count >= 10){
				phoneField.isEnabled = false
				tryLogin(phoneNumber:phoneNumberString)
			}
			var i = 0
			for character in phoneNumberString{
				self.phoneNumbers[i].text = "\(character)"
				i += 1
			}
//			for i in 0..<phoneNumberString.count{
//				self.phoneNumbers[i].text = phoneNumberString.[i]
//			}
			for i in phoneNumberString.count..<10{
				self.phoneNumbers[i].text = "_"
			}
		}
	}
	
	func tryLogin(phoneNumber:String){
		let query = Fire.shared.database.child("users").queryOrdered(byChild: "phone").queryEqual(toValue: phoneNumber)
		
		query.observeSingleEvent(of: .value, with: { (snapshot) in
			switch snapshot.childrenCount{
			case 0:
				// no user, create new user
				let vc = CreateUserViewController()
				vc.phoneNumber = phoneNumber
				self.navigationController?.pushViewController(vc, animated: true)
			default:
				let enumerator = snapshot.children
				while let rest = enumerator.nextObject() as? DataSnapshot {
					if let userDictionary = rest.value as? [String:Any]{
						if let events = userDictionary["events"] as? [String]{
							var userPoints = 0
							if let points = userDictionary["points"] as? Int{
								userPoints = points
							}
							if let currentEventKey:String = self.currentEventKey{
								// check if they have already logged into this event
								if events.contains(currentEventKey){
									// alert user, you already got the points for this event
									if let currentEvent:[String:Any] = self.currentEvent{
										var greetingString = "Already checked in"
										if let usernameString:String = userDictionary["name"] as? String{
											greetingString = "Hey " + usernameString
										}
										var messageString = "You already got the points for this event"
										if let points:String = currentEvent["points"] as? String{
											messageString = "You already got the \(points) points for this event"
											if let eventNameString:String = currentEvent["name"] as? String{
												messageString = "You already got the \(points) points for \(eventNameString)"
											}
										}
										let alert = UIAlertController(title: greetingString, message: messageString, preferredStyle: .alert)
										let okayButton = UIAlertAction(title: "okay", style: .default, handler: { (action) in
											// pop to root view controller
											self.navigationController?.popToRootViewController(animated: true)
										})
										alert.addAction(okayButton)
										self.present(alert, animated: true, completion: nil)
									}
								} else{
									// user's first time at this event:
									// 1) add this event to their events
									Fire.shared.addData(currentEventKey, asChildAt: "users/\(rest.ref.key)/events", completionHandler: { (success, newKey, ref) in
										// 2) give them points
										if let currentEvent:[String:Any] = self.currentEvent{
											if let currentEventPoints:String = currentEvent["points"] as? String{
												if let pointsInt = Int(currentEventPoints){
													userPoints += pointsInt
													Fire.shared.setData(userPoints, at: "users/\(rest.ref.key)/points", completionHandler: { (success, newKey) in
														
														let vc = AddPointsViewController()
														vc.user = userDictionary
														vc.addedPoints = pointsInt
														vc.totalPoints = userPoints
														self.navigationController?.pushViewController(vc, animated: true)
													})
												} else{
													// the current event points is stored as a string or something not int compatible
												}
											} else{
												// alert user, no event is happening right now
											}
										} else{
											// current event didn't get pulled down, key doesn't match event, something is wrong with the database setup
										}
									})
								}
							}
						}
						// if there are multiple entries with the same phone just use the first one
						// todo: better handling of edge case
						break
					}
				}
			}
		}) { (error) in
			print(error)
		}

//		Fire.shared.database.child('users').orderByChild('phone').equalTo(phoneNumber).on("value", function(snapshot) {
//			print("yes found")
//			print(snapshot)
//		})
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
