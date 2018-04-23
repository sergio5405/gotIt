//
//  DashboardTVCell.swift
//  gotIt
//
//  Created by Sergio Hernandez Jr on 23/04/18.
//  Copyright © 2018 Sergio Hernandez. All rights reserved.
//

import UIKit

class DashboardTVCell: UITableViewCell {
	@IBOutlet weak var cellImgView: UIImageView!
	@IBOutlet weak var titleLbl: UILabel!
	@IBOutlet weak var priceLbl: UILabel!
	@IBOutlet weak var scheduleLbl: UILabel!
	@IBOutlet weak var activeSwitch: UISwitch!
	@IBOutlet weak var parentView: DashboardVC!
	@IBAction func myOfferActiveChange(_ sender: UISwitch) {
		updateUI()
	}
	
	var myOffer: MyOffer! {
		didSet {
			self.setUI()
		}
	}
	
	var state: DashboardVC.Offer!
		
	func setUI(){
		let offer = myOffer.offer
		updateUI()
		
		if state == DashboardVC.Offer.Products {
			titleLbl.textColor = Utilities.UICol.ProductColor
			priceLbl.textColor = Utilities.UICol.ProductColor
			scheduleLbl.textColor = Utilities.UICol.ProductColor
		}else{
			titleLbl.textColor = Utilities.UICol.ServiceColor
			priceLbl.textColor = Utilities.UICol.ServiceColor
			scheduleLbl.textColor = Utilities.UICol.ServiceColor
		}
		
		cellImgView.image = offer.images?.first
		titleLbl.text = offer.title
		priceLbl.text = String(format: "$%.02f - $%.02f", locale: Locale.current, arguments: [offer.price.0, offer.price.1])
		var scheduleTxt = ""
		
		if let serviceOffer = offer as? Service{
			let calendar = Calendar.current
			let beginTime = calendar.dateComponents([.hour, .minute], from: serviceOffer.schedule.0)
			let beginH = beginTime.hour
			let beginM = beginTime.minute
			let endTime = calendar.dateComponents([.hour, .minute], from: serviceOffer.schedule.1)
			let endH = endTime.hour
			let endM = endTime.minute
			scheduleTxt = String(format: "%d:%02d - %d:%02d", locale: Locale.current, arguments: [beginH!, beginM!, endH!, endM!])
		}
		
		scheduleLbl.text = scheduleTxt
	}
	
	func updateUI(){
		myOffer.active = activeSwitch.isOn
	}
	
}
