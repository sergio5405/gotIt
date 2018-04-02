//
//  FeedVC
//  gotIt
//
//  Created by Sergio Hernandez Jr on 01/04/18.
//  Copyright © 2018 Sergio Hernandez. All rights reserved.
//

import UIKit

class FeedVC: UIViewController {
    @IBOutlet weak var filtersView: UIView!
    @IBOutlet weak var productTableView: UITableView!
    @IBOutlet var filterOptions: [UIView]!
    @IBOutlet weak var distanceLbl: UILabel!
    
    let blurredBackground = UIVisualEffectView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupFilterView()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

