//
//  MenuViewController.swift
//  SOS Ciclista
//
//  Created by i7 on 3/7/19.
//  Copyright © 2019 i7. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet var miniView: UIView!
    
    
    let opciones : [String] = ["Reportes","Me robaron la bici...","# serie con reporte","Tips","Contáctanos","Acerca de","Ajustes","Iniciar sesión"]
    let iconos = [#imageLiteral(resourceName: "reportesiconsmall"),#imageLiteral(resourceName: "serieiconsmall"),#imageLiteral(resourceName: "buscaricon"),#imageLiteral(resourceName: "tipsicon"),#imageLiteral(resourceName: "contactoiconsmall"),#imageLiteral(resourceName: "acercaicon"),#imageLiteral(resourceName: "ajustesicon"),#imageLiteral(resourceName: "saliricon")]

    let segues : [String] = ["reportes","serie"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        miniView.layer.cornerRadius = 50;
        miniView.layer.masksToBounds = true;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return opciones.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! MenuTableViewCell
        
        cell.nameText.text = opciones[indexPath.row]
        cell.iconImage.image = iconos[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.revealViewController()?.revealToggle(animated: true)
        performSegue(withIdentifier: segues[indexPath.row], sender: nil)
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
