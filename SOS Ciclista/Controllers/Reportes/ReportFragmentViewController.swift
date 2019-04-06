//
//  ReportFragmentViewController.swift
//  SOS Ciclista
//
//  Created by i7 on 4/6/19.
//  Copyright © 2019 i7. All rights reserved.
//

import UIKit

class ReportFragmentViewController: UIViewController {

    
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var serieText: UITextField!
    @IBOutlet weak var detailsText: UITextField!
    @IBOutlet weak var viewData: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.7)
        //viewData.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
    }
    
    @IBAction func saveReport(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addPhotos(_ sender: Any) {
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
