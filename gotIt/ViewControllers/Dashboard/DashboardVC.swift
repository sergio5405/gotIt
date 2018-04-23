//
//  DashboardTVC.swift
//  gotIt
//
//  Created by Sergio Hernandez Jr on 22/04/18.
//  Copyright © 2018 Sergio Hernandez. All rights reserved.
//

import UIKit

class DashboardVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
	@IBOutlet weak var tableView: UITableView!
	
	enum Offer {
		case Products
		case Services
	}
	
	var offerSelected = Offer.Products
	
	@IBAction func offerAction(_ sender: UISegmentedControl) {
		if offerSelected == Offer.Products {
			offerSelected = Offer.Services
			sender.tintColor = Utilities.UICol.ServiceColor
		}else{
			offerSelected = Offer.Products
			sender.tintColor = Utilities.UICol.ProductColor
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
	

    override func viewDidLoad() {
        super.viewDidLoad()
		
		Dashboard.Global.downloadMyDashboard()
		

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
