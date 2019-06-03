//
//  CicloviaViewController.swift
//  SOS Ciclista
//
//  Created by John A. Cristobal on 6/3/19.
//  Copyright © 2019 i7. All rights reserved.
//

import UIKit

class CicloviaViewController: UIViewController {

    @IBOutlet var textDetails: UITextField!
    @IBOutlet var cicloviaIcon: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.7)
        
        self.hero.isEnabled = true
        cicloviaIcon.hero.id = "ciclovia"
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func sendAction(_ sender: Any) {
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
