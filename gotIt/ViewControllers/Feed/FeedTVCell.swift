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
	@IBOutlet weak var imgViewHeight: NSLayoutConstraint!
	
	var offer: Offer! {
		didSet {
			self.updateUI()
		}
	}
	
	func updateUI(){
		cellImgView.image = offer.images?.first
		if let image = offer.images?.first {
			let ratio = image.size.width / image.size.height
			let newHeight = cellImgView.frame.width / ratio
			imgViewHeight.constant = newHeight
		}
		
		distanceLbl.text = String(format: "%.01f km", locale: Locale.current, arguments: [offer.distanceTo])
		titleLbl.text = offer.title
		priceLbl.text = String(format: "$%.02f - $%.02f", locale: Locale.current, arguments: [offer.price.0, offer.price.1])
		configureUIEffects()
		
		if let serviceOffer = offer as? Service{
			let calendar = Calendar.current
			let beginTime = calendar.dateComponents([.hour, .minute], from: serviceOffer.schedule.0)
			let beginH = beginTime.hour
			let beginM = beginTime.minute
			let endTime = calendar.dateComponents([.hour, .minute], from: serviceOffer.schedule.1)
			let endH = endTime.hour
			let endM = endTime.minute
			scheduleLbl.text = String(format: "%d:%02d - %d:%02d", locale: Locale.current, arguments: [beginH!, beginM!, endH!, endM!])
			bgViewColor.backgroundColor = Utilities.UICol.ServiceColor
		} else {
			scheduleLbl.text = ""
			bgViewColor.backgroundColor = Utilities.UICol.ProductColor

		}
	}
	
	func configureUIEffects(){
		bgViewColor.layer.masksToBounds = false
		bgViewColor.layer.cornerRadius = 5
		bgViewColor.layer.shadowColor = UIColor.black.cgColor
		bgViewColor.layer.shadowRadius = 10
		bgViewColor.layer.shadowOpacity = 1
		bgViewColor.layer.shadowOffset = CGSize.zero
		
		distanceLbl.backgroundColor = UIColor.clear
		distanceLbl.layer.masksToBounds = false
		distanceLbl.layer.backgroundColor = UIColor(red: 0, green: 123/255, blue: 1, alpha: 1).cgColor
		distanceLbl.layer.cornerRadius = 10
		distanceLbl.layer.shadowColor = UIColor.black.cgColor
		distanceLbl.layer.shadowRadius = 5
		distanceLbl.layer.shadowOpacity = 1
		distanceLbl.layer.shadowOffset = CGSize.zero
		
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		cellImgView.image = nil
	}
	
}
