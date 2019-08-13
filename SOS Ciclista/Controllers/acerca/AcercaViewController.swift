//
//  AcercaViewController.swift
//  SOS Ciclista
//
//  Created by John A. Cristobal on 5/28/19.
//  Copyright © 2019 i7. All rights reserved.
//

import UIKit

class AcercaViewController: UIViewController {

    @IBOutlet var tutorialButton: UIButton!
    
    @IBOutlet var vistaAmarilla: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        vistaAmarilla.borderAmarillo()
        // Do any additional setup after loading the view.
        
        tutorialButton.borderButton()
    }
    
    @IBAction func closeWindow(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
