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
	
	var currentEventKey:String?
	var currentEvent:[String:Any]?

    override func viewDidLoad() {
        super.viewDidLoad()
		
		phoneField.font = .systemFont(ofSize: 40)
		phoneField.backgroundColor = .clear
		phoneField.textAlignment = .center
		phoneField.keyboardType = .numberPad
		phoneField.tintColor = .white
		phoneField.placeholder = "phone number"
		phoneField.delegate = self
		phoneField.addTarget(self, action: #selector(self.textFieldChanged), for: .editingChanged)
		self.view.addSubview(phoneField)

		phoneField.textColor = .lightGray
		self.view.backgroundColor = .darkGray
		
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
		
		phoneField.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width*0.8, height: 40)
		phoneField.center = CGPoint(x:self.view.center.x, y:self.view.frame.size.height*0.33)
		
		phoneField.becomeFirstResponder()
	}
	
	@objc func textFieldChanged() {
		if let phoneNumberString = self.phoneField.text{
			if(phoneNumberString.count >= 10){
				phoneField.isEnabled = false
				tryLogin(phoneNumber:phoneNumberString)
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
