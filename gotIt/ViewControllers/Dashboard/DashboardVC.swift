//
//  DashboardTVC.swift
//  gotIt
//
//  Created by Sergio Hernandez Jr on 22/04/18.
//  Copyright © 2018 Sergio Hernandez. All rights reserved.
//

import UIKit
import Eureka

class DashboardVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
	@IBOutlet weak var tableView: UITableView!
	
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .default
	}
	
	enum Offer {
		case Products
		case Services
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		setupUIColor()
	}
	func setupUIColor(){
		UIView.animate(withDuration: 0.3) {
			self.navigationController?.navigationBar.barTintColor = .white
			self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.strokeColor: UIColor.black]
			self.navigationController?.navigationBar.layoutIfNeeded()
			UIApplication.shared.statusBarStyle = .default
		}
	}
	
	var offerSelected = Offer.Products
	
	@IBAction func addOffer(_ sender: Any) {
		var controller: FormViewController
		if offerSelected == Offer.Products {
			controller = self.storyboard?.instantiateViewController(withIdentifier: "productFormViewController") as! FormViewController
		}else{
			controller = self.storyboard?.instantiateViewController(withIdentifier: "serviceFormViewController") as! FormViewController
		}
		
		
		self.navigationController?.show(controller, sender: nil)
	}
	
	@IBAction func offerAction(_ sender: UISegmentedControl) {
		if offerSelected == Offer.Products {
			offerSelected = Offer.Services
			sender.tintColor = Utilities.UICol.ServiceColor
			navigationItem.rightBarButtonItem?.tintColor = Utilities.UICol.ServiceColor
		}else{
			offerSelected = Offer.Products
			sender.tintColor = Utilities.UICol.ProductColor
			navigationItem.rightBarButtonItem?.tintColor = Utilities.UICol.ProductColor
		}
		self.tableView.reloadData()
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if offerSelected == Offer.Products {
			return Dashboard.Global.myProducts.count
		}
		return Dashboard.Global.myServices.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var cell = tableView.dequeueReusableCell(withIdentifier: "OfferCell") as! DashboardTVCell
		
		if offerSelected == Offer.Products {
			cell.state = Offer.Products
			cell.myOffer = Dashboard.Global.myProducts[indexPath.row]
		}else{
			cell.state = Offer.Services
			cell.myOffer = Dashboard.Global.myServices[indexPath.row]
		}
		
		return cell
	}
	
//	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//		if editingStyle == .delete {
//			//Firebase deletion
//		}
//	}
	
	func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
		
		let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
			//Firebase deletion
		}
		
		let edit = UITableViewRowAction(style: .default, title: "Edit") { (action, indexPath) in
			//Call edit Add VC with info
		}
		
		edit.backgroundColor = UIColor.lightGray
		
		return [delete, edit]
		
	}
	

    override func viewDidLoad() {
        super.viewDidLoad()
		
		Dashboard.Global.downloadMyDashboard()
		

        // Do any additional setup after loading the view.
    }
}
