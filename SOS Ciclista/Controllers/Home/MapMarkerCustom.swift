//
//  MapMarkerCustom.swift
//  SOS Ciclista
//
//  Created by i7 on 6/17/19.
//  Copyright © 2019 i7. All rights reserved.
//

import UIKit

protocol MapMarkerDelegate: class {
    func didTapInfoButton(data: Report)
}

class MapMarkerCustom: UIView {
    
    @IBOutlet var fechaText: UILabel!
    @IBOutlet var detalleText: UILabel!
    @IBOutlet var detailsView: UIView!
    @IBOutlet var serieLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    //@IBOutlet weak var availibilityLabel: UILabel!
    //@IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var infoButton: UIButton!
    
    weak var delegate: MapMarkerDelegate?
    var spotData: Report?
    
    @IBAction func didTapInfoButton(_ sender: UIButton) {
        delegate?.didTapInfoButton(data: spotData!)
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "MapMarkerCustom", bundle: nil).instantiate(withOwner: self, options: nil).first as! UIView
    }
}
