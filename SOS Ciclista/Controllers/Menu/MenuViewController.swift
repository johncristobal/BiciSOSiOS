//
//  MenuViewController.swift
//  SOS Ciclista
//
//  Created by i7 on 3/7/19.
//  Copyright © 2019 i7. All rights reserved.
//

import UIKit

var imagen = #imageLiteral(resourceName: "launcher")

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet var miniView: UIView!
    @IBOutlet weak var biciUser: UIImageView!
    @IBOutlet weak var nameUser: UILabel!
    let imagenes = [#imageLiteral(resourceName: "bicib"),#imageLiteral(resourceName: "bicia"),#imageLiteral(resourceName: "bicid"),#imageLiteral(resourceName: "bicic")]

    let opciones : [String] = ["Reportes","Me robaron la bici...","# serie con reporte","Tips","Contáctanos","Acerca de","Ajustes","Iniciar sesión"]
    let iconos = [#imageLiteral(resourceName: "reportesiconsmall"),#imageLiteral(resourceName: "serieiconsmall"),#imageLiteral(resourceName: "buscaricon"),#imageLiteral(resourceName: "tipsicon"),#imageLiteral(resourceName: "contactoiconsmall"),#imageLiteral(resourceName: "acercaicon"),#imageLiteral(resourceName: "ajustesicon"),#imageLiteral(resourceName: "saliricon")]

    let segues : [String] = ["reportes","robo","serie","serie","reportes","serie","reportes","login"]
    
    var sesion = "0"
    
    let nameNot = Notification.Name("biciIcon")

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        miniView.layer.cornerRadius = 50;
        miniView.layer.masksToBounds = true;
        
        let name = UserDefaults.standard.string(forKey: "nombre")
        if name != nil{
            nameUser.text = name
        }else{
            nameUser.text = "SOS Ciclista"
        }

        let indexbici = UserDefaults.standard.integer(forKey: "bici")
        if indexbici != -1{
            biciUser.image = imagenes[indexbici]
        }else{
            biciUser.image = imagen
        }
        let ses = UserDefaults.standard.string(forKey: "sesion")
        if ses != nil{
            sesion = ses!
            if sesion == "1"{
                let tapgesture = UITapGestureRecognizer(target: self, action: #selector(abrirPersonaliza))
                
                miniView.isUserInteractionEnabled = true
                miniView.addGestureRecognizer(tapgesture)
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(cambiarIcono), name: nameNot, object: nil)        
    }

    @objc func cambiarIcono(){
        let indexbici = UserDefaults.standard.integer(forKey: "bici")
        if indexbici != -1{
            biciUser.image = imagenes[indexbici]
        }else{
            biciUser.image = imagen
        }
        let name = UserDefaults.standard.string(forKey: "nombre")
        if name != nil{
            nameUser.text = name
        }else{
            nameUser.text = "SOS Ciclista"
        }
        let ses = UserDefaults.standard.string(forKey: "sesion")
        if ses != nil{
            sesion = ses!
            if sesion == "1"{
                let tapgesture = UITapGestureRecognizer(target: self, action: #selector(abrirPersonaliza))
                
                miniView.isUserInteractionEnabled = true
                miniView.addGestureRecognizer(tapgesture)
            }
        }
        tableview.reloadData()
    }

    @objc func abrirPersonaliza(){
        self.revealViewController()?.revealToggle(animated: true)
        performSegue(withIdentifier: "personaliza", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return opciones.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! MenuTableViewCell
        
        if indexPath.row == 7{
            if sesion == "1" {
                cell.nameText.text = "Cerrar sesión"
                cell.iconImage.image = iconos[indexPath.row]
            }else{
                cell.nameText.text = opciones[indexPath.row]
                cell.iconImage.image = iconos[indexPath.row]
            }
        }else{
            cell.nameText.text = opciones[indexPath.row]
            cell.iconImage.image = iconos[indexPath.row]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.revealViewController()?.revealToggle(animated: true)
        if indexPath.row == 7{
            if sesion == "1" {
                print("cerrar sesion")
            }else{
                performSegue(withIdentifier: segues[indexPath.row], sender: nil)
            }
        }else{
            performSegue(withIdentifier: segues[indexPath.row], sender: nil)
        }
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
