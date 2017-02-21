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

class MapViewController: UIViewController ,GMSMapViewDelegate ,Address,CLLocationManagerDelegate{

    @IBOutlet weak var Pointer: UIImageView!
    @IBOutlet weak var MapView: GMSMapView!
    
    var placesClient: GMSPlacesClient!
    var lat: CLLocationDegrees = 24.8838999
    var long: CLLocationDegrees = 67.0546788
    var controller:String = "PickUpVc"
    var locationManager = CLLocationManager()
    var didFindMyLocation = false
    var appDelegate = AppDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        self.locationManager.delegate = self
        self.Pointer.frame=MapView.camera.accessibilityFrame
        MapView.settings.myLocationButton=false
        MapView.settings.compassButton=false
        self.MapView?.isMyLocationEnabled = true
        GetMap(a: lat, b: long)
        MapView.delegate = self
        
        }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status:  CLAuthorizationStatus) {
        
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            MapView.isMyLocationEnabled = true
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 17.0)
        self.MapView?.animate(to: camera)
        self.locationManager.stopUpdatingLocation()
    }
    
    public func GetMap(a:CLLocationDegrees , b:CLLocationDegrees){
        
        let camera: GMSCameraPosition = GMSCameraPosition.camera(withLatitude: a, longitude: b, zoom: 17)
        MapView.camera = camera
        MapView.isMyLocationEnabled = true
        MapView.settings.myLocationButton=false
        MapView.settings.compassButton=false
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        
        MapView.camera=position
        MapView.isMyLocationEnabled = true
        getAddressFromGeocodeCoordinate(coordinate: position.target)
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        
        MapView.isMyLocationEnabled = true
        
        if(gesture){
        
            MapView.selectedMarker = nil
        }
    }
    
    func getAddressFromGeocodeCoordinate(coordinate: CLLocationCoordinate2D) {
        
        let geocoder = GMSGeocoder()
        
        geocoder.reverseGeocodeCoordinate(coordinate) { response , error in
            if response != nil{
            
            if let Address = response!.firstResult() {
                let lines = Address.lines! as [String]
                    
                let address = lines.joined(separator: ",")
                if self.controller == "PickUpVc"{
                        
                    Location.PickLocation = address
                    Location.PickLat = coordinate.latitude
                    Location.PickLng = coordinate.longitude
                }
                        
                else{
                        
                    Location.DropLocation = address
                    Location.DropLat = coordinate.latitude
                    Location.DropLng = coordinate.longitude
                }
                    
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "GetArea"), object: nil)}
            }}
    }
    
    struct Location{
        
        static var PickLocation = String()
        static var PickLat = Double()
        static var PickLng = Double()
        static var DropLocation = String()
        static var DropLat = Double()
        static var DropLng = Double()
    }
    
    func GetLatLng(lat: CLLocationDegrees, lng: CLLocationDegrees) {
        
        GetMap(a: lat, b: lng)
    }
    
}
