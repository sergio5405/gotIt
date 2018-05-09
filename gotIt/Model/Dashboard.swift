//
//  Dashboard.swift
//  gotIt
//
//  Created by Sergio Hernandez Jr on 22/04/18.
//  Copyright © 2018 Sergio Hernandez. All rights reserved.
//

import Foundation
import UIKit
import FirebaseFirestore
import AlamofireImage
import Alamofire
import FirebaseAuth

class Dashboard{
	struct Global {
		static var myProducts = [String:MyOffer]()
		static var myServices = [String:MyOffer]()
		
		static func downloadMyDashboard(/*Filters*/) {
			
			let db = Firestore.firestore()
			let settings = db.settings
			settings.areTimestampsInSnapshotsEnabled = true
			db.settings = settings
			
			var arrProducts = [String:MyOffer]()
			var arrServices = [String:MyOffer]()
			var hmImageLocation = [String:Feed.ImageLocation]()
			
			guard let user = Auth.auth().currentUser?.uid else{
				self.myProducts = arrProducts
				self.myServices = arrServices
				return
			}
			
			db.collection("feed").whereField("user", isEqualTo: user).addSnapshotListener { (feedSnap, err) in
				guard let document = feedSnap else {
					print("Error fetching document: \(err!)")
					self.myProducts = arrProducts
					self.myServices = arrServices
					NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showDashboard"), object: nil, userInfo: nil)
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
					let active = documentDic["active"] as! Bool
					let email = documentDic["email"] as! String
					let state: DashboardVC.Offer
					let product: Offer!
					if offerType == "Product"{
						state = .Products
						product = Product(title: title, description: description, price: (minPrice!, maxPrice!), latitude: location.latitude, longitude: location.longitude, distanceTo: 1.53, user: user, email: email)
						arrProducts[id] = MyOffer(with: product, active: active)
					}else{
						state = .Services
						let dateFormatter = DateFormatter()
						dateFormatter.dateFormat = "HH:mm"
						dateFormatter.timeZone = TimeZone(abbreviation: "CST")
						
						let dateDic = documentDic["schedule"] as! [String: String]
						let minDateStr = dateDic["min"]!
						let maxDateStr = dateDic["max"]!
						
						let minDate = dateFormatter.date(from: minDateStr)!
						let maxDate = dateFormatter.date(from: maxDateStr)!
						
						product = Service(title: title, description: description, price: (minPrice!, maxPrice!), latitude: location.latitude, longitude: location.longitude, distanceRadius: 1.424, distanceTo: 1.213, schedule: (minDate, maxDate), user: user, email: email)
						arrServices[id] = MyOffer(with: product, active: active)
					}
					
					print(product.title)
					
					let urlsImages: [String] = documentDic["images"] as! [String]
					
					var images = [UIImage]()
					for url in urlsImages{
						images.append(#imageLiteral(resourceName: "notFound"))
						hmImageLocation[url] = Feed.ImageLocation(offerId: id, imageIdx: images.count-1)
					}
					
					if state == .Products{
						arrProducts[id]?.offer.images = images
					}else{
						arrServices[id]?.offer.images = images
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
				
				self.myServices = arrServices
				self.myProducts = arrProducts
				NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showDashboard"), object: nil, userInfo: nil)
			}
		}
		
//		static func downloadMyDashboard(/*Filters*/) {
//			myProducts = [MyOffer]()
//
//			let empanadas = Product(title: "Empanadas El Pana", description: "Deliciosas empanadas de nutella, mole, queso filadelfia con mermelada de zarzamora ", price: (25, 30), latitude: 19.14, longitude: 19.14, distanceTo: 3.71, user: "SERGIO")
//			var empanadasImg = [UIImage]()
//			empanadasImg.append(#imageLiteral(resourceName: "pana1"))
//			empanadasImg.append(#imageLiteral(resourceName: "pana2"))
//			empanadasImg.append(#imageLiteral(resourceName: "pana3"))
//			empanadas.images = empanadasImg
//			let myOfferEmpanadas  = MyOffer(with: empanadas, active: true)
//			myProducts.append(myOfferEmpanadas)
//
//
//			let df = DateFormatter()
//			df.dateFormat = "HH:mm"
//			let reparaciones = Service(title: "Reparacion de computadoras", description: "Deliciosas gomitas de sabores", price: (200, 1000), latitude: 19.14, longitude: 19.14, distanceRadius: 4, distanceTo: 1.21, schedule: (df.date(from: "12:00")!, df.date(from: "16:00")!), user: "SERGIO")
//			var reparacionesImg = [UIImage]()
//			reparacionesImg.append(#imageLiteral(resourceName: "compu1"))
//			reparacionesImg.append(#imageLiteral(resourceName: "compu2"))
//			reparaciones.images = reparacionesImg
//			let myOfferReparaciones  = MyOffer(with: reparaciones, active: true)
//			myServices.append(myOfferReparaciones)
//
//			NotificationCenter.default.post(name: NSNotification.Name(rawValue: "cargarObentosMenu"), object: nil, userInfo: nil)
//		}
		
		static func setImage(image: UIImage, location: Feed.ImageLocation){
			let idOff = location.offerId
			let imgIdx = location.imageIdx
			
			if self.myProducts[idOff]?.offer.images![imgIdx] != nil {
				self.myProducts[idOff]?.offer.images![imgIdx] = image
			}else{
				self.myServices[idOff]?.offer.images![imgIdx] = image
			}
			
			NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showDashboard"), object: nil, userInfo: nil)
		}
		
		static var imagenCache = NSCache<AnyObject, UIImage>()
	}
}
