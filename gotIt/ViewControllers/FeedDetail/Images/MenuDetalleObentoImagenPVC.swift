//
//  MenuDetalleObentoImagenPVC.swift
//  ObentoGo
//
//  Created by Sergio Hernandez Jr on 04/03/18.
//  Copyright © 2018 Sergio Hernandez. All rights reserved.
//

import UIKit

protocol MenuDetalleObentoImagenPVCDelegate: class
{
    func setupPageController(numberOfPages: Int)
    func turnPageController(to index: Int)
}

class FeedDetailOfferImagePVC: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    weak var pageViewControllerDelegate: MenuDetalleObentoImagenPVCDelegate?
    var imagenes: [UIImage]?
    
    lazy var controllers: [UIViewController] = {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        var controllers = [UIViewController]()
        
        if let imagenes = self.imagenes{
            for imagen in imagenes{
                let obentoImagenVC = storyboard.instantiateViewController(withIdentifier: "imageDetailViewController")
                controllers.append(obentoImagenVC)
            }
        }
        
        self.pageViewControllerDelegate?.setupPageController(numberOfPages: controllers.count)
        
        return controllers
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataSource = self
        self.delegate = self
        
        self.cambiaPagina(indice: 0)
    }
	

    func cambiaPagina(indice: Int){
        let controller = self.controllers[indice]
        var direction = UIPageViewControllerNavigationDirection.forward
        
        if let currentVC = viewControllers?.first {
            let currentIndex = controllers.index(of: currentVC)!
            if currentIndex > indice {
                direction = .reverse
            }
        }
        
        setViewControllers([controller], direction: direction, animated: true, completion: nil)
        
        self.configurarVista(viewController: controller)
    }
    
    func configurarVista(viewController: UIViewController){
        for (indice, vc) in controllers.enumerated() {
            if viewController === vc {
                if let obentoImageVC = viewController as? MenuDetalleObentoImagenVC {
                    obentoImageVC.imagen = self.imagenes?[indice]                    
                    self.pageViewControllerDelegate?.turnPageController(to: indice)
                }
            }
        }
    }
    
    
}
