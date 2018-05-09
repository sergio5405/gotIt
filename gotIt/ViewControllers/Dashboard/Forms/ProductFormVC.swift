//
//  ProductFormVC.swift
//  gotIt
//
//  Created by Sergio Hernandez Jr on 27/04/18.
//  Copyright © 2018 Sergio Hernandez. All rights reserved.
//

import UIKit
import Foundation
import Eureka
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

class ProductFormVC: FormViewController {
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		setupColors()
	}

	func setupColors(){
		UIView.animate(withDuration: 0.3) {
			self.navigationController?.navigationBar.barTintColor = Utilities.UICol.ProductColor
			self.navigationController?.navigationBar.tintColor = .white
			self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
			UIApplication.shared.statusBarStyle = .lightContent
			self.navigationController?.navigationBar.layoutIfNeeded()
		}
	}
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		form +++ Section("Datos principales")
			<<< TextRow(){ row in
				row.title = "Título"
				row.tag = "title"
				row.placeholder = "Inserte título"
				row.add(rule: RuleRequired(msg: "Es necesario insertar un título corto"))
				row.add(rule: RuleMaxLength(maxLength: 20))
				row.validationOptions = .validatesOnBlur
				}.cellUpdate { cell, row in
					if !row.isValid {
						cell.titleLabel?.textColor = .red
					}
			}
			<<< TextRow(){ row in
				row.title = "Descripción"
				row.tag = "description"
				row.placeholder = "Inserte descripción"
				row.add(rule: RuleRequired(msg: "Es necesario insertar una descripción"))
				row.add(rule: RuleMaxLength(maxLength: 50))
				row.validationOptions = .validatesOnBlur
				}.cellUpdate { cell, row in
					if !row.isValid {
						cell.titleLabel?.textColor = .red
					}
			}
			+++ Section("Rango de precios")
			<<< SliderRow(){
				$0.title = "Precio mínimo"
				$0.tag = "minPrice"
				$0.value = 100.0
				$0.minimumValue = 100
				$0.maximumValue = 10000
				$0.steps = 9
				$0.validationOptions = .validatesOnChange
				}
				.cellUpdate { cell, row in
					let rowMax: SliderRow? = self.form.rowBy(tag: "maxPrice")
					let maxValue = rowMax?.value
					rowMax?.removeAllRules()
					rowMax?.add(rule: RuleGreaterThan(min: row.value ?? 100, msg: "El precio máximo debe ser mayor"))
					rowMax?.validate()
			}
			
			<<< SliderRow(){ row in
				row.title = "Precio máximo"
				row.tag = "maxPrice"
				row.value = 200.0
				row.minimumValue = 100
				row.maximumValue = 10000
				row.steps = 9
				row.validationOptions = .validatesOnChange
				}
				.cellUpdate { cell, row in
					if !row.isValid {
						cell.titleLabel?.textColor = .red
					}
			}
			
			+++ MultivaluedSection(multivaluedOptions: [.Reorder, .Insert, .Delete], header: "Imágenes", footer: "Toca el botón para agregar más fotos") {
				$0.tag = "images"
				$0.addButtonProvider = { section in
					return ButtonRow(){
						$0.tag = "addButtonTag"
						$0.title = "Agregar nueva foto"
					}
				}
				
				$0.multivaluedRowToInsertAt = { index in
					return ImageRow(){
						$0.title = "Imagen \(index + 1)"
						$0.tag = "imagen\(index)"
						
						$0.cellUpdate({ (pushSele, imgRow) in
							Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.checkImgs), userInfo: imgRow.tag, repeats: false)
						})
					}
				}
			}
			
			+++ Section("Rango de venta")
			<<< LocationRowProduct(){
				$0.title = "Ubicación del servicio"
				$0.tag = "location"
				$0.add(rule: RuleRequired(msg: "Es necesario especificar el rango del producto"))
			}
			+++ Section("")
			<<< ButtonRow(){
				$0.title = "Agregar producto"
				$0.onCellSelection({ (btnCell, btnRow) in
					//Mandar todo el form alv a Firebase....
					let error =  self.form.validate()
					if error.count > 0{
						print("hay errores")
						return
					}
					
					guard let imgs = self.form.sectionBy(tag: "images") else {
						print("hay errores")
						return
					}
					
					if imgs.count <= 0 {
						print("hay errores")
						return
					}
					
					print(self.form.values())
//					let description = (self.form.rowBy(tag: "description")?.baseValue as! LocationRowProduct).
					print("vamooosqwsq")
					
					let db = Firestore.firestore()
					let settings = db.settings
					settings.areTimestampsInSnapshotsEnabled = true
					db.settings = settings
					
					let user = Auth.auth().currentUser?.uid
					let type = "Product"
					let title = self.form.rowBy(tag: "title")?.baseValue as! String
//					let description = self.form.rowBy(tag: "description")?.baseValue as! String
					let priceMin = Int(self.form.rowBy(tag: "minPrice")?.baseValue as! Float)
					let priceMax = Int(self.form.rowBy(tag: "maxPrice")?.baseValue as! Float)
					let price  = ["min": priceMin, "max": priceMax]
//					let ubicacion =
					
					
//					db.collection("feed").addDocument(data: <#T##[String : Any]#>, completion: { (error) in
//						if error != nil{
//							return
//						}
//					})
					
				})
			}
	}
	
	func uploadImage(row: ImageRow){
//		let section = self.form.sectionBy(tag: "images") as! MultivaluedSection
//		let imgRow = self.form.rowBy(tag: row.tag!) as! ImageRow
//
//		let storageRef = Storage.storage().reference()
//		let id = Firestore.firestore().collection("feed").document().documentID
//		Firestore.firestore().collection("feed").document(id).delete()
//		let imageRef = storageRef.child("images/\(id)")
//		let metadata = StorageMetadata()
//		metadata.contentType = "image/jpeg"
//		let data = UIImageJPEGRepresentation(imgRow.value!, 0.5)
//
//		imageRef.putData(data!, metadata: metadata) { (storMeta, error) in
//			storageRef.downloadURL(completion: { (url, error) in
//				if error != nil{
//					return
//				}
//				if let finalURL = url{
//					imgRow.imageURL = finalURL
//				}
//			})
//		}
	}
	
	@objc func checkImgs(timer: Timer){
		let section = self.form.sectionBy(tag: "images") as! MultivaluedSection
		let secValues = section.values()
		if (section.values().count - 1) < 0 {
			return
		}
		for i in (0...section.values().count-1).reversed(){
			if secValues[i] == nil{
				section.remove(at: i)
			}
		}
		
//		if (self.form.sectionBy(tag: "images")?.count)! <= 0 {
//			section.multivaluedOptions = [.Reorder, .Insert, .Delete]
//			section.footer?.title = "Toca el botón para agregar más fotos"
//			self.form.rowBy(tag: "addButtonTag")?.hidden = false
//		}else{
//			section.multivaluedOptions = [.Delete]
//			section.footer?.title = "Debes agregar la foto a las celdas antes de agregar más"
//			self.form.rowBy(tag: "addButtonTag")?.hidden = true
//		}
//		if imgRow.value != nil{
//			section.multivaluedOptions = [.Reorder, .Insert, .Delete]
//			section.footer?.title = "Toca el botón para agregar más fotos"
//			self.form.rowBy(tag: "addButtonTag")?.hidden = false
//
//			let storageRef = Storage.storage().reference()
//			let id = Firestore.firestore().collection("feed").document().documentID
//			Firestore.firestore().collection("feed").document(id).delete()
//			let imageRef = storageRef.child("images/\(id)")
//			let metadata = StorageMetadata()
//			metadata.contentType = "image/jpeg"
//			let data = UIImageJPEGRepresentation(imgRow.value!, 0.8)
//
//			imageRef.putData(data!, metadata: metadata) { (storMeta, error) in
//				storageRef.downloadURL(completion: { (url, error) in
//					if error != nil{
//						return
//					}
//					if let finalURL = url{
//						imgRow.imageURL = finalURL
//					}
//				})
//			}
//		}else{
//			section.multivaluedOptions = [.Delete]
//			section.footer?.title = "Debes agregar la foto a las celdas antes de agregar más"
//			self.form.rowBy(tag: "addButtonTag")?.hidden = true
//		}
		
		self.form.rowBy(tag: "addButtonTag")?.evaluateHidden()
	}
}
