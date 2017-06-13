
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
    let placeOrderUrl =  "http://138.197.112.122/consumer_api/v1/orders"
    let autoComplete = "https://maps.googleapis.com/maps/api/place/autocomplete/json"
    let googlePlace = "https://maps.googleapis.com/maps/api/place/details/json"
    let GooglePlacesApi = "AIzaSyBsWLDDGbaaf042Y0yr1zktCbR4BrEWTFk"
    let UserAuthApi = "http://138.197.112.122/consumer_api/v1/auth/login"
    let UserSignUpApi = "http://138.197.112.122/consumer_api/v1/signup"
    let verifyPinApi = "http://138.197.112.122/consumer_api/v1/verify_pin"
    let resendPinApi = "http://138.197.112.122/consumer_api/v1/resend_pin"
    let GetProfileInfoApi = "http://138.197.112.122/consumer_api/v1/my_profile"
    let COMPANY_API_KEY = "fa66dede-348e-4c14-b628-7c49d985398e"
    let myOrdersApi = "http://138.197.112.122/consumer_api/v1/orders"
    var updateProfileApi = "http://138.197.112.122/consumer_api/v1/consumers/"
    
    func PlaceOrder(token:String , Success:@escaping (String) -> (),failure: @escaping (String) -> () ,Failure: @escaping (NSError) -> ()){
        
        let params = self.PlaceOrder()
        print(params)
        let headers: HTTPHeaders = [
            
            "Content-Type":contentType,
            "Authorization":token,
            "COMPANYAPIKEY": COMPANY_API_KEY
        ]
        
        Alamofire.request(placeOrderUrl, method: .post, parameters: params as? Parameters , encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                
                if response.result.error != nil
                {
                    Failure(response.result.error! as NSError)}
                
                if let result = response.result.value {
                    
                    let json = result as! NSDictionary
                    let status = response.response?.statusCode
                    if status == 200{
                        
                        let meta = json["meta"] as! NSDictionary
                        let Message = meta["message"] as! String
                        
                        Success(Message)
                    }
                    else{
                        
                        let Message = json["message"]
                        failure(Message as! String)}
                }
        }
    }
    
    func MyProfile(token:String, Success:@escaping (Bool) -> (),failure: @escaping (String) -> () ,Failure: @escaping (NSError) -> ()){
        
        let headers: HTTPHeaders = [
            
            "Authorization":token,
            "COMPANYAPIKEY": COMPANY_API_KEY
        ]
        
        Alamofire.request(GetProfileInfoApi, method: .get, parameters: nil , encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                
                if response.result.error != nil
                {
                    Failure(response.result.error! as NSError)}
                
                if let result = response.result.value {
                    
                    let status = response.response?.statusCode
                    let json = result as! NSDictionary
                    
                    if status == 200{
                        
                        let userProfile:[String : AnyObject] = [
                            
                            "Name": json["name"] as AnyObject,
                            "Contact": json["phone"] as AnyObject,
                            "Email": json["email"] as AnyObject,
                            "User_id" : json["id"] as AnyObject
                        ]
                        
                        UserDefaults.standard.setValue(userProfile, forKey: "User")
                        Success(true)
                    }
                        
                    else{
                        
                        let Message = json["message"]
                        failure(Message as! String)}
                }
        }
    }
    
    func UpdateProfile(token:String,id:Int,name:String,email:String, Success:@escaping (Bool) -> (),failure: @escaping (String) -> () ,Failure: @escaping (NSError) -> ()){
        
        let headers: HTTPHeaders = [
            
            "Authorization":token,
            "COMPANYAPIKEY": COMPANY_API_KEY
        ]
        
        let params = [
            "name": name,
            "status": email
            ] as [String : Any]
        
        
        let api = updateProfileApi + id.description
        
        Alamofire.request(api, method: .patch, parameters: params , encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                
                if response.result.error != nil
                {
                    Failure(response.result.error! as NSError)}
                
                if let result = response.result.value {
                    
                    let status = response.response?.statusCode
                    let json = result as! NSDictionary
                    
                    if status == 200{
                        
                        let userProfile:[String : AnyObject] = [
                            
                            "Name": json["name"] as AnyObject,
                            "Contact": json["phone"] as AnyObject,
                            "Email": json["email"] as AnyObject,
                            "User_id" : json["id"] as AnyObject
                        ]
                        
                        UserDefaults.standard.setValue(userProfile, forKey: "User")
                        Success(true)
                    }
                        
                    else{
                        
                        let Message = json["message"]
                        failure(Message as! String)}
                }
        }
    }
    
    func MyOrders(token:String, Success:@escaping (Bool) -> (),failure: @escaping (String) -> () ,Failure: @escaping (NSError) -> ()){
        
        let headers: HTTPHeaders = [
            
            "Authorization":token,
            "COMPANYAPIKEY": COMPANY_API_KEY
        ]
        
        Alamofire.request(myOrdersApi, method: .get, parameters: nil , encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                
                if response.result.error != nil
                {
                    Failure(response.result.error! as NSError)}
                
                if let result = response.result.value {
                    
                    let status = response.response?.statusCode
                    let json = result as! NSDictionary
                    
                    if status == 200{
                        
                        UserDefaults.standard.setValue(self.ParseOrder(Dic:json), forKey:"MyOrder")
                        Success(true)
                        
                    }
                        
                    else{
                        
                        let Message = json["message"]
                        failure(Message as! String)}
                }
        }
    }
    
    func ParseOrder(Dic:NSDictionary) -> [[String:Dictionary<String, String>]] {
        
        let data = Dic["data"] as! NSArray
        var MyOrders = [[String:Dictionary<String, String>]]()
        for i in 0 ..< data.count{
            
            let order = data[i] as! NSDictionary
            
            let task = order["tasks"] as! NSArray
            let PickDetails = task[0] as! NSDictionary
            let DropDetails = task[1] as! NSDictionary
            let Charges = order["charges"] as! NSArray
            let booking = Charges[0] as! NSDictionary
            let delivery = Charges[1] as! NSDictionary
            let B_Amount = booking["amount"] as! NSNumber
            let D_Amount = delivery["amount"] as! NSNumber
            var dict = [String: Dictionary<String, String>]()
            
            dict["order"] = [
                "PickTime":formatTime(time:(order["pickup_time"] as! String)),
                "PickDate":order["pickup_date"] as! String,
                "DropTime":formatTime(time:(order["drop_time"] as! String)),
                "DropDate":order["pickup_date"] as! String]
            
            let P_time = PickDetails["contact"]as! String
            let D_time = DropDetails["contact"]as! String
            
            dict["PickTask"] = [
                "details":PickDetails["details"] as! String,
                "address":PickDetails["address"]as! String,
                "name":PickDetails["name"]as! String,
                "contact": P_time,
                "nearby": PickDetails["nearby"]as! String]
            
            dict["DropTask"] = [
                "details":DropDetails["details"]as! String,
                "address":DropDetails["address"]as! String,
                "name": DropDetails["name"]as! String,
                "contact": D_time ,
                "nearby": DropDetails["nearby"]as! String]
            
            dict["charges"] = [
                "B_amount": B_Amount.stringValue,
                "D_amount":D_Amount.stringValue]
            
            MyOrders.append(dict)
        }
        return MyOrders
    }
    
    func VerifyUser(phone:String,password:String , Success:@escaping (String) -> (),failure: @escaping (String,Int) -> () ,Failure: @escaping (NSError) -> ()){
        
        let params = self.UserSignIn(Phone: phone, Password: password)
        
        let headers: HTTPHeaders = [
            
            "Content-Type":contentType,
            "Authorization":authorization,
            "COMPANYAPIKEY": COMPANY_API_KEY
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
            "Authorization":authorization,
            "COMPANYAPIKEY": COMPANY_API_KEY
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
            "Authorization":authorization,
            "COMPANYAPIKEY": COMPANY_API_KEY
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
            "Authorization":authorization,
            "COMPANYAPIKEY": COMPANY_API_KEY
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
                }}
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
    
    func UserSignIn(Phone:String,Password:String) -> (NSDictionary){
        
        let num = "92" + Phone
        let params = [
            
            "phone": num,
            "password": Password
            ] as [String : Any]
        
        return params as (NSDictionary)
    }
    
    func HiddenInfo(Phone:String,Password:String) -> (NSDictionary){
        
        let num = "92" + Phone
        let params = [
            
            "hidden_phone": num,
            "hidden_password": Password
            ] as [String : Any]
        
        return params as (NSDictionary)
    }
    
    
    func UserSignUpInfo(name:String,phone:String,email:String,password:String,password_confirmation:String) -> (NSDictionary){
        
        let num = "92" + phone
        let params = [
            
            "name": name,
            "phone": num,
            "email": email,
            "password": password,
            "password_confirmation": password_confirmation,
            
            ] as [String : Any]
        
        return params as (NSDictionary)
    }
    
    func VerifyPin(phone:String,password:String,pin:String) -> (NSDictionary){
        
        let num = "92" + phone
        let params = [
            
            "hidden_phone": num,
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
            "pick_lat": Location.PickLat,
            "pick_lng": Location.PickLng,
            "drop_address": Drop_Detail.DropAddress,
            "drop_lat": Location.DropLat,
            "drop_lng": Location.DropLng,
            "detail": detail
            ] as [String : Any]
        
        return params as (NSDictionary)
    }
    
    func OrderKeyValue() -> (NSDictionary){
        
        
        let params = [
            "pickup_time" :  changeFormat(time:Pick_Detail.PickUpTime),
            "pickup_date" : Pick_Detail.PickUpDate,
            "drop_time":  changeFormat(time:Drop_Detail.DropTime),
            "drop_date": Drop_Detail.DropDate,
            "totaldistance": "5.2",
            "order_type": "time_critical",
            "status": 800
            ] as [String : Any]
        
        return params as (NSDictionary)
    }
    
    func task1KeyValue() -> (NSDictionary){
        
        
        let params = [
            "name": Pick_Detail.PickName,
            "contact": "+92" + Pick_Detail.PickContact,
            "task_type": "true",
            "details": Pick_Detail.PickUpDetail,
            "nearby": Pick_Detail.PickLocation,
            "lat": Location.PickLat,
            "lng": Location.PickLng,
            "address": Pick_Detail.PickAddress,
            "pay_at_pickup_amount": Pick_Detail.PickUpAmount,
            "status": "901"
            ] as [String : Any]
        
        return params as (NSDictionary)
    }
    
    func task2KeyValue() -> (NSDictionary){
        
        
        let params = [
            "name": Drop_Detail.DropName,
            "contact": "+92" + Drop_Detail.DropContact,
            "task_type": "false",
            "details": Drop_Detail.DropDetail,
            "nearby": Drop_Detail.DropLocation,
            "lat": Location.DropLat,
            "lng": Location.DropLng,
            "address": Drop_Detail.DropAddress,
            "pay_at_pickup_amount": "",
            "status": "901"
            ] as [String : Any]
        
        return params as (NSDictionary)
    }
    
    
    func PlaceOrder() -> (NSDictionary) {
        
        let params = [
            
            "order": OrderKeyValue(),
            "tasks": [
                
                task1KeyValue(),
                task2KeyValue()
            ]
            ]as [String : Any]
        
        return params as (NSDictionary)
    }
    
    func formatTime(time:String) -> String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.000Z"
        dateFormatter.timeZone = TimeZone(identifier:"GMT")
        let date = dateFormatter.date(from: time)
        
        dateFormatter.dateFormat = "h:mm a"
        let DateString = dateFormatter.string(from: date!)
        return DateString
    }
    
    func changeFormat(time:String) -> String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        let date = dateFormatter.date(from: time)
        
        dateFormatter.dateFormat = "HH:mm"
        let DateString = dateFormatter.string(from: date!)
        return DateString
    }
}

