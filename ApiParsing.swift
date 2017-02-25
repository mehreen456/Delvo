

//
//  ApiParsing.swift
//  Delvo
//
//  Created by Apple on 13/02/2017.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit
import Alamofire

class ApiParsing: NSObject {
    
    var PlaceArray:[(name:String,id:String)] = []
    
    let authorization = "Basic NDlhMmRiZTExN2E0NDdjZWFmYjhiOTZiNTIwMTE2ZTY6ZDYzODQ0YjU2MDE3NDI4NjlhODQwNzRhYWZmNGNiNjY="
    let contentType = "application/json"
    let placeOrderUrl =  "http://178.62.30.18:3004/api/v1/delivery_requests"
    let autoComplete = "https://maps.googleapis.com/maps/api/place/autocomplete/json"
    let googlePlace = "https://maps.googleapis.com/maps/api/place/details/json"
    let GooglePlacesApi = "AIzaSyBsWLDDGbaaf042Y0yr1zktCbR4BrEWTFk"
    
    func PlaceOrder(name:String,phone:String,detail:String , Success:@escaping (Bool) -> (),failure: @escaping (String) -> () ,Failure: @escaping (NSError) -> ()){
        
        let params = self.ParamsPlaceOrder(name: name, phone: phone, detail: detail)

        let headers: HTTPHeaders = [
            
            "Content-Type":contentType,
            "Authorization":authorization
        ]
        
        Alamofire.request(placeOrderUrl, method: .post, parameters: params as? Parameters , encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                
                if response.result.error != nil
                {
                    Failure(response.result.error! as NSError)}
                
                if let result = response.result.value {
                    
                    let json = result as! NSDictionary
                    let meta = json["meta"] as! NSDictionary
                    let status = meta["status"] as! NSInteger
                    
                    if status == 200{
                        Success(true)}
                    
                    else{
                        
                        let Message = meta["message"]
                        failure(Message as! String)}
                }
        }
    }
    
    func GetLatLng(placeID: String , Success:@escaping (NSDictionary) -> (), Failure: @escaping (NSError) -> ()){
        
        Alamofire.request(
            
            URL(string: googlePlace)!,
            method: .get,
            parameters: [
                
                "placeid": placeID,
                "key" : GooglePlacesApi 
            ])
            .validate()
            .responseJSON { (response) -> Void in
                
                guard response.result.isSuccess else {
                    Failure(response.result.error as! NSError)
                    return
                }
                
                let values = response.result.value
                Success(values as! NSDictionary)
        }
    }
    
    func SearchLocations(place: String , Success:@escaping (Array <(name:String,id:String)>) -> (), Failure: @escaping (NSError) -> ())    {
        
        PlaceArray.removeAll()
        
        Alamofire.request(
            URL(string:autoComplete)!,
            method: .get,
            parameters: [
                
                "input": place,
                "types": "geocode|establishment",
                "key" : GooglePlacesApi
            ])
            .validate()
            .responseJSON { (response) -> Void in
                
                guard response.result.isSuccess else {
                    
                    Failure(response.result.error as! NSError)
                    return
                }
                
                guard let value = response.result.value as? Dictionary<String, AnyObject> ,
                    let results = value["predictions"] as? [[String: Any]] else {
                        
                        print("Data received")
                        return
                }
                self.PlaceArray.removeAll()
                
                for i in 0 ..< results.count{
                    
                    let dic = results[i]
                    let name = dic["description"] as? String
                    let placeid = dic["place_id"] as? String
                    let tuple:(String,String) = (name! , placeid!)
                    self.PlaceArray.append(tuple)
                }
                
                Success(self.PlaceArray)
        }
    }
    
    func ParamsPlaceOrder(name:String,phone:String,detail:String) -> (NSDictionary){
        
        let params = [
            "name": name,
            "phone": phone,
            "pick_address": PickUpViewController.Pick_Address.PickAddress,
            "pick_nearby":  MapViewController.Location.PickLocation,
            "pick_lat": MapViewController.Location.PickLat,
            "pick_lng":  MapViewController.Location.PickLng,
            "drop_address": DropViewController.Drop_Address.DropAddress,
            "drop_nearby":  MapViewController.Location.DropLocation,
            "drop_lat":  MapViewController.Location.DropLat,
            "drop_lng":  MapViewController.Location.DropLng,
            "detail": detail
            ] as [String : Any]
        
        return params as (NSDictionary)
    }

}
