//
//  mohaUsers.swift
//  MoHA-Membership
//
//  Created by Robby Kraft on 1/18/19.
//  Copyright © 2019 Robby Kraft. All rights reserved.
//

import Foundation

class MoHA {
	
	static let shared = MoHA()
	
	// fill on boot
	var mailchimpKey:String = ""
	
	fileprivate init(){
		loadSystemPList()
	}
	
	func loadSystemPList(){
		func pListBootError(){ print("plist is corrupt. app bundle directory has been modified.") }
		guard let plistPath = Bundle.main.path(forResource: "keys", ofType: "plist") else { pListBootError(); return }
		guard let plistData = FileManager.default.contents(atPath: plistPath) else { pListBootError(); return }
		var format = PropertyListSerialization.PropertyListFormat.xml
		guard let pListDict = try! PropertyListSerialization.propertyList(from: plistData, options: .mutableContainersAndLeaves, format: &format) as? [String:AnyObject] else { pListBootError(); return }
		guard let mailchimpKey = pListDict["mailchimp"] as? String else { pListBootError(); return }
		self.mailchimpKey = mailchimpKey
	}
	
	func updateMailchimp(first:String, last:String, email:String, phone:String){
		
		let sendData:[String:Any] = [
			"email_address": email,
			"status": "pending",
			"merge_fields": [
				"FNAME": first,
				"LNAME": last,
				"MMERGE6": phone
			]
		]
		
		var request = URLRequest(url: URL(string: "https://us6.api.mailchimp.com/3.0/lists/a22127e440/members")!)
		request.httpMethod = "POST"
		request.addValue("apikey " + mailchimpKey, forHTTPHeaderField: "Authorization")
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		do{
			try request.httpBody = JSONSerialization.data(withJSONObject: sendData, options: .prettyPrinted)
		} catch {
		}
		
		let task = URLSession.shared.dataTask(with: request) { data, response, error in
			guard error == nil else {
				print(error!)
				return
			}
			guard let data = data else {
				print("Data is empty")
				return
			}
			let json = try! JSONSerialization.jsonObject(with: data, options: [])
			print(json)
		}
		task.resume()
	}
	
	
	func updateFirebase(first:String, last:String, email:String, phone:String, completionHandler:((Bool, Int)->())?){
		let userDictionary = ["firstname":first, "lastname":last, "email":email, "phone":phone]
		
		Fire.shared.addData(userDictionary, asChildAt: "users") { (success, newUserKeyOptional, ref) in
			if let newUserKey = newUserKeyOptional{
				// user created
				// check if there is an event
				
				Fire.shared.getData("current_event") { (data) in
					if let eventKey:String = data as? String{
						Fire.shared.getData("events/"+eventKey, completionHandler: { (data) in
							if let currentEvent = data as? [String:Any]{
								if let eventPoints:Int = currentEvent["points"] as? Int{
									Fire.shared.setData([eventKey], at: "users/\(newUserKey)/events", completionHandler: { (success, ref) in
										Fire.shared.setData(eventPoints, at: "users/\(newUserKey)/points", completionHandler: { (success, ref) in
											completionHandler?(true, eventPoints)
										})
									})
								}
							}
						})
					} else{
						completionHandler?(true, 0)
					}
				}
			}
		}
	}
	
}
