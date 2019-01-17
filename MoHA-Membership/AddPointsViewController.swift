//
//  AddPointsViewController.swift
//  MoHA-Membership
//
//  Created by Robby on 10/13/17.
//  Copyright © 2017 Robby Kraft. All rights reserved.
//

import UIKit

class AddPointsViewController: UIViewController {
	
	let usernameLabel = UILabel()
	let addingPointsLabel = UILabel()
	let pointsLabel = UILabel()
	let totalLabel = UILabel()

	var addedPoints:Int?{
		didSet{
			if let points = addedPoints{
				addingPointsLabel.text = "added \(points) points"
			}
		}
	}
	var totalPoints:Int?{
		didSet{
			if let points = totalPoints{
				pointsLabel.text = "\(points)"
			}
		}
	}

	var user:[String:Any]?{
		didSet{
			if let u = self.user{
				print(u)
				if let name = u["name"] as? String{
					self.usernameLabel.text = "hi " + name
				}
//				if let email = u["email"]{ }
//				if let phone = u["phone"]{ }
			}
		}
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapHandler(sender:)))
		self.view.addGestureRecognizer(tapGesture)

		usernameLabel.font = UIFont.systemFont(ofSize: 150)
		usernameLabel.adjustsFontSizeToFitWidth = true
		self.view.addSubview(usernameLabel)
		
		pointsLabel.font = UIFont.systemFont(ofSize: 150)
		pointsLabel.adjustsFontSizeToFitWidth = true
		self.view.addSubview(pointsLabel)

		addingPointsLabel.font = UIFont.systemFont(ofSize: 150)
		addingPointsLabel.adjustsFontSizeToFitWidth = true
		self.view.addSubview(addingPointsLabel)
		
		totalLabel.font = UIFont.systemFont(ofSize: 150)
		totalLabel.adjustsFontSizeToFitWidth = true
		totalLabel.text = "total points"
		self.view.addSubview(totalLabel)

		usernameLabel.textColor = .lightGray
		addingPointsLabel.textColor = .lightGray
		pointsLabel.textColor = .white
		totalLabel.textColor = .lightGray
		self.view.backgroundColor = UIColor.mohaBlue
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		usernameLabel.sizeToFit()
		addingPointsLabel.sizeToFit()
		pointsLabel.sizeToFit()
		totalLabel.sizeToFit()
		usernameLabel.frame.size.width = self.view.frame.size.width*0.8
		addingPointsLabel.frame.size.width = self.view.frame.size.width*0.8
		pointsLabel.frame.size.width = self.view.frame.size.width*0.8
		totalLabel.frame.size.width = self.view.frame.size.width*0.8

		usernameLabel.center = self.view.center
		addingPointsLabel.center = self.view.center
		pointsLabel.center = self.view.center
		totalLabel.center = self.view.center
		
		usernameLabel.center.y = 80
		pointsLabel.center.y = self.view.center.y
//		addingPointsLabel.center.y = pointsLabel.frame.origin.y - addingPointsLabel.frame.size.height*0.5
		addingPointsLabel.center.y = 140
		totalLabel.center.y = self.view.center.y - (22+44)*0.5 + 100
		
		if(IS_IPAD){
			usernameLabel.center.y = 80
			pointsLabel.center.y = self.view.center.y
			addingPointsLabel.center.y = 220
			totalLabel.center.y = self.view.center.y + 160
		}
	}
	
	@objc func tapHandler(sender: UITapGestureRecognizer){
		self.navigationController?.popToRootViewController(animated: true)
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
