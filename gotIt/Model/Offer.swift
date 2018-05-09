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
	var user: String
	var email: String

	init(title: String, description: String, price: (Double, Double), latitude: Double, longitude: Double, distanceTo: Double, user: String, email: String){
		self.title = title
		self.description = description
		self.price = price
		self.longitude = longitude
		self.latitude = latitude
		self.distanceTo = distanceTo
		self.user = user
		self.email = email
	}
}
