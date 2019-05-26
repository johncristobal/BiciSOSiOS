//
//  ReportesViewController.swift
//  SOS Ciclista
//
//  Created by i7 on 3/5/19.
//  Copyright © 2019 i7. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import Alamofire
import AlamofireImage

class ReportesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var vistaAmarilla: UIView!
    @IBOutlet var imageReportar: UIImageView!
    @IBOutlet var tableview: UITableView!
    
    var reportes : [Report] = []

    let nameNot = Notification.Name("tabla")
    
    @IBOutlet weak var buscarSerie: UITextField!
        
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        vistaAmarilla.borderAmarillo()
        imageReportar.isUserInteractionEnabled = true

        let gesture = UITapGestureRecognizer(target: self,action: #selector(self.reportarAction))
        imageReportar.addGestureRecognizer(gesture)
        
        reportes.removeAll()

        getDataReportes()
        
        addToolBar(textField: buscarSerie)

        
        NotificationCenter.default.addObserver(self, selector: #selector(mostrarTabla), name: nameNot, object: nil)
    }

    @objc func mostrarTabla(){
        tableview.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        print("sesion")
        let reportado = UserDefaults.standard.string(forKey: "reportado")
        if reportado != nil{
            if reportado == "1"{
                UserDefaults.standard.set("0", forKey: "reportado")
                getDataReportes()
            }else{
                print(reportado!)
            }
        }
    }
    
    @IBAction func closeWindow(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func reportarAction() -> Bool {
        let sesion = UserDefaults.standard.string(forKey: "sesion")
        print("reportar")
        if sesion != nil{
            if sesion == "1"{
                print(sesion)
                saveReporte()
            }else{
                performSegue(withIdentifier: "sesion", sender: nil)
            }
        }else{
            performSegue(withIdentifier: "sesion", sender: nil)
        }
        return true
    }

    func saveReporte(){
        tableview.isHidden = true
        performSegue(withIdentifier: "reporte", sender: nil)
    }
    
    func getDataReportes(){
        
        self.reportes.removeAll()
        
        var ref: DatabaseReference!
        ref = Database.database().reference().child("reportes")
        ref.observeSingleEvent(of: .value, with: { (data) in
            
            for child in data.children {
                let snap = child as! DataSnapshot
                let datos = snap.value as! [String: Any]
                let id = datos["id"] as! String
                let date = datos["date"] as! String
                let description = datos["description"] as! String
                let estatus = datos["estatus"] as! Int
                let name = datos["name"] as! String
                let serie = datos["serie"] as! String
                
                var fotos = ""
                if datos["fotos"] != nil{
                    fotos = datos["fotos"] as! String
                }
                
                self.reportes.append(Report(id: id, name: name, serie: serie, description: description, estatus: estatus, date: date, fotos: fotos))
            }
            
            /*for child in data.children {
                if let snapshot = child as? DataSnapshot {
                    do{
                        let id = child.value(forKey: "id") as! String
                        let date = snapshot.value(forKey: "date") as! String
                        let description = snapshot.value(forKey: "description") as! String
                        let estatus = snapshot.value(forKey: "estatus") as! Int
                        let name = snapshot.value(forKey: "name") as! String
                        let serie = snapshot.value(forKey: "serie") as! String
                        let reporte = Report(id: id, name: name, serie: serie, description: description, estatus: estatus, date: date)
                        self.reportes.append(reporte)
                    }
                    catch{
                        print("error")
                    }
                }
            }*/
            
            /*let value = data.value as? NSDictionary
            value?.forEach({ (arg0) in
                let (key, value) = arg0
                
                let datos = value as! NSDictionary
                let id = datos["id"] as! String
                let date = datos["date"] as! String
                let description = datos["description"] as! String
                let estatus = datos["estatus"] as! Int
                let name = datos["name"] as! String
                let serie = datos["serie"] as! String

                self.reportes.append(Report(id: id, name: name, serie: serie, description: description, estatus: estatus, date: date))
            })*/
            
            self.reportes.reverse()
            self.tableview.reloadData()            
            
        }) { (error) in
            print(error)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reportes.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableview.isHidden = true
        
        let report = reportes[indexPath.row]
        performSegue(withIdentifier: "detalleReporte", sender: report)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reportCell") as! ReportTableViewCell
        
        cell.titleLabel.text = "# Serie \(reportes[indexPath.row].serie)"
        cell.descriptionLabel.text = reportes[indexPath.row].description
        let idfolder = reportes[indexPath.row].id
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let reporteRef = storageRef.child("reportes").child(idfolder).child("bici_0.png")

        reporteRef.downloadURL { (url, error) in
            if error != nil {
                cell.imageBici.image = imagen
            }else {
                Alamofire.request(url!).responseImage { response in
                    if let image = response.result.value {
                        cell.imageBici.image = image
                    }
                }
            }
        }
        
        return cell
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "detalleReporte"{
            let vc = segue.destination as! DetalleReporteViewController
            vc.report = sender as? Report
        }
    }
    
    @IBAction func buscarAction(_ sender: Any) {
        let texto = buscarSerie.text
        if texto == ""{
            print("escribe texto")
        }else{
            var ref =  Database.database().reference().child("reportes").queryOrdered(byChild:"serie").queryEqual(toValue: texto).observe(.value, with: { (data) in
                //if let snap = data.value{
                //self.scrollHide.isHidden = true
                
                if data.exists(){
                    self.reportes.removeAll()
                    //let datosTemp = data.value
                    //print(datosTemp)
                    
                    for child in data.children {
                        let snap = child as! DataSnapshot
                        let datos = snap.value as! [String: Any]
                        let id = datos["id"] as! String
                        let date = datos["date"] as! String
                        let description = datos["description"] as! String
                        let estatus = datos["estatus"] as! Int
                        let name = datos["name"] as! String
                        let serie = datos["serie"] as! String
                        
                        var fotos = ""
                        if datos["fotos"] != nil{
                            fotos = datos["fotos"] as! String
                        }
                        
                        self.reportes.append(Report(id: id, name: name, serie: serie, description: description, estatus: estatus, date: date, fotos: fotos))
                    }
                    
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
                    
                    self.tableview.reloadData()

                    titlle = "# Serie reportado como robado"
                    //mensaje = self.serieText.text!
                    //self.performSegue(withIdentifier: "result", sender: nil)
                }else{
                    titlle = "# Serie no encontrado"
                    mensaje = "Sin reporte de robo"
                    //self.performSegue(withIdentifier: "result", sender: nil)
                }
                
            }, withCancel: { (error) in
                print(error)
            })
        }
    }
}
