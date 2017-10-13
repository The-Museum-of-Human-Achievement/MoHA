//
//  PhoneNumberViewController.swift
//  MoHA-Membership
//
//  Created by Robby on 10/13/17.
//  Copyright © 2017 Robby Kraft. All rights reserved.
//

import UIKit

class PhoneNumberViewController: UIViewController {

	let phoneField = UITextField()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		phoneField.font = .systemFont(ofSize: 50)
		phoneField.backgroundColor = .white
		phoneField.keyboardType = .numberPad
		
		self.view.backgroundColor = .darkGray
		
		self.view.addSubview(phoneField)
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		phoneField.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width*0.8, height: 50)
		phoneField.center = self.view.center
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
