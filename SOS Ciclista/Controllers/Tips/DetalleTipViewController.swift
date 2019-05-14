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
    
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()

        vistaAmarilla.borderAmarillo()
        
        self.hero.isEnabled = true
        detqlleText.hero.id = "tip"
        
        detqlleText.text = texto?.name
        descriptionTip.text = texto?.description

        //antes de agiantr la imagen, tenemos que actualizar al height de la imagen que viene
        
        let image =  UIImage(named: texto!.imagen)
        let height = image!.size.height
        print("height: \(height)")
        
        //imagenTip.frame = CGRect(x: 0, y: 0, width: imagenTip.frame.size.width, height: (height))
        heightConstraint.constant = height / 2.5
        imagenTip.image = UIImage(named: texto!.imagen)
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
