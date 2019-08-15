//
//  ApoyoViewController.swift
//  SOS Ciclista
//
//  Created by John A. Cristobal on 6/3/19.
//  Copyright © 2019 i7. All rights reserved.
//

import UIKit
import CoreLocation

class ApoyoViewController: UIViewController {

    @IBOutlet var apoyoIcon: UIButton!
    var location : CLLocation? = nil

    @IBOutlet var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.7)
        
        self.hero.isEnabled = true
        apoyoIcon.hero.id = "apoyo"
        // Do any additional setup after loading the view.
        backButton.borderButton()
    }
    
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func apoyoAction(_ sender: Any) {
        performSegue(withIdentifier: "detalleApoyo", sender: location)
    }
    
    @IBAction func vallaAction(_ sender: Any) {
        performSegue(withIdentifier: "detalleApoyo", sender: location)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "detalleApoyo"{
            let vc = segue.destination as? DetalleApoyoViewController
            vc?.location = sender as! CLLocation
        }
    }
 

}
