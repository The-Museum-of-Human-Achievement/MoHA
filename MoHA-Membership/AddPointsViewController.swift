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
	let pointsLabelBG = UIView()
//	let totalLabel = UILabel()
	let promo1 = UILabel()
	let promo2 = UILabel()
	let promo3 = UILabel()
	let donateButton = UIButton()
	let surveyButton = UIButton()

	var addedPoints:Int?{
		didSet{
			if let points = addedPoints{
				addingPointsLabel.text = "You just earned \(points) pts.\nYou now have a total of"
			}
		}
	}
	var totalPoints:Int?{
		didSet{
			if let points = totalPoints{
				pointsLabel.text = "\(points) pts!"
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
	
	var username:String?{
		didSet{
			if let name = self.username{
				self.usernameLabel.text = "hi " + name
			}
		}
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapHandler(sender:)))
		self.view.addGestureRecognizer(tapGesture)

		usernameLabel.font = UIFont.systemFont(ofSize: 90)
		usernameLabel.adjustsFontSizeToFitWidth = true
		self.view.addSubview(usernameLabel)
		
		pointsLabelBG.backgroundColor = .white
		self.view.addSubview(pointsLabelBG)
		pointsLabel.font = UIFont.systemFont(ofSize: 150)
		pointsLabel.adjustsFontSizeToFitWidth = true
		self.view.addSubview(pointsLabel)

		addingPointsLabel.font = UIFont.systemFont(ofSize: 50)
		addingPointsLabel.adjustsFontSizeToFitWidth = true
		addingPointsLabel.numberOfLines = 2
		self.view.addSubview(addingPointsLabel)
		
//		totalLabel.font = UIFont.systemFont(ofSize: 150)
//		totalLabel.adjustsFontSizeToFitWidth = true
//		totalLabel.text = "total points"
//		self.view.addSubview(totalLabel)
		promo1.text = "Do you believe in space?"
		promo2.text = "Help the MoHA community even more by"
		promo3.text = "or taking our"
		donateButton.setTitle("making a donation", for: .normal)
		surveyButton.setTitle("audience survey", for: .normal)
		promo1.textColor = .black
		promo2.textColor = UIColor(white: 1.0, alpha: 0.5)
		promo3.textColor = UIColor(white: 1.0, alpha: 0.5)
		donateButton.setTitleColor(.white, for: .normal)
		surveyButton.setTitleColor(.white, for: .normal)
		self.view.addSubview(promo1)
		self.view.addSubview(promo2)
		self.view.addSubview(promo3)
		self.view.addSubview(donateButton)
		self.view.addSubview(surveyButton)
		promo1.font = UIFont.systemFont(ofSize: 40)
		promo2.font = UIFont.systemFont(ofSize: 40)
		promo3.font = UIFont.systemFont(ofSize: 40)
		donateButton.titleLabel?.font = UIFont.systemFont(ofSize: 40)
		surveyButton.titleLabel?.font = UIFont.systemFont(ofSize: 40)
		promo2.numberOfLines = 2

		usernameLabel.textColor = .white
		addingPointsLabel.textColor = .black
		pointsLabel.textColor = UIColor.mohaBlue
//		totalLabel.textColor = .lightGray
		self.view.backgroundColor = UIColor.mohaBlue
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		usernameLabel.sizeToFit()
		addingPointsLabel.sizeToFit()
		pointsLabel.sizeToFit()
//		totalLabel.sizeToFit()
		usernameLabel.frame.size.width = self.view.frame.size.width*0.8
		addingPointsLabel.frame.size.width = self.view.frame.size.width*0.8
		pointsLabel.frame.size.width = self.view.frame.size.width*0.8
		
//		totalLabel.frame.size.width = self.view.frame.size.width*0.8

		usernameLabel.center = self.view.center
		addingPointsLabel.center = self.view.center
//		pointsLabel.center = self.view.center
//		totalLabel.center = self.view.center
		
		usernameLabel.center.y = 80
//		pointsLabel.center.y = self.view.center.y
//		addingPointsLabel.center.y = pointsLabel.frame.origin.y - addingPointsLabel.frame.size.height*0.5
		addingPointsLabel.center.y = 140
//		totalLabel.center.y = self.view.center.y - (22+44)*0.5 + 100
		
		if(IS_IPAD){
			usernameLabel.center.y = 80
//			pointsLabel.center.y = self.view.center.y
			addingPointsLabel.center.y = 220
//			totalLabel.center.y = self.view.center.y + 160
		}
		let pad:CGFloat = 40
		let smPad:CGFloat = 5
		pointsLabel.frame.origin = CGPoint(x: self.view.frame.size.width*0.1, y: addingPointsLabel.frame.origin.y + addingPointsLabel.frame.size.height + pad)
		pointsLabelBG.frame = pointsLabel.frame
		
		promo1.frame.size.width = self.view.frame.size.width*0.8
		promo2.frame.size.width = self.view.frame.size.width*0.8
		promo3.frame.size.width = self.view.frame.size.width*0.8
		promo1.sizeToFit()
		promo2.sizeToFit()
		promo3.sizeToFit()
		surveyButton.sizeToFit()
		donateButton.sizeToFit()
		
		promo1.frame.origin = CGPoint(x: self.view.frame.size.width*0.1, y: pointsLabel.frame.origin.y + pointsLabel.frame.size.height + pad)
		promo2.frame.origin = CGPoint(x: self.view.frame.size.width*0.1, y: promo1.frame.origin.y + promo1.frame.size.height + smPad)
		donateButton.frame.origin = CGPoint(x: self.view.frame.size.width*0.1, y: promo2.frame.origin.y + promo2.frame.size.height + smPad)
		promo3.frame.origin = CGPoint(x: self.view.frame.size.width*0.1, y: donateButton.frame.origin.y + donateButton.frame.size.height + smPad)
		surveyButton.frame.origin = CGPoint(x: self.view.frame.size.width*0.1, y: promo3.frame.origin.y + promo3.frame.size.height + smPad)


	}
	
	@objc func tapHandler(sender: UITapGestureRecognizer){
		self.navigationController?.popToRootViewController(animated: true)
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
}
