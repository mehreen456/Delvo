
//
//  MyProfileVc.swift
//  Delvo
//
//  Created by Apple on 06/04/2017.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import NVActivityIndicatorView

class MyProfileVc: UIViewController ,UINavigationControllerDelegate, NVActivityIndicatorViewable  {
    
    @IBOutlet weak var LoaderView: UIView!
    @IBOutlet weak var ToastView: UIView!
    @IBOutlet weak var EditProfile: UIButton!
    @IBOutlet weak var SaveButton: UIButton!
    @IBOutlet weak var CancleButton: UIButton!
    @IBOutlet weak var PassButton: UIButton!
    @IBOutlet weak var NameView: UIView!
    @IBOutlet weak var ConatctView: UIView!
    @IBOutlet weak var EmailView: UIView!
    @IBOutlet weak var UserEmail: UITextField!
    @IBOutlet weak var UserContact: UITextField!
    @IBOutlet weak var UserName: UITextField!
    
    let disposeBag = DisposeBag()
    var UserInfo:[String : AnyObject] = [ : ]
    let DMobj = DelvoMethods()
    let mobj = ApiParsing()
    let obj = OrderDescClassMethods()
    var frameorigin:CGRect?
    var origin:CGFloat?
    var U_id:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showInfo()
        self.setViews()
        self.setOrigin()
        self.setDelegates()
        self.LoaderView.isHidden=true
        DMobj.AddGesture(controller:self)
        self.IsEditable(value:false)
    }
    
    func setViews(){
        
        self.NameView.setBottomBorder()
        self.ConatctView.setBottomBorder()
        self.EmailView.setBottomBorder()
        self.CancleButton.SetCorners(radius: 5)
        self.SaveButton.SetCorners(radius: 5)
        self.PassButton.SetCorners(radius: 5)
        self.ToastView.isHidden=true
    }
    
    func setDelegates(){
        
        self.UserEmail.delegate = self
    }
    func setOrigin(){
        
        origin = self.view.frame.origin.y
        self.frameorigin = self.view.frame
    }

    func showInfo(){
        
        if UserDefaults.standard.object(forKey: "User") != nil{
            
            UserInfo = UserDefaults.standard.value(forKey: "User") as? [String : AnyObject] ?? [ : ]
            UserName.text = UserInfo["Name"] as! String?
            UserEmail.text = UserInfo["Email"] as! String?
            var contact = UserInfo["Contact"] as! String
            U_id = UserInfo["User_id"] as? Int
            contact.remove(at: contact.startIndex)
            contact.remove(at: contact.startIndex)
            UserContact.text = contact
            EmailView.removeBorder()
        }
    }
    
    func dismissKeyboard() {
        
        view.endEditing(true)
    }
    
    @IBAction func CancelButton(_ sender: Any) {
        
        self.IsEditable(value:false)
        showInfo()
    }
    
    @IBAction func SaveButton(_ sender: Any) {
       
        self.view.frame.origin.y = self.origin!
        if  UserName.text != "" && UserEmail.text != "" && UserContact.text != "" {
            
            self.CheckValidations()
            if (UserDefaults.standard.value(forKey: "UserToken")) != nil{
                let token =  UserDefaults.standard.value(forKey: "UserToken") as! String
            updateProfile(U_token:token,u_id: U_id!,U_name: self.UserName.text!,U_email: self.UserEmail.text!)
            }
        }
            
        else {
            
            DMobj.Toast(view: self.view, ToastView: self.ToastView, message:"Please fill the fields first")
        }

    }
    func CheckValidations(){
        
        if !obj.isValidEmail(email: self.UserEmail.text!) {
            self.obj.alert(message: "Invalid Email", controller: self)
            EmailView.addRedBorder()
            return
        }
            
        else{
            
            EmailView.removeBorder()}
    }
    
    @IBAction func EditButton(_ sender: Any) {
        
       self.IsEditable(value:true)
       self.UserName.becomeFirstResponder()
    }
    
    func IsEditable(value:Bool){
        
        self.EditProfile.isHidden = value
        self.UserName.isEnabled = value
        self.UserEmail.isEnabled = value
        self.PassButton.isHidden = !value
    }
    
    func updateProfile(U_token:String,u_id:Int,U_name:String,U_email:String){
        
        startAnimating(CGSize(width:60 ,height:60) , message: "Verifying User ..." , messageFont: UIFont.boldSystemFont(ofSize: 17) , type:.ballClipRotatePulse , color: UIColor.white
            , backgroundColor: UIColor.clear
        )
        self.LoaderView.isHidden=false
        
        mobj.UpdateProfile(token: U_token , id: u_id ,name:U_name,email:U_email, Success: { (json) -> () in
            
            if json{
                
                self.UserInfo["Name"] = self.UserName.text as AnyObject?
                self.UserInfo["Email"] = self.UserEmail.text as AnyObject?
                
                UserDefaults.standard.setValue(self.UserInfo, forKey: "User")
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UpdateInfo"), object: nil)

                self.removeLoader()
                self.IsEditable(value:false)
                }
        }
            , failure: { (message) -> () in
                
                self.obj.alert(message:message ,title: "Faliure" ,controller: self)
                self.removeLoader()
        }
            
            , Failure: { (error) -> () in
                
                self.obj.alert(message:error.description ,title: "Faliure" ,controller: self)
                self.removeLoader()
        })
    }
    
    func removeLoader(){
        
        self.stopAnimating()
        self.LoaderView.isHidden=true
    }
}

extension MyProfileVc: UITextFieldDelegate{
    
    // Mark ~ Textfiels Delegate Methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.view.frame.origin.y = self.origin!
        self.view.endEditing(true)
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == self.UserEmail {
            
            self.view.frame.origin.y = self.origin! - 70
        }
        
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        self.view.frame.origin.y = self.origin!
        return true
    }
}

