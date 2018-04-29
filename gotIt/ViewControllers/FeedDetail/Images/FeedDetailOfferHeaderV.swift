//
//  FeedDetailOfferHeaderV.swift
//  gotIt
//
//  Created by Sergio Hernandez Jr on 05/03/18.
//  Copyright © 2018 Sergio Hernandez. All rights reserved.
//

import UIKit

class FeedDetailOfferHeaderV: UIView, FeedDetailOfferImagePVCDelegate {
    func setupPageController(numberOfPages: Int) {
        pageControl.numberOfPages = numberOfPages
    }
    
    func turnPageController(to index: Int) {
        pageControl.currentPage = index
    }
    
    @IBOutlet weak var pageControl : UIPageControl!
    
    
}
