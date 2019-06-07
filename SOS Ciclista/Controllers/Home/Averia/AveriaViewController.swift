//
//  AveriaViewController.swift
//  SOS Ciclista
//
//  Created by i7 on 6/1/19.
//  Copyright © 2019 i7. All rights reserved.
//

import UIKit

class AveriaViewController: UIViewController {

    @IBOutlet weak var detallesText: UITextField!
    @IBOutlet weak var averiaIcon: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.7)

        self.hero.isEnabled = true
        averiaIcon.hero.id = "averia"
        
      addToolBar(textField: detallesText)
    }
    
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendReportAction(_ sender: Any) {
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
