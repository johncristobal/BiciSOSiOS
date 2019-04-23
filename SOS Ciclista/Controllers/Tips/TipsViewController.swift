//
//  TipsViewController.swift
//  SOS Ciclista
//
//  Created by John A. Cristobal on 4/22/19.
//  Copyright © 2019 i7. All rights reserved.
//

import UIKit

class TipsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var vistaAmarilla: UIView!
    
    @IBOutlet var tableview: UITableView!
    var textoFinal = ""

    var tips : [String] = ["Tips generales","Como asegurar tu bici","Candados que no debes usar"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        vistaAmarilla.borderAmarillo()
    }
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tips.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celdaTip", for: indexPath) as! TipTableViewCell
        
        cell.tipText.text = tips[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        textoFinal = tips[indexPath.row]
        performSegue(withIdentifier: "detalleTipSegue", sender: nil)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "detalleTipSegue"{
            let vc = segue.destination as! DetalleTipViewController
            vc.texto = textoFinal
        }
    }
    

}
