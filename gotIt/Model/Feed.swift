//
//  Feed.swift
//  gotIt
//
//  Created by Sergio Hernandez Jr on 04/04/18.
//  Copyright © 2018 Sergio Hernandez. All rights reserved.
//

import UIKit
import FirebaseFirestore
import GoogleMaps
import AlamofireImage
import Alamofire
class Feed{
	struct ImageLocation {
		var offerId: String
		var imageIdx: Int
		init(offerId: String, imageIdx: Int) {
			self.offerId = offerId
			self.imageIdx = imageIdx
		}
	}
	
	struct Global {
		static var offers = [String:Offer]()
		
		static func downloadFeed(/*Filters*/) {
			
			let db = Firestore.firestore()
			let settings = db.settings
			settings.areTimestampsInSnapshotsEnabled = true
			db.settings = settings

			var arrOffers = [String:Offer]()
			var hmImageLocation = [String:ImageLocation]()

			db.collection("feed").whereField("active", isEqualTo: true).addSnapshotListener { (feedSnap, err) in
				guard let document = feedSnap else {
					print("Error fetching document: \(err!)")
					self.offers = arrOffers
					NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showFeed"), object: nil, userInfo: nil)
					return
				}
				for doc in document.documents {
					let documentDic = doc.data()
					let id = doc.documentID

					let title = documentDic["title"] as! String
					let offerType = documentDic["type"] as! String
					let description = documentDic["description"] as! String
					let prices = documentDic["price"] as! [String:Double]
					let minPrice = prices["min"]
					let maxPrice = prices["max"]
					let user = documentDic["user"] as! String
					let location = documentDic["location"] as! GeoPoint
					let email = documentDic["email"] as! String
 					if offerType == "Product"{
						arrOffers[id] = Product(title: title, description: description, price: (minPrice!, maxPrice!), latitude: location.latitude, longitude: location.longitude, distanceTo: 1.53, user: user, email: email)
					}else{
						let dateFormatter = DateFormatter()
						dateFormatter.dateFormat = "HH:mm"
						dateFormatter.timeZone = TimeZone(abbreviation: "CST")

						let dateDic = documentDic["schedule"] as! [String: String]
						let minDateStr = dateDic["min"]!
						let maxDateStr = dateDic["max"]!

						let minDate = dateFormatter.date(from: minDateStr)!
						let maxDate = dateFormatter.date(from: maxDateStr)!

						arrOffers[id] = Service(title: title, description: description, price: (minPrice!, maxPrice!), latitude: location.latitude, longitude: location.longitude, distanceRadius: 1.424, distanceTo: 1.213, schedule: (minDate, maxDate), user: user, email: email)
					}
					
					let urlsImages: [String] = documentDic["images"] as! [String]
					arrOffers[id]?.images = [UIImage]()
					for url in urlsImages{
						arrOffers[id]?.images?.append(#imageLiteral(resourceName: "notFound"))
						hmImageLocation[url] = ImageLocation(offerId: id, imageIdx: (arrOffers[id]?.images?.count)!-1)
					}
					
					for url in urlsImages{
//						if let cached = imageCache.object(forKey: url as AnyObject){
//							let locationImage = hmImageLocation[url]
//							setImage(image: cached, location: locationImage!)
//						}else{
							Alamofire.request(url, method: .get).responseImage { response in
								if let image = response.result.value {
									print(response.request?.url?.absoluteString)
//									imageCache.setObject(image, forKey: (response.request?.url?.absoluteString)! as AnyObject)
									setImage(image: image, location: hmImageLocation[url]!)
								}
							}
//						}
					}
				}
				
				self.offers = arrOffers
				NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showFeed"), object: nil, userInfo: nil)
			}
			
			
			
//			offers = [String:Offer]()
//			let empanadas = Product(title: "Empanadas El Pana", description: "Deliciosas empanadas de nutella, mole, queso filadelfia con mermelada de zarzamora ", price: (25, 30), latitude: 19.575134, longitude: -99.224279, distanceTo: 3.71, user: "SERGIO")
//			var empanadasImg = [UIImage]()
//			empanadasImg.append(#imageLiteral(resourceName: "pana1"))
//			empanadasImg.append(#imageLiteral(resourceName: "pana2"))
//			empanadasImg.append(#imageLiteral(resourceName: "pana3"))
//			empanadas.images = empanadasImg
//			offers["123me13"] = empanadas
//
//
//			let gomitas = Product(title: "Gomitas", description: "Deliciosas gomitas de sabores", price: (10, 25), latitude: 19.575134, longitude: -99.224279, distanceTo: 1.49, user: "SERGIO")
//			var gomitasImg = [UIImage]()
//			gomitasImg.append(#imageLiteral(resourceName: "goma1"))
//			gomitasImg.append(#imageLiteral(resourceName: "goma2"))
//			gomitas.images = gomitasImg
//			offers["wedlw23"] = gomitas
//
//			let df = DateFormatter()
//			df.dateFormat = "HH:mm"
//			let reparaciones = Service(title: "Reparacion de computadoras", description: "Reparamos tu computadora, la hacemos más rápida. Instalamos software libre y de paga", price: (200, 1000), latitude: 19.575134, longitude: -99.224279, distanceRadius: 4, distanceTo: 1.21, schedule: (df.date(from: "12:00")!, df.date(from: "16:00")!), user: "SERGIO")
//			var reparacionesImg = [UIImage]()
//			reparacionesImg.append(#imageLiteral(resourceName: "compu1"))
//			reparacionesImg.append(#imageLiteral(resourceName: "compu2"))
//			reparaciones.images = reparacionesImg
//			offers["32ed223"] = reparaciones
		}
		
		static func setImage(image: UIImage, location: ImageLocation){
			let idOff = location.offerId
			let imgIdx = location.imageIdx
			self.offers[idOff]?.images![imgIdx] = image
			
			NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showFeed"), object: nil, userInfo: nil)
		}
		
		static var imageCache = NSCache<AnyObject, UIImage>()
	}
}
