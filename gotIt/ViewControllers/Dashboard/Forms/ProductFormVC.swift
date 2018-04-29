//
//  ProductFormVC.swift
//  gotIt
//
//  Created by Sergio Hernandez Jr on 27/04/18.
//  Copyright © 2018 Sergio Hernandez. All rights reserved.
//

import UIKit
import Eureka
import NHRangeSlider

class ProductFormVC: FormViewController {
	override func viewDidLoad() {
		super.viewDidLoad()
		form +++ Section("Datos principales")
			<<< TextRow(){ row in
				row.title = "Título"
				row.placeholder = "Inserte título"
			}
			<<< TextRow(){ row in
				row.title = "Descripción"
				row.placeholder = "Inserte descripción"
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
		
		+++ MultivaluedSection(multivaluedOptions: [.Reorder, .Insert, .Delete],
			header: "Imágenes",
			footer: "Toca el botón para agregar más fotos") {
			$0.addButtonProvider = { section in
				let rowMax: SliderRow? = self.form.rowBy(tag: "maxPrice")
				return ButtonRow(){
					$0.title = "Agregar nueva foto"
				}
			}
			$0.multivaluedRowToInsertAt = { index in
				return ImageRow() {
					$0.title = ""
				}
			}
			$0 <<< ImageRow() {
				$0.title = "Imagen"
			}
		}
		
	
		
	}
}
