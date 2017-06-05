//
//  MapViewController.swift
//  Delvo
//
//  Created by Apple on 12/02/2017.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class MapViewController: UIViewController ,GMSMapViewDelegate,Address,CLLocationManagerDelegate{
    
    @IBOutlet weak var Pointer: UIImageView!
    @IBOutlet weak var MapView: GMSMapView!
    
    var placesClient: GMSPlacesClient!
    var controller:String = "PickUpVc"
    var locationManager = CLLocationManager()
    var didFindMyLocation = false
    var appDelegate = AppDelegate()
    let GeocodingObj = Geocoding()
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
        self.setLocationManager()
        self.setMapView()
        notification()
    }
   
    // Mark ~ LocationManagerDelegates
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status:  CLAuthorizationStatus) {
        
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            MapView.isMyLocationEnabled = true
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        var lastLat = locations.last?.coordinate.latitude
        var lastLng = locations.last?.coordinate.longitude

        if Pick_Detail.PickLocation != "" && controller == "PickUpVc"{
            
           lastLat = Location.PickLat
           lastLng = Location.PickLng
            
        }
        
        if Drop_Detail.DropLocation != "" && controller == "DropVc"{
            
            lastLat = Location.DropLat
            lastLng = Location.DropLng
            
        }
    
        self.GetMap(a: lastLat!, b: lastLng!)
        let camera = GMSCameraPosition.camera(withLatitude: lastLat!, longitude: lastLng!, zoom: 17.0)
        self.MapView?.animate(to: camera)
        self.locationManager.stopUpdatingLocation()
    }
    
    // Mark ~ MapViewDelegates
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        
        MapView.camera=position
        MapView.isMyLocationEnabled = true
        self.getAddress(coordinates: position.target)
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        
        MapView.isMyLocationEnabled = true
        
        if(gesture){
            
            MapView.selectedMarker = nil
        }
    }
    
    // Mark ~ GetAddressFromCorrdinate
    
    func getAddress(coordinates: CLLocationCoordinate2D){
        
        GeocodingObj.getAddressFromGeocodeCoordinate(coordinate: coordinates ,controller: self.controller , success: { (success) -> () in
            
        }, failure: { (error) -> () in
           
            let errorMsg:[String: String] = ["error": error]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ShowError"), object: nil, userInfo:errorMsg)
           
        })
    }

    // Mark ~ SetMapPointerToCorrdinate
    
    func GetLatLng(lat: CLLocationDegrees, lng: CLLocationDegrees) {
        
        GetMap(a: lat, b: lng)
    }
    
    public func GetMap(a:CLLocationDegrees , b:CLLocationDegrees){
        
        let camera: GMSCameraPosition = GMSCameraPosition.camera(withLatitude: a, longitude: b, zoom: 17)
        MapView.camera = camera
        MapView.isMyLocationEnabled = true
        MapView.settings.myLocationButton=true
        MapView.settings.compassButton=true
    }
    
    // Mark ~ Class Methods
    
    func setMapView(){
        
        self.Pointer.frame=MapView.camera.accessibilityFrame
        MapView.settings.myLocationButton=true
        MapView.settings.compassButton=true
        self.MapView?.isMyLocationEnabled = true
        MapView.delegate = self
    }
    
    func setLocationManager(){
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() && CLLocationManager.authorizationStatus() != CLAuthorizationStatus.denied {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            self.locationManager.startUpdatingLocation()
            
        }else{
            
            let alertController = UIAlertController(title: "Location Permissions", message: "Enable Location Permissions for Delvo. And then press button button to get your current location.", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "Settings", style: .default, handler: { action in
               
                if let url = URL(string: "App-Prefs:root=LOCATION_SERVICES") {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url, completionHandler:nil)
                        
                    } else {
                        UIApplication.shared.openURL(url)
                }
                }})
            
            alertController.addAction(OKAction)
            let CancelAction = UIAlertAction(title: "Cancel", style: .default, handler:  { action in
                
                alertController.dismiss(animated: true, completion: nil)
            })
            alertController.addAction(CancelAction)
            self.present(alertController, animated: true, completion: nil)
            
            return
        }
    }
    
    func notification(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.CheckService(_:)), name: NSNotification.Name(rawValue:"CheckLocServices"), object: nil)}
    
    func CheckService(_ notification: NSNotification) {
        
       setLocationManager()
    }
}
