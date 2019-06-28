//
//  LoadingViewController.swift
//  SOS Ciclista
//
//  Created by John A. Cristobal on 6/25/19.
//  Copyright © 2019 i7. All rights reserved.
//

import UIKit
import SwiftGifOrigin
import ImageIO

class LoadingViewController: UIViewController {

    @IBOutlet var vistaMain: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let jeremyGif = UIImage.gif(name: "jeremy")
        
        // A UIImageView with async loading
        //let imageView = UIImageView()
        //imageView.loadGif(name: "loadingbike")
        
        // A UIImageView with async loading from asset catalog(from iOS9)
        //let imageView = UIImageView()
        //imageView.loadGif(asset: "jeremy")
        
        /*
         let jeremyGif = UIImage.gifImageWithName("loadingbike")
        let imageView = UIImageView(image: jeremyGif)
        imageView.frame = CGRect(x: 20.0, y: 50.0, width: self.view.frame.size.width - 40, height: 150.0)
        view.addSubview(imageView)*/
        
        //vistaMain.addSubview(imageView)
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
