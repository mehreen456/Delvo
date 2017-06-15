//
//  ChangePasswordVc.swift
//  Delvo
//
//  Created by Apple on 23/05/2017.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class ChangePasswordVc: UIViewController , NVActivityIndicatorViewable{

    @IBOutlet weak var LoaderView: UIView!
    @IBOutlet weak var CurrentPass: UITextField!
    @IBOutlet weak var NewPassView: UIView!
    @IBOutlet weak var RetypePassView: UIView!
    @IBOutlet weak var OldPassView: UIView!
    @IBOutlet weak var SubView: UIView!
    @IBOutlet weak var RetypePass: UITextField!
    @IBOutlet weak var NewPass: UITextField!
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var SavePassButton: UIButton!
   
    let obj = DelvoMethods()
    let myobj = ApiParsing()
    let DMobj = OrderDescClassMethods()
    var origin:CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.SubView.addBorder(color:UIColor.PrimaryGrayColor().cgColor, width: 1)
        self.SubView.SetCorners(radius:10)
        self.setViews()
        self.ImageView.GetCircularImage(color: UIColor.PrimaryGrayColor().cgColor)
        let image = UIImage(named: "Password")!
        _ = self.ImageView.image = image.addImagePadding(x: 10, y: 10)
        obj.AddGesture(controller:self)
        self.setOrigin()
        setDelegates()
        CurrentPass.isSecureTextEntry = true
        NewPass.isSecureTextEntry = true
        RetypePass.isSecureTextEntry = true
        
    }
    
    func setOrigin(){
        
        origin = self.view.frame.origin.y
    }
    
    func setDelegates(){
        
        self.CurrentPass.delegate = self
        self.NewPass.delegate = self
        self.RetypePass.delegate = self
    }

    func updatePassword(U_token:String,old_Pass:String,new_Pass:String){
        
        startAnimating(CGSize(width:60 ,height:60) , message: "Updating Password ..." , messageFont: UIFont.boldSystemFont(ofSize: 17) , type:.ballClipRotatePulse , color: UIColor.white
            , backgroundColor: UIColor.clear
        )
        self.LoaderView.isHidden=false
        
        myobj.UpdatePassword(token: U_token, oldPass: old_Pass, newPass: new_Pass,  Success: { (json) -> () in
            
            if json{
                
                self.removeLoader()
            }
        }
            , failure: { (message) -> () in
                
                self.DMobj.alert(message:message ,title: "Faliure" ,controller: self)
                self.removeLoader()
        }
            
            , Failure: { (error) -> () in
                
                self.DMobj.alert(message:error.description ,title: "Faliure" ,controller: self)
                self.removeLoader()
        })
    }
    
    func removeLoader(){
        
        self.stopAnimating()
        self.LoaderView.isHidden=true
    }

    
    func setViews(){
        
        self.NewPassView.SetCorners(radius: 5)
        self.RetypePassView.SetCorners(radius: 5)
        self.OldPassView.SetCorners(radius: 5)
        self.SavePassButton.SetCorners(radius: 5)
    }
    
    @IBAction func SavePassword(_ sender: Any){
       
        if NewPass.text != RetypePass.text {
            
            self.DMobj.alert(message: "Password doesn't match", controller: self)
            return
        }
        let u_token =  UserDefaults.standard.value(forKey: "UserToken") as! String
        self.updatePassword(U_token: u_token ,old_Pass:CurrentPass.text!,new_Pass:NewPass.text!)
        
    }
    func dismissKeyboard() {
        
        view.endEditing(true)
        //  self.view.frame.origin.y = origin!
    }
}

extension ChangePasswordVc: UITextFieldDelegate{
    
    // Mark ~ Textfiels Delegate Methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.view.frame.origin.y = self.origin!
        self.view.endEditing(true)
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == self.NewPass {
            
            self.view.frame.origin.y = self.origin! - 70
        }
        
        if textField == self.RetypePass {
            
            self.view.frame.origin.y = self.origin! - 70
        }
        
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        self.view.frame.origin.y = self.origin!
        return true
    }
}
