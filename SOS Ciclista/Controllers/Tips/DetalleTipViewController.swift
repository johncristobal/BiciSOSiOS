//
//  DetalleTipViewController.swift
//  SOS Ciclista
//
//  Created by John A. Cristobal on 4/22/19.
//  Copyright © 2019 i7. All rights reserved.
//

import UIKit
import Hero

class DetalleTipViewController: UIViewController {

    @IBOutlet var detqlleText: UILabel!
    @IBOutlet weak var imagenTip: UIImageView!
    @IBOutlet weak var descriptionTip: UILabel!

    @IBOutlet var vistaAmarilla: UIView!
    var texto: Tip?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        vistaAmarilla.borderAmarillo()
        
        self.hero.isEnabled = true
        detqlleText.hero.id = "tip"
        
        detqlleText.text = texto?.name
        imagenTip.image = UIImage(named: texto!.imagen)
        descriptionTip.text = texto?.description
        // Do any additional setup after loading the view.
    }
    
    @IBAction func close(_ sender: Any) {
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
