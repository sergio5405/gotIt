//
//  ServiceFormVC.swift
//  gotIt
//
//  Created by Sergio Hernandez Jr on 27/04/18.
//  Copyright © 2018 Sergio Hernandez. All rights reserved.
//

import UIKit
import Eureka

class ServiceFormVC: FormViewController {
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		setupColors()
	}
	
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
	
	func setupColors(){
		UIView.animate(withDuration: 0.3) {
			self.navigationController?.navigationBar.barTintColor = Utilities.UICol.ServiceColor
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
				$0.value = 100.0
				$0.minimumValue = 100
				$0.maximumValue = 10000
				$0.steps = 1000
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
				row.steps = 1000
				row.validationOptions = .validatesOnChange
				}
				.cellUpdate { cell, row in
					if !row.isValid {
						cell.titleLabel?.textColor = .red
					}
			}
			
			+++ MultivaluedSection(multivaluedOptions: [.Reorder, .Insert, .Delete], header: "Imágenes", footer: "Toca el botón para agregar más fotos") {
				$0.tag = "imgsTag"
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
			<<< LocationRowService(){
				$0.title = "Ubicación del servicio"
				$0.add(rule: RuleRequired(msg: "Es necesario especificar el rango del producto"))
			}
			+++ Section("Horario de servicio")
			
			<<< WeekDayRow(){
				$0.value = []
			}
			<<< TimeRow(){
				$0.title = "Hora inicial"
//				$0.minimumDate
			}
			<<< TimeRow(){
				$0.title = "Hora final"
				//				$0.minimumDate
			}
			+++ Section("")
			<<< ButtonRow(){
				$0.title = "Agregar producto"
				$0.onCellSelection({ (btnCell, btnRow) in
					//Mandar todo el form alv a Firebase....
					self.form.validate()
					print("vamooosqwsq")
				})
			}
	}
	
	@objc func checkImgs(timer: Timer){
		let section = self.form.sectionBy(tag: "imgsTag") as! MultivaluedSection
		let tag: String = timer.userInfo as! String
		let imgRow = self.form.rowBy(tag: tag) as! ImageRow
		if imgRow.value != nil{
			section.multivaluedOptions = [.Reorder, .Insert, .Delete]
			section.footer?.title = "Toca el botón para agregar más fotos"
			self.form.rowBy(tag: "addButtonTag")?.hidden = false
		}else{
			section.multivaluedOptions = [.Delete]
			section.footer?.title = "Debes agregar la foto a las celdas antes de agregar más"
			self.form.rowBy(tag: "addButtonTag")?.hidden = true
		}
		
		self.form.rowBy(tag: "addButtonTag")?.evaluateHidden()
	}
}
