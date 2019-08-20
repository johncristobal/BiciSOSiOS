//
//  AlertasViewController.swift
//  SOS Ciclista
//
//  Created by John A. Cristobal on 5/29/19.
//  Copyright © 2019 i7. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase
import FirebaseDatabase

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
        performSegue(withIdentifier: "apoyoShow", sender: location)
    }
    
    @IBAction func alertaAction(_ sender: Any) {
        let reportado = UserDefaults.standard.string(forKey: "reportado")
        
        if reportado != nil{
            if reportado == "1"{
                //si es 1, entonces hay reporte - recupero id y muestro detalle
                //mostrar leyenda de reportado
                let key = UserDefaults.standard.string(forKey: "llavereporte")
                let ref = Database.database().reference().child("reportes").child(key!)
                
                ref.observeSingleEvent(of: .value, with: { (data) in
                    
                    //for child in data.children {
                        let snap = data as! DataSnapshot
                        let datos = snap.value as! [String: Any]
                        let id = datos["id"] as! String
                        let date = datos["date"] as! String
                        let description = datos["description"] as! String
                        let estatus = datos["estatus"] as! Int
                        let name = datos["name"] as! String
                        let serie = datos["serie"] as! String
                        
                        let tipo = datos["tipo"] as! Int
                        let latitud = datos["latitude"] as! Double
                        let longitude = datos["longitude"] as! Double
                        
                        var fotos = ""
                        if datos["fotos"] != nil{
                            fotos = datos["fotos"] as! String
                        }
                        
                        let report = Report(id: id, name: name, serie: serie, description: description, estatus: estatus, date: date, fotos: fotos, tipo: tipo, latitude: latitud, longitude: longitude)
                        
                        UserDefaults.standard.set("1", forKey: "fromAlerta")
                        self.performSegue(withIdentifier: "detalleReporte", sender: report)
                    //}
                    
                }) { (error) in
                    print(error)
                }
            }else{
                performSegue(withIdentifier: "alertaMain", sender: location)
            }
        }else{
            performSegue(withIdentifier: "alertaMain", sender: location)
        }
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
        }else if segue.identifier == "apoyoShow"{
            let vc = segue.destination as? ApoyoViewController
            vc?.location = sender as! CLLocation
        }else if segue.identifier == "detalleReporte"{
            let vc = segue.destination as! DetalleReporteViewController
            vc.report = sender as? Report
        }
    }
}
