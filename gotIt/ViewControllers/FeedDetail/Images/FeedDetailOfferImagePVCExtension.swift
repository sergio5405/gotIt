//
//  FeedDetailOfferImagePVCExtension.swift
//  gotIt
//
//  Created by Sergio Hernandez Jr on 04/03/18.
//  Copyright © 2018 Sergio Hernandez. All rights reserved.
//

import UIKit

extension FeedDetailOfferImagePVC {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let index = controllers.index(of: viewController) {
            if index > 0 {
                return controllers[index-1]
            }
        }
        
        return controllers.last
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let index = controllers.index(of: viewController) {
            if index < controllers.count - 1 {
                return controllers[index + 1]
            }
        }
        
        return controllers.first
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        self.configurarVista(viewController: pendingViewControllers.first as! FeedDetailOfferImageVC)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if !completed {
            self.configurarVista(viewController: previousViewControllers.first as! FeedDetailOfferImageVC)
        }
    }
    
}
