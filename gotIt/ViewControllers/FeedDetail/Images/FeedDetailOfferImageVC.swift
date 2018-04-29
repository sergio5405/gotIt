//
//  FeedDetailOfferImageVC.swift
//  gotIt
//
//  Created by Sergio Hernandez Jr on 04/03/18.
//  Copyright © 2018 Sergio Hernandez. All rights reserved.
//

import UIKit

class FeedDetailOfferImageVC: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    
    var imagen: UIImage?{
        didSet{
            self.imageView?.image = imagen
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.imageView.image = imagen
    }
}
