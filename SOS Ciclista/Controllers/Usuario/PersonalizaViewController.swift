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
    let imagenes = [#imageLiteral(resourceName: "bicib"),#imageLiteral(resourceName: "bicia"),#imageLiteral(resourceName: "bicid"),#imageLiteral(resourceName: "bicic"),#imageLiteral(resourceName: "bicie"),#imageLiteral(resourceName: "bicif")]
    var selected : [UIImage]! = [UIImage(named: "bicia")!,UIImage(named: "bicia")!,UIImage(named: "bicia")!,UIImage(named: "bicia")!]

    var ancho : CGFloat!
    var alto : CGFloat!
    var flag = false

    let name = Notification.Name("biciIcon")
    
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
        
        let name = UserDefaults.standard.string(forKey: "nombre")
        if name != nil{
            nameText.text = name
        }
        let serie = UserDefaults.standard.string(forKey: "serie")
        if serie != nil{
            serieText.text = serie
        }
        let desc = UserDefaults.standard.string(forKey: "desc")
        if desc != nil{
            detailsText.text = desc
        }
        
        addToolBar(textField: nameText)
        addToolBar(textField: serieText)
        addToolBar(textField: detailsText)
    }
    
    override func donePressed() {
        view.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if flag{
            flag = false
            performSegue(withIdentifier: "fotos", sender: selected)
        }
        let indexbici = UserDefaults.standard.integer(forKey: "bici")

        bicisCollection.selectItem(at: IndexPath(item: indexbici, section: 0), animated: true, scrollPosition: .centeredHorizontally)
    }
    
    @IBAction func aceptarAction(_ sender: Any) {
        //antes de cerrar...guardo datos
        UserDefaults.standard.set(detailsText.text!, forKey: "desc")
        UserDefaults.standard.set(serieText.text!, forKey: "serie")
        UserDefaults.standard.set(nameText.text!, forKey: "nombre")
        
        let Fromlogin = UserDefaults.standard.string(forKey: "from")
        
        NotificationCenter.default.post(name: name, object: nil)

        if Fromlogin != nil{
            if Fromlogin == "login" {
                UserDefaults.standard.set("null", forKey: "from")
                self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
                
            }else if Fromlogin == "register"{
                UserDefaults.standard.set("null", forKey: "from")
                self.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
            }else{
                dismiss(animated: true, completion: nil)
            }
        }else{
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func addPhotosAction(_ sender: Any) {

        let fotos = UserDefaults.standard.string(forKey: "fotos")
        
        if fotos == "1"{
            //photos saved, launch same images
            let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].path
            
            let name = "bici"
            for index in 0...3 {
                let complete = path.appending("/\(name)_\(index).png")
                if FileManager.default.fileExists(atPath: complete){
                    selected[index] = UIImage(contentsOfFile: complete)!
                }else{
                    selected[index] = UIImage(named: "bicia")!
                }
            }
            
            performSegue(withIdentifier: "fotos", sender: selected)
        }else{
            let vc = BSImagePickerViewController()
            vc.maxNumberOfSelections = 4
            bs_presentImagePickerController(vc,animated: true,
            select: { (asset: PHAsset) -> Void in
                
            }, deselect: { (asset: PHAsset) -> Void in
                // User deselected an assets.
                // Do something, cancel upload?
            }, cancel: { (assets: [PHAsset]) -> Void in
                // User cancelled. And this where the assets currently selected.
                
            }, finish: { (assets: [PHAsset]) -> Void in
                // User finished with these assets
                //self.dismiss(animated: true, completion: nil)
                var ii = 0
                assets.forEach { (asset) in
                    self.selected[ii]=(self.getAssetThumbnail(asset: asset))
                    ii += 1
                }
                self.flag = true

            }, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagenes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bici", for: indexPath) as! celdaBiciCollectionViewCell
        
        cell.biciImage.image = imagenes[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        UserDefaults.standard.set(indexPath.row, forKey: "bici")
        
        NotificationCenter.default.post(name: name, object: nil)
    }
    
    @IBAction func closeWindow(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func masTardeAction(_ sender: Any) {
    }
    
    func getAssetThumbnail(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.isSynchronous = true
        manager.requestImage(for: asset, targetSize: CGSize(width: 150, height:  150), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
            thumbnail = result!
        })
        return UIImage(data: thumbnail.jpeg(.low)!)!
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fotos"{
            let vc = segue.destination as! PhotosBiciViewController
            vc.selected = sender as? [UIImage]
        }
        
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}
