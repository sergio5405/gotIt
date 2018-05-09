//
//  FeedVC
//  gotIt
//
//  Created by Sergio Hernandez Jr on 01/04/18.
//  Copyright © 2018 Sergio Hernandez. All rights reserved.
//

import UIKit
import GoogleSignIn
import FBSDKLoginKit
import FirebaseAuth

class FeedVC: UIViewController{
	@IBOutlet weak var aboutBtn: UIButton!
	@IBOutlet weak var filtersView: UIView!
	@IBOutlet var filterOptions: [UIView]!
    @IBOutlet weak var distanceLbl: UILabel!
	@IBOutlet weak var productTableView: UITableView!
	
    let blurredBackground = UIVisualEffectView()
    
	@IBAction func logoutBtn(_ sender: UIBarButtonItem) {
		do {
			try Auth.auth().signOut()
			FBSDKAccessToken.setCurrent(nil)
			GIDSignIn.sharedInstance().disconnect()
		} catch {
			print("error")
		}
		Switcher.updateRootVC()
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		let nombreComp = Auth.auth().currentUser?.displayName!
		if let nombreArr = nombreComp?.components(separatedBy: CharacterSet(charactersIn: " ") ){
			self.title = "Muro de \(nombreArr[0])"
		}else{
			self.title = "Muro"
		}
		
		self.productTableView.delegate = self
		self.productTableView.dataSource = self
		self.productTableView.separatorStyle = .none
		NotificationCenter.default.addObserver(self, selector: #selector(refreshTable), name: NSNotification.Name(rawValue: "showFeed"), object: nil)
		Feed.Global.downloadFeed()
		

//		setupUIColor()
        setupFilterView()
    }
	
	@objc func refreshTable(){
		self.productTableView.reloadData()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		setupUIColor()
	}
	
	func setupUIColor(){
		UIView.animate(withDuration: 0.3) {
			UIApplication.shared.statusBarStyle = .default
			self.navigationController?.navigationBar.barTintColor = .white
			self.navigationController?.navigationBar.tintColor = self.view.tintColor
			self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.strokeColor: UIColor.black]
			self.navigationController?.navigationBar.layoutIfNeeded()
		}
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "showFeedDetailSegue" {
			if let feedDetailTVC = segue.destination as? FeedDetailVC {
				let selectedOffer = Feed.Global.offers[sender as! String]
				feedDetailTVC.offer = selectedOffer
			}
		}
	}
}

extension FeedVC: UITableViewDelegate, UITableViewDataSource{
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
}

