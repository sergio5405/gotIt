//
//  FeedTVCell.swift
//  gotIt
//
//  Created by Sergio Hernandez Jr on 03/04/18.
//  Copyright © 2018 Sergio Hernandez. All rights reserved.
//

import UIKit

class FeedTVCell: UITableViewCell {
	@IBOutlet weak var bgViewColor: UIView!
	@IBOutlet weak var cellImgView: UIImageView!
	@IBOutlet weak var distanceLbl: UILabel!
	@IBOutlet weak var titleLbl: UILabel!
	@IBOutlet weak var priceLbl: UILabel!
	@IBOutlet weak var scheduleLbl: UILabel!
	
	var offer: Offer! {
		didSet {
			self.updateUI()
		}
	}
	
	func updateUI(){
		cellImgView.image = offer.images?.first
		distanceLbl.text = String(format: "%.01f km", locale: Locale.current, arguments: [offer.distanceTo])
		titleLbl.text = offer.title
		priceLbl.text = String(format: "$%.02f - $%.02f", locale: Locale.current, arguments: [offer.price.0, offer.price.1])

		
		if let serviceOffer = offer as? Service{
			let calendar = Calendar.current
			let beginTime = calendar.dateComponents([.hour, .minute], from: serviceOffer.schedule.0)
			let beginH = beginTime.hour
			let beginM = beginTime.minute
			let endTime = calendar.dateComponents([.hour, .minute], from: serviceOffer.schedule.1)
			let endH = endTime.hour
			let endM = endTime.minute
			scheduleLbl.text = String(format: "%d:%02d - %d:%02d", locale: Locale.current, arguments: [beginH!, beginM!, endH!, endM!])
			bgViewColor.backgroundColor = UIColor(red: 5.0/255, green: 134.0/255, blue: 255.0/255, alpha: 1)
		} else {
			scheduleLbl.text = ""
			bgViewColor.backgroundColor = UIColor(red: 255.0/255, green: 97.0/255, blue: 5.0/255, alpha: 1)

		}
	}
	
}
