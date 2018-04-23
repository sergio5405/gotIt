//
//  MyOffer.swift
//  gotIt
//
//  Created by Sergio Hernandez Jr on 22/04/18.
//  Copyright © 2018 Sergio Hernandez. All rights reserved.
//

import UIKit

class MyOffer {
	var offer: Offer
	var active: Bool
	
	
	init(with offer: Offer, active: Bool){
		self.offer = offer
		self.active = active
	}
}
