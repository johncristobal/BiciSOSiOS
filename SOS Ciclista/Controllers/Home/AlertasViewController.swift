//
//  AlertasViewController.swift
//  SOS Ciclista
//
//  Created by John A. Cristobal on 5/29/19.
//  Copyright © 2019 i7. All rights reserved.
//

import UIKit
import CoreLocation

class AlertasViewController: UIViewController {

    @IBOutlet weak var averiaIcon: UIButton!
    @IBOutlet var cerrarAction: UILabel!
    @IBOutlet var apoyoIcon: UIButton!
    @IBOutlet var cicloviaIcon: UIButton!
    @IBOutlet var helpAction: UIButton!
    
    var location : CLLocation? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(white: 0.0, alpha: 0.7)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(cerrar))
        cerrarAction.isUserInteractionEnabled = true
        cerrarAction.addGestureRecognizer(gesture)
        
        averiaIcon.hero.id = "averia"
        cicloviaIcon.hero.id = "ciclovia"
        helpAction.hero.id = "help"
        apoyoIcon.hero.id = "apoyo"
        
        //let longitud = location?.coordinate.longitude
    }
    
    @objc func cerrar(){
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cicloviaAction(_ sender: Any) {
        performSegue(withIdentifier: "cicloviaShow", sender: location)
    }
    
    @IBAction func helpAction(_ sender: Any) {
        performSegue(withIdentifier: "helpShow", sender: nil)
    }
    
    @IBAction func averiaAction(_ sender: Any) {
        performSegue(withIdentifier: "averiaShow", sender: location)
    }
    
    @IBAction func apoyoAction(_ sender: Any) {
        performSegue(withIdentifier: "apoyoShow", sender: nil)
    }
    
    @IBAction func alertaAction(_ sender: Any) {
        
        performSegue(withIdentifier: "alertaMain", sender: location)
        
        /*
        let storyboard = self.storyboard//UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard!.instantiateViewController(withIdentifier: "reportFragment") as! ReportFragmentViewController
        present(vc, animated: true, completion: nil)
         */
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "alertaMain"{
            let vc = segue.destination as? ReportFragmentViewController
            vc?.location = sender as! CLLocation
        }else if segue.identifier == "averiaShow"{
            let vc = segue.destination as? AveriaViewController
            vc?.location = sender as! CLLocation
        }else if segue.identifier == "cicloviaShow"{
            let vc = segue.destination as? CicloviaViewController
            vc?.location = sender as! CLLocation
        }
    }
}
