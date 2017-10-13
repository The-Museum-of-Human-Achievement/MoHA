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
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		phoneField.font = .systemFont(ofSize: 40)
		phoneField.backgroundColor = .clear
		phoneField.textAlignment = .center
		phoneField.keyboardType = .numberPad
		phoneField.delegate = self
		phoneField.addTarget(self, action: #selector(self.textFieldChanged), for: .editingChanged)
		self.view.addSubview(phoneField)

		phoneField.textColor = .lightGray
		self.view.backgroundColor = .darkGray
		
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		phoneField.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width*0.8, height: 40)
		phoneField.center = CGPoint(x:self.view.center.x, y:self.view.frame.size.height*0.33)
		
		phoneField.becomeFirstResponder()
	}
	
	@objc func textFieldChanged() {
		if let phoneNumberString = self.phoneField.text as? String{
			print("user enter: \(phoneNumberString)")
			if(phoneNumberString.count >= 10){
				tryLogin(phoneNumber:phoneNumberString)
			}
		}
	}
	
	func tryLogin(phoneNumber:String){
		let query = Fire.shared.database.child("users").queryOrdered(byChild: "phone").queryEqual(toValue: phoneNumber)
		
		query.observeSingleEvent(of: .value, with: { (snapshot) in
			print("snapshot.childrenCount")
			print(snapshot.childrenCount)
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
						print(userDictionary)
						if let email = userDictionary["email"]{
							print("email")
							print(email)
						}
						if let phone = userDictionary["phone"]{
							print("phone")
							print(phone)
						}
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
