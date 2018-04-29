//
//  FeedVC
//  gotIt
//
//  Created by Sergio Hernandez Jr on 01/04/18.
//  Copyright © 2018 Sergio Hernandez. All rights reserved.
//

import UIKit

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let idOffer = Array(Feed.Global.offers.keys)[indexPath.row]
	
		print("didSelectRowAt \(idOffer)")
		self.performSegue(withIdentifier: "showFeedDetailSegue", sender: idOffer)
	}
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return Feed.Global.offers.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = productTableView.dequeueReusableCell(withIdentifier: "feedTVCell", for: indexPath) as! FeedTVCell
		cell.offer = Array(Feed.Global.offers.values)[indexPath.row]
		cell.selectionStyle = .none
		
		return cell
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "showFeedDetailSegue" {
			if let feedDetailTVC = segue.destination as? FeedDetailVC {
				let selectedOffer = Feed.Global.offers[sender as! String]
				feedDetailTVC.offer = selectedOffer
			}
		}
	}
	
    @IBOutlet weak var filtersView: UIView!
	@IBOutlet var filterOptions: [UIView]!
    @IBOutlet weak var distanceLbl: UILabel!
	@IBOutlet weak var productTableView: UITableView!
	
    let blurredBackground = UIVisualEffectView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
		self.productTableView.delegate = self
		self.productTableView.dataSource = self
		self.productTableView.separatorStyle = .none
		Feed.Global.downloadFeed()
		self.productTableView.reloadData()
		
        setupFilterView()
    }
}

