//
//  AlertasViewController.swift
//  SOS Ciclista
//
//  Created by John A. Cristobal on 5/29/19.
//  Copyright © 2019 i7. All rights reserved.
//

import UIKit

class AlertasViewController: UIViewController {

    @IBOutlet var cerrarAction: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(white: 0.0, alpha: 0.7)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(cerrar))
        cerrarAction.isUserInteractionEnabled = true
        
        cerrarAction.addGestureRecognizer(gesture)
    }
    
    @objc func cerrar(){
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cicloviaAction(_ sender: Any) {
    }
    
    @IBAction func helpAction(_ sender: Any) {
    }
    
    @IBAction func averiaAction(_ sender: Any) {
    }
    @IBAction func apoyoAction(_ sender: Any) {
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
