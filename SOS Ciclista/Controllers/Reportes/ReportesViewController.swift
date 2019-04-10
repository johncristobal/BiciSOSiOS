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

    @IBOutlet var imageReportar: UIImageView!
    @IBOutlet var tableview: UITableView!
    
    var reportes : [Report] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imageReportar.isUserInteractionEnabled = true

        let gesture = UITapGestureRecognizer(target: self,action: #selector(self.reportarAction))
        imageReportar.addGestureRecognizer(gesture)
        
        reportes.removeAll()

        getDataReportes()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("sesion")
        let sesion = UserDefaults.standard.string(forKey: "sesion")
        if sesion != nil{
            if sesion == "1"{
                print(sesion!)
            }else{
                print(sesion!)
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
        }
        return true
    }

    func saveReporte(){
        
        performSegue(withIdentifier: "reporte", sender: nil)
    }
    
    func getDataReportes(){
        var ref: DatabaseReference!
        ref = Database.database().reference().child("reportes")
        ref.observeSingleEvent(of: .value, with: { (data) in
            let value = data.value as? NSDictionary
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
            })
            
            self.tableview.reloadData()            
            
        }) { (error) in
            print(error)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reportes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reportCell") as! ReportTableViewCell
        
        cell.titleLabel.text = reportes[indexPath.row].name
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
