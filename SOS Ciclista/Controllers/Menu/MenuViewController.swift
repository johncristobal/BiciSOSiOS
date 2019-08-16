//
//  MenuViewController.swift
//  SOS Ciclista
//
//  Created by i7 on 3/7/19.
//  Copyright © 2019 i7. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FacebookCore
import FacebookLogin

var imagen = #imageLiteral(resourceName: "launcher")

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet var miniView: UIView!
    @IBOutlet weak var biciUser: UIImageView!
    @IBOutlet weak var nameUser: UILabel!
    //let imagenes = [#imageLiteral(resourceName: "bicib"),#imageLiteral(resourceName: "bicia"),#imageLiteral(resourceName: "bicid"),#imageLiteral(resourceName: "bicic"),#imageLiteral(resourceName: "bicie"),#imageLiteral(resourceName: "bicif")]
    let imagenes = [#imageLiteral(resourceName: "bicia"),#imageLiteral(resourceName: "bicib"),#imageLiteral(resourceName: "bicic"),#imageLiteral(resourceName: "bicid"),#imageLiteral(resourceName: "bicie"),#imageLiteral(resourceName: "bicif")]

    var opciones : [String] = [
        "Reportes",
        "Me robaron la bici...",
        //"# serie con reporte",
        "Tips",
        "Contáctanos",
        "Acerca de",
        //"Ajustes",
        "Iniciar sesión"
    ]
    let iconos = [#imageLiteral(resourceName: "reportesiconsmall"),#imageLiteral(resourceName: "serieiconsmall"),#imageLiteral(resourceName: "buscaricon"),#imageLiteral(resourceName: "tipsicon"),#imageLiteral(resourceName: "contactoiconsmall"),#imageLiteral(resourceName: "acercaicon"),#imageLiteral(resourceName: "ajustesicon"),#imageLiteral(resourceName: "saliricon")]

    let segues : [String] = [
        "reportes",
        "robo",
        //"serie",
        "tips",
        "contacto",
        "acerca",
        //"reportes",
        "login"
    ]
    
    var sesion = "0"
    
    let nameNot = Notification.Name("biciIcon")
    let closeSesion = Notification.Name("closeSesion")

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        miniView.layer.cornerRadius = 50;
        miniView.layer.masksToBounds = true;
        
        let ses = UserDefaults.standard.string(forKey: "sesion")
        if ses != nil{
            sesion = ses!
            if sesion == "1"{
                let tapgesture = UITapGestureRecognizer(target: self, action: #selector(abrirPersonaliza))
                
                miniView.isUserInteractionEnabled = true
                miniView.addGestureRecognizer(tapgesture)
                
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
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(cambiarIcono), name: nameNot, object: nil)        
    }

    @objc func cambiarIcono(){
        
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(abrirPersonaliza))

        let ses = UserDefaults.standard.string(forKey: "sesion")
        if ses != nil{
            sesion = ses!
            if sesion == "1"{
                
                miniView.isUserInteractionEnabled = true
                miniView.addGestureRecognizer(tapgesture)
                
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
                opciones[5] = "Cerrar sesión"
                tableview.reloadData()
            }else{
                miniView.isUserInteractionEnabled = false
                miniView.removeGestureRecognizer(tapgesture)
                opciones[5] = "Iniciar sesión"
                tableview.reloadData()
            }
        }else{
            miniView.isUserInteractionEnabled = false
            miniView.removeGestureRecognizer(tapgesture)
            opciones[5] = "Iniciar sesión"
            tableview.reloadData()
        }
    }

    @objc func abrirPersonaliza(){
        //self.revealViewController()?.revealToggle(animated: true)
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
        
        if indexPath.row == 5{
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
        
        if indexPath.row == 5{
            if sesion == "1" {
                
                let refreshAlert = UIAlertController(title: "Atención", message: "¿Deseas cerrar sesión?", preferredStyle: UIAlertController.Style.alert)
                
                let action = (UIAlertAction(title: "Sí", style: .default, handler: { (action: UIAlertAction!) in
                    
                    print("Cerrando...")
                    //let prefs = UserDefaults.standard
                    let defaults = UserDefaults.standard
                    let dictionary = defaults.dictionaryRepresentation()
                    dictionary.keys.forEach { key in
                        defaults.removeObject(forKey: key)
                    }
                    //prefs.removeObject(forKey:"sesion")
                    //prefs.removeObject(forKey: "bici")
                    self.sesion = "0"
                    
                    //cierra sesion facebook si hay...
                    let firebaseAuth = Auth.auth()
                    do {
                        try firebaseAuth.signOut()
                    } catch let signOutError as NSError {
                        print ("Error signing out: %@", signOutError)
                    }
                    
                    if AccessToken.current != nil{
                        let loginManager = LoginManager()
                        loginManager.logOut()
                    }
                    
                    self.nameUser.text = "SOS Ciclista"
                    self.biciUser.image = imagen
                    self.miniView.isUserInteractionEnabled = true
                    
                    self.opciones[5] = "Iniciar sesión"
                    self.tableview.reloadData()
                   
                    self.revealViewController()?.revealToggle(animated: true)
                    NotificationCenter.default.post(name: self.closeSesion, object: nil)
                }))
                
                refreshAlert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action: UIAlertAction!) in
                    
                    print("Nada...")
                    
                }))
                
                refreshAlert.addAction(action)
                present(refreshAlert, animated: true)
                
            }else{
                self.revealViewController()?.revealToggle(animated: true)
                performSegue(withIdentifier: segues[indexPath.row], sender: nil)
            }
        }else{
            self.revealViewController()?.revealToggle(animated: true)
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
