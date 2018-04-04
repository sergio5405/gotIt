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
		return 3
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		return productTableView.dequeueReusableCell(withIdentifier: "feedTVCell", for: indexPath) as! FeedTVCell
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

