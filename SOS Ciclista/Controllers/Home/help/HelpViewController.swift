//
//  HelpViewController.swift
//  SOS Ciclista
//
//  Created by John A. Cristobal on 6/3/19.
//  Copyright © 2019 i7. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController {

    @IBOutlet var helpIcon: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.7)
        
        self.hero.isEnabled = true
        helpIcon.hero.id = "help"
        // Do any additional setup after loading the view.
    }
    
    @IBAction func callAction(_ sender: Any) {
    }
    
    @IBAction func twitterUno(_ sender: Any) {
    }
    
    
    @IBAction func backAction(_ sender: Any) {
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
