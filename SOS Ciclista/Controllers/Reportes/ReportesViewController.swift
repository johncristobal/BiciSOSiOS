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
import CoreLocation

class ReportesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var vistaAmarilla: UIView!
    @IBOutlet var imageReportar: UIImageView!
    @IBOutlet var tableview: UITableView!
    
    var reportes : [Report] = []

    let nameNot = Notification.Name("tabla")
    
    @IBOutlet weak var buscarSerie: UITextField!
    
    var location : CLLocation? = nil
        
    @IBOutlet var buscarIcon: UIImageView!
    @IBOutlet var vistaSerieText: UIView!
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
        
        buscarIcon.isUserInteractionEnabled = true
        let gestureSearch = UITapGestureRecognizer(target: self, action: #selector(buscarActionImage))
        buscarIcon.addGestureRecognizer(gestureSearch)
        
        vistaSerieText.borderButton()
        
        buscarSerie.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }

    @objc func mostrarTabla(){
        tableview.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        /*print("sesion")
        let reportado = UserDefaults.standard.string(forKey: "reportado")
        if reportado != nil{
            if reportado == "1"{
                UserDefaults.standard.set("0", forKey: "reportado")
                getDataReportes()
            }else{
                print(reportado!)
            }
        }*/
    }
    
    @IBAction func closeWindow(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        /*if textField == buscarSerie{
            if textField.text == ""{
                print("vacio")
                getDataReportes()
            }
        }*/
    }
    
    /*func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == buscarSerie{
            if textField.text == ""{
                print("vacio")
                getDataReportes()
            }
        }
    }*/
    
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
                performSegue(withIdentifier: "reporte", sender: location)
            }
        }else{
            performSegue(withIdentifier: "reporte", sender: location)
        }
    }
    
    func getDataReportes(){
        
        self.reportes.removeAll()
        
        //var ref: DatabaseReference!
        let ref = Database.database().reference().child("reportes").queryOrdered(byChild: "tipo").queryEqual(toValue: 1)
        
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
                
                let tipo = datos["tipo"] as! Int
                let latitud = datos["latitude"] as! Double
                let longitude = datos["longitude"] as! Double
                
                var fotos = ""
                if datos["fotos"] != nil{
                    fotos = datos["fotos"] as! String
                }
                
                self.reportes.append(Report(id: id, name: name, serie: serie, description: description, estatus: estatus, date: date, fotos: fotos, tipo: tipo, latitude: latitud, longitude: longitude))
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
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        print("caracter: \(textField.text!)")
        let searchTerm = textField.text!
        
        if searchTerm == "" {
            print("vacio")
            getDataReportes()
        }
        
        //NSRegularExpression(pattern: T##String, options: T##NSRegularExpression.Options
        /*let regex = try! NSRegularExpression(pattern: "^[a-z-A-Z-0-9 ]+$")
        let range = NSRange(location: 0, length: searchTerm.utf16.count)
        if regex.firstMatch(in: searchTerm, options: [], range: range) == nil {
            print("could not handle special characters")
            let runningNumber = String(searchTerm.dropLast())
            textField.text = runningNumber
        }*/
        /*if regex.firstMatchInString(searchTerm!, options: nil, range: NSMakeRange(0, searchTerm!.length)) != nil {
         print("could not handle special characters")
         }*/
    }
    
    @objc func buscarActionImage(){
        buscarSerie.resignFirstResponder()
        buscarSerie.endEditing(true)
        
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
                        let tipo = datos["tipo"] as! Int
                        let latitud = datos["latitude"] as! Double
                        let longitude = datos["longitude"] as! Double
                        
                        var fotos = ""
                        if datos["fotos"] != nil{
                            fotos = datos["fotos"] as! String
                        }
                        
                        if tipo == 1{
                            self.reportes.append(Report(id: id, name: name, serie: serie, description: description, estatus: estatus, date: date, fotos: fotos, tipo: tipo, latitude: latitud, longitude: longitude))
                        }
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
                    //Toast...
                    showmessage(message: "# Serie no encontrado", controller: self)
                    titlle = "# Serie no encontrado"
                    mensaje = "Sin reporte de robo"
                    //self.performSegue(withIdentifier: "result", sender: nil)
                }                
            }, withCancel: { (error) in
                print(error)
            })
        }
    }
    
    @IBAction func buscarAction(_ sender: Any) {
        
    }
}
