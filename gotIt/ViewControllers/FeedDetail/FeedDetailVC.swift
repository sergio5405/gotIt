//
//  FeedDetailVC
//  gotIt
//
//  Created by Sergio Hernandez Jr on 25/04/18.
//  Copyright © 2018 Sergio Hernandez. All rights reserved.
//

import UIKit
import FirebaseFirestore
import Firebase
import GoogleMaps
import MessageUI

class FeedDetailVC: UIViewController, MFMailComposeViewControllerDelegate{
    var offer: Offer!
    var cantidad : UInt = 1
	let locationManager = CLLocationManager()
    
	@IBOutlet weak var map: GMSMapView!
    @IBOutlet weak var offerTitleLbl: UILabel!
    @IBOutlet weak var offerDescrLbl: UILabel!
	@IBOutlet weak var offerPriceLbl: UILabel!
	@IBOutlet weak var offerImagesHeaderView: FeedDetailOfferHeaderV!
    
	@IBAction func btnContactAction(_ sender: UIButton) {
		if !MFMailComposeViewController.canSendMail() {
			print("Mail services are not available")
			return
		}
		
		sendEmail()
	}
	
	func sendEmail() {
		let composeVC = MFMailComposeViewController()
		composeVC.mailComposeDelegate = self
		// Configure the fields of the interface.
		composeVC.setToRecipients([self.offer.email])
		composeVC.setSubject("Un usuario está interesado en \(self.offer.title)")
		// Present the view controller modally.
		self.present(composeVC, animated: true, completion: nil)
	}
	
	func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
		controller.dismiss(animated: true, completion: nil)
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
		setupUI()
		setupMap()
    }
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		setupColors()
	}
	
	func setupColors(){
		UIView.animate(withDuration: 0.3) {
			if (self.offer as? Service) != nil{
				self.navigationController?.navigationBar.barTintColor = Utilities.UICol.ServiceColor
			}else{
				self.navigationController?.navigationBar.barTintColor = Utilities.UICol.ProductColor
			}
			self.navigationController?.navigationBar.tintColor = .white
			self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
			self.navigationController?.navigationBar.layoutIfNeeded()
			UIApplication.shared.statusBarStyle = .lightContent
		}
	}
	
	func setupMap(){
		map.isMyLocationEnabled = true
		map.settings.scrollGestures = false
		map.settings.zoomGestures = false
		
		locationManager.delegate = self
		locationManager.startUpdatingLocation()
		
		self.map.animate(to: GMSCameraPosition.camera(withLatitude: offer.latitude, longitude: offer.longitude, zoom: 12))
		let position = CLLocationCoordinate2D(latitude: offer.latitude, longitude: offer.longitude)
		
		if let offerService = offer as? Service{
			let range = GMSCircle(position: position, radius: offerService.distanceRadius*1000)
			range.title = offerService.title
			range.fillColor = Utilities.UICol.ServiceColor.withAlphaComponent(0.3)
			range.strokeColor = Utilities.UICol.ServiceColor
			range.map = self.map
		}else{
			let marker = GMSMarker(position: position)
			marker.icon = GMSMarker.markerImage(with: Utilities.UICol.ProductColor)
			marker.title = offer.title
			marker.map = self.map
		}
	}
	
	func setupUI(){
		self.title = offer.title
		self.offerTitleLbl.text = offer.title.uppercased()
		self.offerDescrLbl.text = offer.description
		self.offerPriceLbl.text = String(format: "Precios $%.02f - $%.02f", locale: Locale.current, arguments: [offer.price.0, offer.price.1])
	}
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showImagesPageSegue" {
            if let imagesPageVC = segue.destination as? FeedDetailOfferImagePVC {
                imagesPageVC.imagenes = offer.images
                imagesPageVC.pageViewControllerDelegate = offerImagesHeaderView
            }
        }
    }
}

extension FeedDetailVC: CLLocationManagerDelegate {
	func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
		if status == .authorizedWhenInUse {
			self.locationManager.startUpdatingLocation()
			self.map.isMyLocationEnabled = true
			self.map.settings.myLocationButton = true
		}
	}
	
	func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		if let location = locations.first {
			self.map.camera = GMSCameraPosition(target: location.coordinate, zoom: 20, bearing: 0, viewingAngle: 0)
			locationManager.stopUpdatingLocation()
		}
	}
}
