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
    var textoFinal : Tip?

    var tips : [Tip] = [Tip(name: "Tips generales", imagen: "bicicuatro.png", description: ""),Tip(name: "Como asegurar tu bici", imagen: "tipsdos.png", description: "Fijar la bicicleta en un soporte empotrado, nunca en soporte atornillado, ni en árboles.\n" +
        "• Utiliza dos candados como mínimo.\n" +
        "• Asegurar el cuadro y una de las dos llantas con cable de acero.\n" +
        "• NO fijar solo el sillín."),Tip(name: "Candados que no debes usar", imagen: "tipstres.png", description: ""),Tip(name: "Reglamento uso y obligaciones", imagen: "tipcuatro.png", description: "")]
    
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
        
        cell.tipText.text = tips[indexPath.row].name
        
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
