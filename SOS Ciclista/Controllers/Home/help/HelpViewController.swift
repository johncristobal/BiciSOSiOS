//
//  HelpViewController.swift
//  SOS Ciclista
//
//  Created by John A. Cristobal on 6/3/19.
//  Copyright © 2019 i7. All rights reserved.
//

import UIKit
import SafariServices

class HelpViewController: UIViewController {

    @IBOutlet var helpIcon: UIButton!
    @IBOutlet var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.7)
        
        self.hero.isEnabled = true
        helpIcon.hero.id = "help"
        // Do any additional setup after loading the view.
        
        backButton.borderButton()
    }
    
    @IBAction func callAction(_ sender: Any) {
        if let url = URL(string: "tel://911"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    @IBAction func twitterUno(_ sender: UIButton) {
        
        var url = ""
        switch sender.tag {
        case 0:
            url = "https://twitter.com/C5_CDMX"
            break
        case 1:
            url = "https://twitter.com/UCS_GCDMX"
            break
        case 2:
            url = "https://twitter.com/SSP_CDMX"
            break
        case 3:
            url = "https://twitter.com/PGJDF_CDMX"
            break
        default:
            break;
        }
        
        let appURL = URL(string: url)!
        let application = UIApplication.shared
        
        if application.canOpenURL(appURL) {
            application.open(appURL)
        } else {
            
            if let url = URL(string: url) {
                let vc = SFSafariViewController(url: url)
                present(vc, animated: true)
            }
        }
    }
    
    
    @IBAction func backAction(_ sender: Any) {
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
