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

        self.Pointer.frame=MapView.camera.accessibilityFrame
        MapView.settings.myLocationButton=false
        MapView.settings.compassButton=false
        self.MapView?.isMyLocationEnabled = true
       // GetMap(a: lat, b: long)
        MapView.delegate = self
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        if appDelegate.FirstLoad{
            MapView.addObserver(self, forKeyPath: "myLocation", options: NSKeyValueObservingOptions.new, context: nil)}

        }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if !didFindMyLocation {
            let myLocation: CLLocation = change![NSKeyValueChangeKey.newKey] as! CLLocation
            MapView.camera = GMSCameraPosition.camera(withTarget: myLocation.coordinate, zoom: 17.0)
            didFindMyLocation = true}

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
                    print(lines)
                    
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
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "GetArea"), object: nil)
                    
                    print(address)}
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
    
    override func viewWillDisappear(_ animated: Bool) {
        if self.controller == "DropVc"{//(appDelegate.FirstLoad){
            MapView.removeObserver(self, forKeyPath: "myLocation", context: nil)}
    }
}
