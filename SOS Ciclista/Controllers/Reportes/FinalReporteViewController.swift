//
//  FinalReporteViewController.swift
//  SOS Ciclista
//
//  Created by John A. Cristobal on 4/10/19.
//  Copyright © 2019 i7. All rights reserved.
//

import UIKit

class FinalReporteViewController: UIViewController {

    @IBOutlet var buttonFinal: UIButton!
    @IBOutlet var labelFinal: UILabel!
    @IBOutlet var imageFinal: UIImageView!
    
    let name = Notification.Name("tabla")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        
        buttonFinal.borderButton()
    }
    
    @IBAction func buttonaction(_ sender: Any) {
        UserDefaults.standard.set("1", forKey: "reportado")

       NotificationCenter.default.post(name: name, object: nil)
        self.presentingViewController?.presentingViewController?.dismiss(animated: false, completion: nil)
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
