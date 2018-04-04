//
//  Offer.swift
//  gotIt
//
//  Created by Sergio Hernandez Jr on 04/04/18.
//  Copyright © 2018 Sergio Hernandez. All rights reserved.
//

import UIKit

class Offer {
	var title: String
	var description: String
	var price: (Double, Double)
	var images: [UIImage]?
	var longitude: Double
	var latitude: Double
	var distanceTo: Double

	init(title: String, description: String, price: (Double, Double), longitude: Double, latitude: Double, distanceTo: Double){
		self.title = title
		self.description = description
		self.price = price
		self.longitude = longitude
		self.latitude = latitude
		self.distanceTo = distanceTo
	}
}
