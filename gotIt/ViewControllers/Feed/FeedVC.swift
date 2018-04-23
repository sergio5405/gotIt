//
//  FeedVC
//  gotIt
//
//  Created by Sergio Hernandez Jr on 01/04/18.
//  Copyright © 2018 Sergio Hernandez. All rights reserved.
//

import UIKit

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return Feed.Global.offers.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = productTableView.dequeueReusableCell(withIdentifier: "feedTVCell", for: indexPath) as! FeedTVCell
		cell.offer = Feed.Global.offers[indexPath.row]
		cell.selectionStyle = .none
		
		return cell
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
//		self.productTableView.
		Feed.Global.downloadFeed()
		self.productTableView.reloadData()
		
		
        setupFilterView()
    }
	

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
//	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//		return 10
//	}

}

