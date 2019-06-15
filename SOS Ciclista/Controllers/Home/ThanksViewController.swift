//
//  ThanksViewController.swift
//  SOS Ciclista
//
//  Created by i7 on 6/14/19.
//  Copyright © 2019 i7. All rights reserved.
//

import UIKit

class ThanksViewController: UIViewController {

    @IBOutlet var buttonFinal: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        
        buttonFinal.borderButton()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func buttonaction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        //NotificationCenter.default.post(name: name, object: nil)
    
    //self.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: false, completion: nil)

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
