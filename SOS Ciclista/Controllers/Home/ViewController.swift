//
//  ViewController.swift
//  SOS Ciclista
//
//  Created by i7 on 3/3/19.
//  Copyright © 2019 i7. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import FacebookCore
import FacebookLogin
import Firebase
import GoogleMaps

var flagReporteInicial = false

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate,GMSMapViewDelegate,MapMarkerDelegate {

    @IBOutlet var mapaGoogle: UIView!
    @IBOutlet var alertaAction: UIImageView!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var mapview: MKMapView!
    let location: CLLocationManager = CLLocationManager()
    
    var puntosArray : [MKAnnotation] = []
    var talleres : [Taller] = []
    var reportes : [Report] = []
    var reportIdS : [String] = []
    var bikers : [Biker] = []
    var hashMapMarker: [String : Bicipin] = [:]

    var lastlocation : CLLocation? = nil
    
    var mapView : GMSMapView? = nil
    private var infoWindow = MapMarkerCustom()
    fileprivate var locationMarker : GMSMarker? = GMSMarker()
    
    let name = Notification.Name("gracias")
    let nameNot = Notification.Name("closeSesion")
    let namelog = Notification.Name("loggin")

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.infoWindow = loadNiB()
        
        //mapview.register(Bicipinview.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)

        flagLocation = true
        setMenu()
        setLocation()
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(abrirAlerta))
        alertaAction.isUserInteractionEnabled = true
        alertaAction.addGestureRecognizer(gesture)
        
        print("viewdidload viewcontroller")
        
        NotificationCenter.default.addObserver(self, selector: #selector(showThanks), name: name, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(borrarReportesMapa), name: nameNot, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateMapa), name: namelog, object: nil)

    }
    
    @objc func showThanks(){
        self.performSegue(withIdentifier: "gracias", sender: nil)
    }
    
    @objc func borrarReportesMapa(){
        self.mapView?.clear()
        getTalleres()
    }
    
    @objc func updateMapa(){
        let reportado = UserDefaults.standard.string(forKey: "sesion")        
        if reportado != nil{
            if reportado == "1"{
                //recupero reportes
                listenerReports()
                //recupero otros cilista
                listenerBikers()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        print("appear again")
        
        /*if mapaListo{
            let enviado = UserDefaults.standard.string(forKey: "enviado")
            if enviado != "1"{
                initListenerBikeOnce()
            }
        }*/
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("adios wiil diseppear")
        let bici = UserDefaults.standard.string(forKey: "keySelf")
        if bici != nil{
            
            UserDefaults.standard.set("null", forKey: "keySelf")
            UserDefaults.standard.set("null", forKey: "enviado")

            print("null everything")

            let ref = Database.database().reference()
            let thisUsersGamesRef = ref.child("bikers")
            thisUsersGamesRef.child(bici!).removeValue()
        }else{
            print("no hay bici")
            //punto.title = "SOS Ciclista"
        }
        
        //guardamos latitud y longitud antes de salir, por si hace reporte en la otra ventana...
        
    }
    
    @objc func abrirAlerta(){
        //cehcamos si sesion...si no que inicie sesion
        let sesion = UserDefaults.standard.string(forKey: "sesion")
        if sesion != nil{
            if sesion == "1"{
                performSegue(withIdentifier: "alertas", sender: lastlocation)
            }
            else{
                alertaIniciarSesion()
            }
        }else{
            alertaIniciarSesion()
        }
    }
    
    func alertaIniciarSesion(){

        flagReporteInicial = true
        performSegue(withIdentifier: "loginPush", sender: nil)
    }
    
    func setLocation(){
        location.delegate = self
        location.requestWhenInUseAuthorization()
        location.startUpdatingLocation()
        location.desiredAccuracy = kCLLocationAccuracyBest
        location.distanceFilter = 2
        
        /*
        mapview.delegate = self
        mapview.showsUserLocation = true*/
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 14.0)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView!.center = self.view.center
        mapView!.isMyLocationEnabled = true
        mapView?.delegate = self
        
        do {
            // Set the map style by passing the URL of the local file.
            if let styleURL = Bundle.main.url(forResource: "style_json", withExtension: "json") {
                mapView!.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                NSLog("Unable to find style_json.json")
            }
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
        
        self.mapaGoogle.addSubview(mapView!)
    }
    
    func setMenu(){
        if self.revealViewController() != nil {
            
            self.revealViewController().rearViewRevealWidth = self.view.frame.width - 64
            menuButton.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    func imageWithImage(image:UIImage, newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func getTalleres(){
        DataManager.shared.getTalleres(api: "") { (datos) in
            
            self.talleres = datos
            
            datos.forEach({ (taller) in

                let coordinates = taller.coordinates.split(separator: ",")
                let long = coordinates[0]
                let lat = coordinates[1]
                let coordinate = CLLocationCoordinate2D(latitude: Double(lat)!, longitude: Double(long)!)
                
                //Ahora con googleMaps
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: Double(lat)!, longitude: Double(long)!)
                marker.title = taller.name
                marker.snippet = "Da click para ver ruta..."
                marker.userData = "taller"
                marker.icon = self.imageWithImage(image: UIImage(named: "iconomapa")!, newSize: CGSize(width: 20.0, height: 20.0))
                
                    //[self image:marker.icon scaledToSize:CGSizeMake(3.0f, 3.0f)] // UIImage(named: "iconomapa")
                marker.map = self.mapView
                
                let punto = Bicipin()
                punto.pinCustomImageName = "iconomapa"
                punto.coordinate = coordinate
                punto.title = taller.name
                punto.subtitle = taller.description
                
                /*let pinAnnotationView = MKPinAnnotationView(annotation: punto, reuseIdentifier: "pin")
                self.mapview.addAnnotation(pinAnnotationView.annotation!)*/
                
                /*
                /*let punto = Bicipin(title: taller.name, locationName: taller.description, discipline: "Sculpture", coordinate: coordinate)*/

                let punto = MKPointAnnotation()
                punto.title = taller.name
                //punto.subtitle = taller.description
                //let coordinates = taller.coordinates.split(separator: ",")
                //let long = coordinates[0]
                //let lat = coordinates[1]
                punto.coordinate = CLLocationCoordinate2D(latitude: Double(lat)!, longitude: Double(long)!)*/

                self.puntosArray.append(punto)
                
                //self.mapview.addAnnotations([punto])
            })
        }
    }
    
    func listenerBikers(){
        
        var ref: DatabaseReference!
        ref = Database.database().reference().child("bikers")
        ref.observe(.value, with: { (data) in
            
            self.bikers.removeAll()
            var newIds : [String] = []
            
            var keySelf = UserDefaults.standard.string(forKey: "keySelf")
            if keySelf != nil{
                print(keySelf!)
            }else{
                keySelf = "null"
            }
            
            for child in data.children {
                let snap = child as! DataSnapshot
                let datos = snap.value as! [String: Any]
                let id = datos["id"] as! String
                let name = datos["name"] as! String
                let bici = datos["bici"] as! Int
                let latitud = datos["latitud"] as! Double
                let longitude = datos["longitude"] as! Double
                
                self.bikers.append(Biker(id: id, name: name, bici: bici, latitud: latitud, longitude: longitude))
            }
            
            self.bikers.forEach({ (biker) in
                
                newIds.append(biker.id)
                
                if !self.reportIdS.contains(biker.id)
                {
                    self.reportIdS.append(biker.id)
                
                    //if biker.id != keySelf && keySelf != "null"{
                    
                    let punto = Bicipin()
                    var bici = ""
                    switch biker.bici{
                        case 0:bici = "bicia"; break;
                        case 1:bici = "bicib"; break;
                        case 2:bici = "bicic"; break;
                        case 3:bici = "bicid"; break;
                        case 4:bici = "bicie"; break;
                        case 5:bici = "bicif"; break;
                        default: break
                    }
                    punto.pinCustomImageName = bici
                    punto.title = biker.name
                    
                    punto.coordinate = CLLocationCoordinate2D(latitude: biker.latitud, longitude: biker.longitude)
                     
                     //let pinAnnotationView = MKPinAnnotationView(annotation: punto, reuseIdentifier: "pin")
                     //self.mapview.addAnnotation(pinAnnotationView.annotation!)
                    
                    let marker = GMSMarker()
                    marker.position = CLLocationCoordinate2D(latitude: biker.latitud, longitude: biker.longitude)
                    marker.title = biker.name
                    //marker.snippet = taller.description
                    marker.icon = self.imageWithImage(image: UIImage(named: bici)!, newSize: CGSize(width: 65.0, height: 40.0)) //UIImage(named: bici)
                    marker.userData = "bici,\(biker.id)"
                    marker.map = self.mapView
                    
                    self.hashMapMarker[biker.id] = punto
                //}
                }
                
                //los puntos que se eliminaran
                let justids = Array(Set(self.reportIdS).subtracting(newIds))
                
                self.hashMapMarker.forEach({ (arg0) in
                    
                    let (key, value) = arg0
                    if justids.contains(key){
                        let punto = self.hashMapMarker[key]
                        self.mapview.removeAnnotation(punto!)
                        self.hashMapMarker.removeValue(forKey: key)
                        if let index = self.reportIdS.index(of: key) {
                            self.reportIdS.remove(at: index)
                        }
                        //print(self.reportIdS)
                    }
                })
            })
        }) { (error) in
            print("error bikers")
            print(error)
        }
    }
    
    func listenerReports(){
        var ref: DatabaseReference!
        ref = Database.database().reference().child("reportes")
        ref.observe(.value, with: { (data) in
            
            self.reportes.removeAll()
            //self.reportIdS.removeAll()
            var newIds : [String] = []
            
            for child in data.children {
                let snap = child as! DataSnapshot
                let datos = snap.value as! [String: Any]
                let id = datos["id"] as! String
                let name = datos["name"] as! String
                let serie = datos["serie"] as! String
                let description = datos["description"] as! String
                let tipo = datos["tipo"] as! Int
                let date = datos["date"] as! String
                let estatus = datos["estatus"] as! Int
                let fotos = datos["fotos"] as! String
                let latitud = datos["latitude"] as! Double
                let longitude = datos["longitude"] as! Double
                
                var bici = ""
                var ancho = 65.0
                var alto = 40.0
                
                switch tipo{
                    case 0:bici = "bicia"; break;
                    case 1:
                        bici = "alertafinal"
                        ancho = 50.0
                        alto = 50.0
                        break
                    case 2:
                        bici = "averiaicon"
                        ancho = 50.0
                        alto = 50.0
                        break;
                    case 3:
                        bici = "cicloviaicon"
                        ancho = 50.0
                        alto = 50.0
                        break
                    case 4:
                        bici = "apoyoicon"
                        ancho = 50.0
                        alto = 50.0
                    break
                    default: break
                }
                
                //self.reportes.append(Report(id: id, name: name, bici: bici, latitud: latitud, longitude: longitude))
                
                /*let date = datos["date"] as! String
                let description = datos["description"] as! String
                let estatus = datos["estatus"] as! Int
                let serie = datos["serie"] as! String
                
                var fotos = ""
                if datos["fotos"] != nil{
                    fotos = datos["fotos"] as! String
                }*/
                
                //self.reportes.append(Report(id: id, name: name, serie: serie, description: description, estatus: estatus, date: date, fotos: fotos))
                
                let report = Report(id: id, name: name, serie: serie, description: description, estatus: estatus, date: date, fotos: fotos,tipo: tipo, latitude: latitud, longitude:longitude)
                
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: latitud, longitude: longitude)
                marker.title = name
                //marker.snippet = taller.description
                marker.icon = self.imageWithImage(image: UIImage(named: bici)!, newSize: CGSize(width: ancho, height: alto)) //UIImage(named: bici)
                marker.userData = report
                marker.map = self.mapView
            }
            
            /*self.bikers.forEach({ (biker) in
                
                newIds.append(biker.id)
                
                if !self.reportIdS.contains(biker.id)
                {
                    self.reportIdS.append(biker.id)
                    
                    //if biker.id != keySelf && keySelf != "null"{
                    
                    let punto = Bicipin()
                    var bici = ""
                    switch biker.bici{
                        case 0:bici = "bicia"; break;
                        case 1:bici = "bicib"; break;
                        case 2:bici = "bicic"; break;
                        case 3:bici = "bicid"; break;
                        case 4:bici = "bicie"; break;
                        case 5:bici = "bicif"; break;
                        default: break
                    }
                    punto.pinCustomImageName = bici
                    punto.title = biker.name
                    
                    punto.coordinate = CLLocationCoordinate2D(latitude: biker.latitud, longitude: biker.longitude)
                    
                    //let pinAnnotationView = MKPinAnnotationView(annotation: punto, reuseIdentifier: "pin")
                    //self.mapview.addAnnotation(pinAnnotationView.annotation!)
                    
                    let marker = GMSMarker()
                    marker.position = CLLocationCoordinate2D(latitude: biker.latitud, longitude: biker.longitude)
                    marker.title = biker.name
                    //marker.snippet = taller.description
                    marker.icon = self.imageWithImage(image: UIImage(named: bici)!, newSize: CGSize(width: 65.0, height: 40.0)) //UIImage(named: bici)
                    marker.userData = "bici"
                    marker.map = self.mapView
                    
                    self.hashMapMarker[biker.id] = punto
                    //}
                }
                
                //los puntos que se eliminaran
                let justids = Array(Set(self.reportIdS).subtracting(newIds))
                
                self.hashMapMarker.forEach({ (arg0) in
                    
                    let (key, value) = arg0
                    if justids.contains(key){
                        let punto = self.hashMapMarker[key]
                        self.mapview.removeAnnotation(punto!)
                        self.hashMapMarker.removeValue(forKey: key)
                        if let index = self.reportIdS.index(of: key) {
                            self.reportIdS.remove(at: index)
                        }
                        //print(self.reportIdS)
                    }
                })
            })*/
            
        }) { (error) in
            print("errorooooo")
            print(error)
        }
    }
    
    /*func initListenerBikeOnce(){
        
        //primero enviar mi bike para que este en fierbase
        //si y solo si estoy logueado
        //mando nombre, bike, ubication
        let enviado = UserDefaults.standard.string(forKey: "enviado")
        if enviado != "1"{
            
        let sesion = UserDefaults.standard.string(forKey: "sesion")
        if sesion != nil{
            if sesion == "1"{
                let long = lastlocation?.coordinate.longitude
                let lat = lastlocation?.coordinate.latitude
                var name = UserDefaults.standard.string(forKey: "nombre")
                let bici = UserDefaults.standard.integer(forKey: "bici")
                if name != nil{
                    name = ""
                }else{
                    name = "SOS Ciclista"
                }
                //enviar mi ubiaciaon al mapa
                let ref = Database.database().reference()
                let thisUsersGamesRef = ref.child("bikers").childByAutoId()
                thisUsersGamesRef.setValue(
                    [
                        "id":thisUsersGamesRef.key,
                        "name":name,
                        "bici":bici,
                        "latitud":lat,
                        "longitude":long
                    ]
                ){(error:Error?, ref:DatabaseReference) in
                    if let error = error {
                        print("Data could not be saved: \(error).")
                    } else {
                        print("Data saved successfully!")
                        UserDefaults.standard.set("1", forKey: "enviado")
                        UserDefaults.standard.set(thisUsersGamesRef.key, forKey: "keySelf")
                    }
                }
            }else{
                print(sesion!)
            }
        }
        }
    }*/
    
    func initListenerBike(){
        
        //primero enviar mi bike para que este en fierbase
        //si y solo si estoy logueado
        //mando nombre, bike, ubication
        let reportado = UserDefaults.standard.string(forKey: "sesion")
        let enviado = UserDefaults.standard.string(forKey: "enviado")
        if enviado != "1"{

        if reportado != nil{
            if reportado == "1"{

                let long = lastlocation?.coordinate.longitude
                let lat = lastlocation?.coordinate.latitude
                var name = UserDefaults.standard.string(forKey: "nombre")
                let bici = UserDefaults.standard.integer(forKey: "bici")
                if name != nil{
                    name = ""
                }else{
                    name = "SOS Ciclista"
                }
                //enviar mi ubiaciaon al mapa
                let ref = Database.database().reference()
                let thisUsersGamesRef = ref.child("bikers").childByAutoId()
                thisUsersGamesRef.setValue(
                    [
                        "id":thisUsersGamesRef.key,
                        "name":name,
                        "bici":bici,
                        "latitud":lat,
                        "longitude":long
                    ]
                ){(error:Error?, ref:DatabaseReference) in
                    if let error = error {
                        print("Data could not be saved: \(error).")
                    } else {
                        print("Data saved successfully!")
                        UserDefaults.standard.set("1", forKey: "enviado")
                        UserDefaults.standard.set(thisUsersGamesRef.key, forKey: "keySelf")
                        
                    }
                }
            }else{
                print(reportado!)
            }
        }
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        /*print(view.annotation)
        if let annotation = view.annotation as? Custompin {
            print("Your annotation title: \(annotation)");
        }*/
    }
    
    func loadNiB() -> MapMarkerCustom {
        let infoWindow = MapMarkerCustom.instanceFromNib() as! MapMarkerCustom
        return infoWindow
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        //marker.icon = [UIImage imageWithImage:imageData scale:2.0];
        //marker.icon = self.imageWithImage(image: UIImage(named: "bicia")!, newSize: CGSize(width: 70.0, height: 70.0)) //UIImage(named: bici)
        
        let userdata = marker.userData as? Report
        
        /*if (userdata?.contains("bici"))!{
            let idbiker = userdata?.split(separator: ",")[1]
            //performSegue(withIdentifier: "alertas", sender: lastlocation)
            print(idbiker!)
            return true
        }else */
        if userdata?.tipo == 1 {
            performSegue(withIdentifier: "detalleReporte", sender: userdata)
            return true

        }else if (userdata?.tipo == 2 || userdata?.tipo == 3 || userdata?.tipo == 4){
            let idreporte = userdata?.id
            print(idreporte!)
            
            locationMarker = marker
            infoWindow.removeFromSuperview()
            infoWindow = loadNiB()
            
            guard let location = locationMarker?.position else {
                print("locationMarker is nil")
                return false
            }
            
            infoWindow.spotData = userdata
            infoWindow.delegate = self //as! MapMarkerDelegate
            
            // Configure UI properties of info window
            //infoWindow.alpha = 0.9
            infoWindow.detailsView.layer.cornerRadius = 10
            //infoWindow.layer.borderWidth = 2
            //infoWindow.layer.borderColor = UIColor(named: "19E698")?.cgColor
            infoWindow.infoButton.layer.cornerRadius = infoWindow.infoButton.frame.height / 2
            
            infoWindow.addressLabel.text = userdata?.name
            infoWindow.detalleText.text = userdata?.description
            infoWindow.fechaText.text = userdata?.date
            if let descrip = userdata?.serie{
                infoWindow.serieLabel.text = "# Serie: \(descrip)"
            }

            infoWindow.center = mapView.projection.point(for: location)
            infoWindow.center.y = infoWindow.center.y - 110
            self.view.addSubview(infoWindow)
            //return false

            return true
        }
        
        return false
    }
    
    func didTapInfoButton(data: Report) {
        print(data)
        infoWindow.removeFromSuperview()
    }

    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        if (locationMarker != nil){
            guard let location = locationMarker?.position else {
                print("locationMarker is nil")
                return
            }
            infoWindow.center = mapView.projection.point(for: location)
            infoWindow.center.y = infoWindow.center.y - 110
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        infoWindow.removeFromSuperview()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            return nil
        } else {
            let reuseIdentifier = "pin"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
            
            if annotationView == nil {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
                annotationView?.canShowCallout = true
            } else {
                annotationView?.annotation = annotation
            }
            
            let customPointAnnotation = annotation as! Bicipin
            annotationView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            //annotationView!.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
            annotationView?.image = UIImage(named: customPointAnnotation.pinCustomImageName)
            
            return annotationView
            
            /*let viewFromNib = Bundle.main.loadNibNamed("customPin", owner: self, options: nil)?.first as! Custompin
            
            var annotationView: Custompin?
            let annotationIdentifier = "pin"
            
            // puntos visibles
            if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) as? Custompin {
                
                if dequeuedAnnotationView.subviews.isEmpty {
                    dequeuedAnnotationView.addSubview(viewFromNib)
                }
                annotationView = dequeuedAnnotationView
                annotationView?.annotation = annotation
                
            } else {
                // puntos no visibles
                let custompin = Custompin(annotation: annotation, reuseIdentifier: annotationIdentifier)
                custompin.addSubview(viewFromNib)
                
                // extend scope to be able to return at the end of the func
                annotationView = custompin
            }
            
            // configuramos el punto
            if let annotationView = annotationView {
                annotationView.canShowCallout = true
                
                // callout bubble
                annotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
                
                annotationView.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
                
                let customView = annotationView.subviews.first as! Custompin
                customView.frame = annotationView.frame
                customView.imageOutel.image = #imageLiteral(resourceName: "llaveicono")
                customView.id = ""
            }
            
            return annotationView*/
            
            /*guard let annotation = annotation as? Bicipin else { return nil }
            // 3
            let identifier = "marker"
            var view: MKMarkerAnnotationView
            // 4
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
                as? MKMarkerAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                // 5
                view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            }
            return view*/
        }
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let theAnnotation = view.annotation
            for (index, value) in (puntosArray.enumerated()) {
                if value === theAnnotation {
                    print("The annotation's array index is \(index)")
                    
                    let taller = talleres[index]
                    let coordinates = taller.coordinates.split(separator: ",")
                    let long = coordinates[0]
                    let lat = coordinates[1]
                    if  UIApplication.shared.canOpenURL(NSURL(string:"comgooglemaps://")! as URL) {
                        UIApplication.shared.openURL(NSURL(string:
                            "comgooglemaps://?saddr=&daddr=\(lat),\(long)&directionsmode=driving")! as URL)
                    } else {
                        NSLog("Can't use comgooglemaps://");
                    }
                }
            }
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        let long = marker.position.longitude
        let lat = marker.position.latitude
        
        if  UIApplication.shared.canOpenURL(NSURL(string:"comgooglemaps://")! as URL) {
            UIApplication.shared.openURL(NSURL(string:
                "comgooglemaps://?saddr=&daddr=\(lat),\(long)&directionsmode=driving")! as URL)
        } else {
            NSLog("Can't use comgooglemaps://");
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let loca = locations.last {
            
            lastlocation = loca
            
            if flagLocation {
                flagLocation = false

                let point: CLLocationCoordinate2D =  CLLocationCoordinate2DMake(loca.coordinate.latitude,loca.coordinate.longitude)
                let span : MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 2000.0/111000.0,longitudeDelta: 2000.0/110000.0)
                self.mapview.setRegion(MKCoordinateRegion(center: point,span: span),animated:true)
                
                let camera = GMSCameraPosition.camera(withLatitude: loca.coordinate.latitude, longitude: loca.coordinate.longitude, zoom: 15.0)
                mapView = GMSMapView.map(withFrame: mapaGoogle.frame, camera: camera)
                do {
                    // Set the map style by passing the URL of the local file.
                    if let styleURL = Bundle.main.url(forResource: "style_json", withExtension: "json") {
                        mapView!.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
                    } else {
                        NSLog("Unable to find style_json.json")
                    }
                } catch {
                    NSLog("One or more of the map styles failed to load. \(error)")
                }
                mapView?.isMyLocationEnabled = true
                mapView?.delegate = self
                
                self.mapaGoogle.addSubview(mapView!)
                //mando mi ubicaicon
                initListenerBike()
                //recuoero talleres
                getTalleres()
                let reportado = UserDefaults.standard.string(forKey: "sesion")
                
                if reportado != nil{
                    if reportado == "1"{
                        //recupero reportes
                        listenerReports()
                        //recupero otros cilista
                        listenerBikers()
                    }
                }
                
                mapaListo = true
            }
        }
    }
    
    @IBAction func showMenu(_ sender: Any) {
    }
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
        if segue.identifier == "alertas"{
            let vc = segue.destination as? AlertasViewController
            vc?.location = sender as! CLLocation
        }
        if segue.identifier == "detalleReporte"{
            let vc = segue.destination as! DetalleReporteViewController
            vc.report = sender as? Report
        }
     }
}
//AIzaSyBJ_vwj9s5s2K5br87BHbeYfXXtTK49d4Q
