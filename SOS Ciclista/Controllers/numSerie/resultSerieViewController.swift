//
//  resultSerieViewController.swift
//  SOS Ciclista
//
//  Created by John A. Cristobal on 5/13/19.
//  Copyright © 2019 i7. All rights reserved.
//

import UIKit

class resultSerieViewController: UIViewController {

    @IBOutlet var vista: UIView!
    @IBOutlet var buttonFinal: UIButton!
    @IBOutlet var textContent: UILabel!
    @IBOutlet var textTitle: UILabel!
    
   let nameNot = Notification.Name("tabla")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textTitle.text = titlle
        textContent.text = mensaje
        
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.8)
        
        buttonFinal.borderButton()
        vista.borderButton()
    }
    
    @IBAction func backButton(_ sender: Any) {
        NotificationCenter.default.post(name: nameNot, object: nil)
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
