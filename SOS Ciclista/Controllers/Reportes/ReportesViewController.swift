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
        /*reportes.append(Report(id: "1", title: "reporte 1", description: "", estatus: "1"))
        reportes.append(Report(id: "1", title: "reporte 1", description: "", estatus: "1"))
        reportes.append(Report(id: "1", title: "reporte 1", description: "", estatus: "1"))
        reportes.append(Report(id: "1", title: "reporte 1", description: "", estatus: "1"))
        reportes.append(Report(id: "1", title: "reporte 1", description: "", estatus: "1"))*/

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
        /*
        let ref = Database.database().reference()
        let uid = Auth.auth().currentUser?.uid
        let thisUsersGamesRef = ref.child("reportes").childByAutoId()
        thisUsersGamesRef.setValue(["id":thisUsersGamesRef.key,"imageUrl":"utlios","textTitle":"tituloisio"])
         */
        //show view with data
    }
    
    func getDataReportes(){
        var ref: DatabaseReference!
        ref = Database.database().reference().child("reportes")
        ref.observeSingleEvent(of: .value, with: { (data) in
            let value = data.value as? NSDictionary
            value?.forEach({ (arg0) in
                let (key, value) = arg0
                
                let datos = value as! NSDictionary
                let title = key as! String
                let id = datos["textTitle"] as! String
                self.reportes.append(Report(id: id, title: title, description: "...", estatus: "id"))
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
        
        cell.titleLabel.text = reportes[indexPath.row].title
        
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
