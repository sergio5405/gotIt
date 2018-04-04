//
//  Feed.swift
//  gotIt
//
//  Created by Sergio Hernandez Jr on 04/04/18.
//  Copyright © 2018 Sergio Hernandez. All rights reserved.
//

import UIKit

class Feed{
	struct Global {
		static var offers = [Offer]()
		
		static func downloadFeed(/*Filters*/) {
			offers = [Offer]()
			let empanadas = Product(title: "Empanadas El Pana", description: "Deliciosas empanadas de nutella, mole, queso filadelfia con mermelada de zarzamora ", price: (25, 30), longitude: 19.14, latitude: 19.14, distanceTo: 3.71)
			var empanadasImg = [UIImage]()
			empanadasImg.append(#imageLiteral(resourceName: "pana1"))
			empanadasImg.append(#imageLiteral(resourceName: "pana2"))
			empanadasImg.append(#imageLiteral(resourceName: "pana3"))
			empanadas.images = empanadasImg
			offers.append(empanadas)


			let gomitas = Product(title: "Gomitas", description: "Deliciosas gomitas de sabores", price: (10, 25), longitude: 19.14, latitude: 19.14, distanceTo: 1.49)
			var gomitasImg = [UIImage]()
			gomitasImg.append(#imageLiteral(resourceName: "goma1"))
			gomitasImg.append(#imageLiteral(resourceName: "goma2"))
			gomitas.images = gomitasImg
			offers.append(gomitas)
			
			let df = DateFormatter()
			df.dateFormat = "HH:mm"
			let reparaciones = Service(title: "Reparacion de computadoras", description: "Deliciosas gomitas de sabores", price: (200, 1000), longitude: 19.14, latitude: 19.14, distanceRadius: 4, distanceTo: 1.21, schedule: (df.date(from: "12:00")!, df.date(from: "16:00")!))
			var reparacionesImg = [UIImage]()
			reparacionesImg.append(#imageLiteral(resourceName: "compu1"))
			reparacionesImg.append(#imageLiteral(resourceName: "compu2"))
			reparaciones.images = reparacionesImg
			offers.append(reparaciones)
			
			NotificationCenter.default.post(name: NSNotification.Name(rawValue: "cargarObentosMenu"), object: nil, userInfo: nil)
		}
		
		static var imagenCache = NSCache<AnyObject, UIImage>()
	}
}
