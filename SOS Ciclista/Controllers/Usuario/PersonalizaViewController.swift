//
//  PersonalizaViewController.swift
//  SOS Ciclista
//
//  Created by John A. Cristobal on 3/14/19.
//  Copyright © 2019 i7. All rights reserved.
//

import UIKit
import MobileCoreServices
import BSImagePicker
import BSImageView
import Photos

class PersonalizaViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var aceptarButton: UIButton!
    @IBOutlet var bicisCollection: UICollectionView!
    @IBOutlet var nameText: UITextField!
    @IBOutlet var addPhotosButton: UIButton!
    @IBOutlet var serieText: UITextField!
    @IBOutlet var detailsText: UITextField!
    let picker = UIImagePickerController()

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
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addPhotosAction(_ sender: Any) {
        /*if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            
            picker.delegate = self
            picker.sourceType = .savedPhotosAlbum
            present(picker, animated: true)
        }*/
        performSegue(withIdentifier: "fotos", sender: nil)

        
    }
    
    /*func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let media = info[UIImagePickerController.InfoKey.mediaType] as! String
        self.dismiss(animated:true, completion:nil)
    }*/
    
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
    
    @IBAction func masTardeAction(_ sender: Any) {
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fotos"{
            let vc = segue.destination as! PhotosBiciViewController
            vc.assets = sender as? [PHAsset]
        }
        
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }*/
}
