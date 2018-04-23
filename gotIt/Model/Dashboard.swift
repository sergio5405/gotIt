//
//  Dashboard.swift
//  gotIt
//
//  Created by Sergio Hernandez Jr on 22/04/18.
//  Copyright © 2018 Sergio Hernandez. All rights reserved.
//

import Foundation
import UIKit


class Dashboard{
	struct Global {
		static var myProducts = [MyOffer]()
		static var myServices = [MyOffer]()
		
		static func downloadMyDashboard(/*Filters*/) {
			myProducts = [MyOffer]()
			
			let empanadas = Product(title: "Empanadas El Pana", description: "Deliciosas empanadas de nutella, mole, queso filadelfia con mermelada de zarzamora ", price: (25, 30), longitude: 19.14, latitude: 19.14, distanceTo: 3.71)
			var empanadasImg = [UIImage]()
			empanadasImg.append(#imageLiteral(resourceName: "pana1"))
			empanadasImg.append(#imageLiteral(resourceName: "pana2"))
			empanadasImg.append(#imageLiteral(resourceName: "pana3"))
			empanadas.images = empanadasImg
			let myOfferEmpanadas  = MyOffer(with: empanadas, active: true)
			myProducts.append(myOfferEmpanadas)
			
			
			let df = DateFormatter()
			df.dateFormat = "HH:mm"
			let reparaciones = Service(title: "Reparacion de computadoras", description: "Deliciosas gomitas de sabores", price: (200, 1000), longitude: 19.14, latitude: 19.14, distanceRadius: 4, distanceTo: 1.21, schedule: (df.date(from: "12:00")!, df.date(from: "16:00")!))
			var reparacionesImg = [UIImage]()
			reparacionesImg.append(#imageLiteral(resourceName: "compu1"))
			reparacionesImg.append(#imageLiteral(resourceName: "compu2"))
			reparaciones.images = reparacionesImg
			let myOfferReparaciones  = MyOffer(with: reparaciones, active: true)
			myServices.append(myOfferReparaciones)
			
//			NotificationCenter.default.post(name: NSNotification.Name(rawValue: "cargarObentosMenu"), object: nil, userInfo: nil)
		}
		
		static var imagenCache = NSCache<AnyObject, UIImage>()
	}
}
