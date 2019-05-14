//
//  SerieViewController.swift
//  SOS Ciclista
//
//  Created by i7 on 3/7/19.
//  Copyright © 2019 i7. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

var titlle = ""
var mensaje = ""

class SerieViewController: UIViewController {

    @IBOutlet weak var vistaAmarrilla: UIView!
    @IBOutlet weak var serieText: UITextField!
    @IBOutlet weak var reportarView: UIImageView!
    @IBOutlet weak var reporteText: UILabel!
    @IBOutlet weak var buttonBuscr: UIButton!
    
    @IBOutlet weak var resultadoView: UIView!
    @IBOutlet weak var dataView: UIView!
    
    @IBOutlet var scrollHide: UIScrollView!
    
   let nameNot = Notification.Name("tabla")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        vistaAmarrilla.borderAmarillo()
        buttonBuscr.borderButton()

        resultadoView.borderButton()
        dataView.borderButton()
        
        addToolBar(textField: serieText)
        
        reportarView.isUserInteractionEnabled = true
        
        let gesture = UITapGestureRecognizer(target: self,action: #selector(self.reportarAction))
        reportarView.addGestureRecognizer(gesture)

        NotificationCenter.default.addObserver(self, selector: #selector(mostrarTabla), name: nameNot, object: nil)
    }
    
    @objc func mostrarTabla(){
        scrollHide.isHidden = false
    }
    
    @IBAction func closeWindow(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

//====================== buscar serie en base firabase ==================
    @IBAction func searchAction(_ sender: Any) {
        let texto = serieText.text
        if texto == ""{
            print("escribe texto")
        }else{
            var ref =  Database.database().reference().child("reportes").queryOrdered(byChild:"serie").queryEqual(toValue: texto).observe(.value, with: { (data) in
                //if let snap = data.value{
                self.scrollHide.isHidden = true
                
                if data.exists(){
                    let datosTemp = data.value
                    print(datosTemp)
                    //let datos = datosTemp["-LcMv7u_I6OAJ80ZEg5a"] as! [String: Any]
                    
                    /*let date = datos["date"] as! String
                    let description = datos["description"] as! String
                    let estatus = datos["estatus"] as! Int
                    let name = datos["name"] as! String
                    let serie = datos["serie"] as! String
                    
                    var fotos = ""
                    if datos["fotos"] != nil{
                        fotos = datos["fotos"] as! String
                    }*/
                    
                    titlle = "# Serie reportado como robado"
                    mensaje = self.serieText.text!
                    self.performSegue(withIdentifier: "result", sender: nil)
                }else{
                    titlle = "# Serie no encontrado"
                    mensaje = "Sin reporte de robo"
                    self.performSegue(withIdentifier: "result", sender: nil)
                }
            }, withCancel: { (error) in
                print(error)
            })
        }
    }
    
    @objc func reportarAction() -> Bool {
        let sesion = UserDefaults.standard.string(forKey: "sesion")
        print("reportar")
        if sesion != nil{
            if sesion == "1"{
                print(sesion)
                saveReporte()
            }else{
                performSegue(withIdentifier: "sesionSerie", sender: nil)
            }
        }else{
            performSegue(withIdentifier: "sesionSerie", sender: nil)
        }
        return true
    }
    
    func saveReporte(){
        self.scrollHide.isHidden = true
        performSegue(withIdentifier: "reporteSerie", sender: nil)
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
