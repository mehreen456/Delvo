
//
//  ApiParsing.swift
//  Delvo
//
//  Created by Apple on 13/02/2017.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit
import Alamofire
import RxSwift
import RxCocoa

class ApiParsing: NSObject {
    
    var PlaceArray: [SearchResult] = []
    let authorization = "Basic NDlhMmRiZTExN2E0NDdjZWFmYjhiOTZiNTIwMTE2ZTY6ZDYzODQ0YjU2MDE3NDI4NjlhODQwNzRhYWZmNGNiNjY="
    let contentType = "application/json"
    let placeOrderUrl =  "http://178.62.30.18:3004/api/v1/delivery_requests"
    let autoComplete = "https://maps.googleapis.com/maps/api/place/autocomplete/json"
    let googlePlace = "https://maps.googleapis.com/maps/api/place/details/json"
    let GooglePlacesApi = "AIzaSyBsWLDDGbaaf042Y0yr1zktCbR4BrEWTFk"
    let UserAuthApi = "http://138.197.112.122/consumer_api/v1/auth/login"
    let UserSignUpApi = "http://138.197.112.122/consumer_api/v1/signup"
    let verifyPinApi = "http://138.197.112.122/consumer_api/v1/verify_pin"
    let resendPinApi = "http://138.197.112.122/consumer_api/v1/resend_pin"
    
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
                        Success(true)
                        self.SaveOrders(data: params)
                    }
                        
                    else{
                        
                        let Message = meta["message"]
                        failure(Message as! String)}
                }
        }
    }
    
    func VerifyUser(phone:String,password:String , Success:@escaping (String) -> (),failure: @escaping (String,Int) -> () ,Failure: @escaping (NSError) -> ()){
        
        let params = self.UserInfo(Phone: phone, Password: password)
        
        let headers: HTTPHeaders = [
            
            "Content-Type":contentType,
            "Authorization":authorization
        ]
        
        Alamofire.request(UserAuthApi, method: .post, parameters: params as? Parameters , encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                
                if response.result.error != nil
                {
                    Failure(response.result.error! as NSError)}
        
                if let result = response.result.value {
                    let status = response.response?.statusCode
                    let json = result as! NSDictionary
                    if response.response?.statusCode == 200 {
                        
                        let SMessage = json["auth_token"] as! String
                        Success(SMessage)
                    }
                    else{
                        
                        let EMessage = json["message"] as! String
                        failure(EMessage,status!)
                    }
                }
        }
    }
    
    func ResendPin(phone:String,password:String , Success:@escaping (String) -> (),failure: @escaping (String) -> () ,Failure: @escaping (NSError) -> ()){
        
        let params = self.HiddenInfo(Phone: phone, Password: password)
        
        let headers: HTTPHeaders = [
            
            "Content-Type":contentType,
            "Authorization":authorization
        ]
        
        Alamofire.request(resendPinApi, method: .post, parameters: params as? Parameters , encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                
                if response.result.error != nil
                {
                    Failure(response.result.error! as NSError)}
                
                if let result = response.result.value {
                    let status = response.response?.statusCode
                    let json = result as! NSDictionary
                    if status == 200 {
                        
                        let SMessage = json["message"] as! String
                        Success(SMessage)
                    }
                    else{
                        
                        let EMessage = json["message"] as! String
                        failure(EMessage)
                    }
                }
        }
    }
    
    func VerifyPin(phone:String,password:String ,pin:String, Success:@escaping (String,String) -> (),failure: @escaping (String) -> () ,Failure: @escaping (NSError) -> ()){
        
        let params = self.VerifyPin(phone: phone, password: password,pin:pin)
        
        let headers: HTTPHeaders = [
            
            "Content-Type":contentType,
            "Authorization":authorization
        ]
        
        Alamofire.request(verifyPinApi, method: .post, parameters: params as? Parameters , encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                
                if response.result.error != nil
                {
                    Failure(response.result.error! as NSError)}
                
                if let result = response.result.value {
                    let status = response.response?.statusCode
                    let json = result as! NSDictionary
                    if status == 200 {
                        
                        let token = json["auth_token"] as! String
                        let message = json["message"] as! String
                        Success(token,message)
                    }
                    else{
                        
                        let EMessage = json["message"] as! String
                        failure(EMessage)
                    }
                }
        }
    }

    
    func UserSignUp(Name:String,Phone:String,Email:String,Password:String,Password_confirmation:String , Success:@escaping (String) -> (),failure: @escaping (String) -> () ,Failure: @escaping (NSError) -> ()){
        
        let params = self.UserSignUpInfo(name:Name,phone:Phone,email:Email,password:Password,password_confirmation:Password_confirmation)
        
        let headers: HTTPHeaders = [
            
            "Content-Type":contentType,
            "Authorization":authorization
        ]
        
        Alamofire.request(UserSignUpApi, method: .post, parameters: params as? Parameters , encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                
                if response.result.error != nil
                {
                    Failure(response.result.error! as NSError)}
                
                if let result = response.result.value {
                   
                    let json = result as! NSDictionary
                    let status = response.response?.statusCode
                    
                    if status == 201{
                        
                        let SMessage = json["message"] as! String
                        Success(SMessage)
                        
                    }
                    else{
                        let EMessage = json["message"] as! String
                        failure(EMessage)
                    }
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
    
    func SearchLocations(place: String , Success:@escaping ([SearchResult]) -> (), Failure: @escaping (NSError) -> ())    {
        
        PlaceArray.removeAll()
        print(place)
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
                    let result: SearchResult = SearchResult(place: name!,id:placeid!)
                    print(result.place)
                    self.PlaceArray.append(result)
                }
                
                Success(self.PlaceArray)
        }
    }
    
    func UserInfo(Phone:String,Password:String) -> (NSDictionary){
        
        let params = [
            
            "phone": Phone,
            "password": Password
            ] as [String : Any]
        
        return params as (NSDictionary)
    }
    
    func HiddenInfo(Phone:String,Password:String) -> (NSDictionary){
        
        let params = [
            
            "hidden_phone": Phone,
            "hidden_password": Password
            ] as [String : Any]
        
        return params as (NSDictionary)
    }

    
    func UserSignUpInfo(name:String,phone:String,email:String,password:String,password_confirmation:String) -> (NSDictionary){
        
        let params = [
            
            "name": name,
            "phone": phone,
            "email": email,
            "password": password,
            "password_confirmation": password_confirmation,
            
            ] as [String : Any]
        
        return params as (NSDictionary)
    }
    
    func VerifyPin(phone:String,password:String,pin:String) -> (NSDictionary){
        
        let params = [
            
            "hidden_phone": phone,
            "hidden_password": password,
            "pin": pin
            
            ] as [String : Any]
        
        return params as (NSDictionary)
    }

    
    func ParamsPlaceOrder(name:String,phone:String,detail:String) -> (NSDictionary){
        
        let params = [
            "name": name,
            "phone": phone,
            "pick_address": Pick_Detail.PickAddress,
            "pick_nearby": Location.PickLocation,
            "pick_lat": Location.PickLat,
            "pick_lng": Location.PickLng,
            "drop_address": Drop_Detail.DropAddress,
            "drop_nearby": Location.DropLocation,
            "drop_lat": Location.DropLat,
            "drop_lng": Location.DropLng,
            "detail": detail
            ] as [String : Any]
        
        return params as (NSDictionary)
    }
    
    func SaveOrders(data:NSDictionary){
        
        let currentDate = DateFormatter.localizedString(from: NSDate() as Date, dateStyle: .full, timeStyle:.none)
        let currentTime = DateFormatter.localizedString(from: NSDate() as Date, dateStyle: .none, timeStyle: .medium)
        let userInfo = [
            
            "pick_address":data.value(forKey: "pick_address"),
            "drop_address": data.value(forKey: "drop_address"),
            "detail": data.value(forKey:"detail"),
            "Date": currentDate,
            "Time": currentTime,
            "U_Name":data.value(forKey: "name"),
            "U_Contact":data.value(forKey: "phone")
            
        ]
        var array:[NSDictionary] = []
        
        if UserDefaults.standard.object(forKey:  "MyOrder") == nil{
            array.append(userInfo as NSDictionary)
            UserDefaults.standard.setValue(array, forKey: "MyOrder")
        }
        else{
            
            array = UserDefaults.standard.value(forKey: "MyOrder") as! [NSDictionary]
            array.append(userInfo as NSDictionary)
            UserDefaults.standard.setValue(array, forKey: "MyOrder")
        }
    }
}

