//
//  FeedFilter.swift
//  gotIt
//
//  Created by Sergio Hernandez Jr on 01/04/18.
//  Copyright © 2018 Sergio Hernandez. All rights reserved.
//

import Foundation
import UIKit

extension FeedVC {
	
	@IBAction func distanceSlider(_ sender: UISlider!) {
		self.distanceLbl.text = "\(Int(sender.value)) km"
	}
	
	func setupFilterView(){
		self.blurredBackground.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		
		self.filtersView.layer.masksToBounds = false
		self.filtersView.layer.shadowColor = UIColor.black.cgColor
		self.filtersView.layer.cornerRadius = 0
		self.filtersView.layer.shadowRadius = 0
		self.filtersView.layer.shadowOpacity = 1
		self.filtersView.layer.shadowOffset = CGSize.zero
	}
	
	func animate(keypath: String, from: Double, to: Double, duration: Double) {
		let animation = CABasicAnimation(keyPath: keypath)
		animation.fromValue = from
		animation.toValue = to
		animation.duration = duration
		self.filtersView.layer.add(animation, forKey: animation.keyPath)
	}
	
	@IBAction func showFilters(_ sender: Any) {
		if self.filterOptions[0].isHidden{
			self.blurredBackground.frame = CGRect(origin: CGPoint.zero, size: self.productTableView.contentSize)
			self.view.bringSubview(toFront: self.filtersView)
		}
		
		self.filterOptions.forEach { (btn) in
			UIView.animate(withDuration: 0.5, animations: {
				btn.isHidden = !btn.isHidden
				btn.alpha = (btn.isHidden) ? 0:1
				self.view.layoutIfNeeded()
			})
		}
		
		if self.filterOptions[0].isHidden{
			self.productTableView.isUserInteractionEnabled = true
			
			UIView.animate(withDuration: 0.5, animations: {
				self.blurredBackground.effect = nil
			}, completion: { (success) in
				self.blurredBackground.removeFromSuperview()
			})
			
			animate(keypath: "cornerRadius", from: 15, to: 0, duration: 0.5)
			self.filtersView.layer.cornerRadius = 0
			
			animate(keypath: "shadowRadius", from: 20, to: 0, duration: 0.5)
			self.filtersView.layer.shadowRadius = 0
		}else{
			self.productTableView.isUserInteractionEnabled = false
			self.productTableView.addSubview(self.blurredBackground)
			UIView.animate(withDuration: 0.5) {
				self.blurredBackground.effect = UIBlurEffect(style: .light)
			}
			
			animate(keypath: "cornerRadius", from: 0, to: 15, duration: 0.5)
			self.filtersView.layer.cornerRadius = 15
			
			animate(keypath: "shadowRadius", from: 0, to: 20, duration: 0.5)
			self.filtersView.layer.shadowRadius = 20
		}
		
	}
}

