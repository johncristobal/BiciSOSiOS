//
//  PersonalizaViewController.swift
//  SOS Ciclista
//
//  Created by John A. Cristobal on 3/14/19.
//  Copyright © 2019 i7. All rights reserved.
//

import UIKit

class PersonalizaViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet var aceptarButton: UIButton!
    @IBOutlet var bicisCollection: UICollectionView!
    @IBOutlet var nameText: UITextField!
    @IBOutlet var addPhotosButton: UIButton!
    @IBOutlet var serieText: UITextField!
    @IBOutlet var detailsText: UITextField!
    
    @IBOutlet var vistaAmarillo: UIView!
    let imagenes = [#imageLiteral(resourceName: "bicib"),#imageLiteral(resourceName: "bicia"),#imageLiteral(resourceName: "bicid"),#imageLiteral(resourceName: "bicic")]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let yellow : UIColor = UIColor( red: 255.0/255.0, green: 216.0/255.0, blue:0, alpha: 1.0)
        vistaAmarillo.layer.masksToBounds = true
        vistaAmarillo.layer.borderColor = yellow.cgColor
        vistaAmarillo.layer.borderWidth = 3.0
        vistaAmarillo.layer.cornerRadius = 15.0

        aceptarButton.layer.masksToBounds = true
        aceptarButton.layer.cornerRadius = 10.0
    }
    
    @IBAction func aceptarAction(_ sender: Any) {
    }
    
    @IBAction func addPhotosAction(_ sender: Any) {
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagenes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bici", for: indexPath) as! celdaBiciCollectionViewCell
        
        cell.biciImage.image = imagenes[indexPath.row]        
        
        return cell
    }
    
    @IBAction func closeWindow(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
