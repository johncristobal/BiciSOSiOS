//
//  ViewController.swift
//  SOS Ciclista
//
//  Created by i7 on 3/3/19.
//  Copyright © 2019 i7. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var mapview: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        setMenu()
    }
    
    func setMenu(){
        if self.revealViewController() != nil {
            
            menuButton.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            
            //menuButton.target = self.revealViewController()
            //menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    @IBAction func showMenu(_ sender: Any) {
    }
}
