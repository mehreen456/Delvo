//
//  UserSignIn.swift
//  Delvo
//
//  Created by Apple on 03/04/2017.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import NVActivityIndicatorView

class UserSignIn: UIViewController  , NVActivityIndicatorViewable{
    
    @IBOutlet weak var OrLabel: UILabel!
    @IBOutlet weak var SignInButton: UIButton!
    @IBOutlet weak var UserEmail: UITextField!
    @IBOutlet weak var UserPassword: UITextField!
    @IBOutlet weak var LineView: UIView!
    @IBOutlet weak var LoaderView: UIView!
    @IBOutlet weak var EmailView: UIView!
    @IBOutlet weak var UContactView: UIView!
    @IBOutlet weak var UPasswordView: UIView!
    let obj = OrderDescClassMethods()
    let myobj = ApiParsing()
    let DMobj = DelvoMethods()
    let FailureMsg = "Failed"
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        UserEmail.delegate = self
        UserPassword.delegate = self
        DMobj.AddGesture(controller:self)
        self.LoaderView.isHidden=true
        self.UserEmail.inputAccessoryView = obj.AddDoneButton(controller: self)
        self.AddLines()
        UserPassword.isSecureTextEntry = true
        self.SignInButton.SetCorners(radius: 5)
        }
    
    @IBAction func SignInButton(_ sender: Any) {
        
        if !(UserEmail.text?.isEmpty)! && !(UserPassword.text?.isEmpty)! {
           
            if !obj.validate(phoneNumber: self.UserEmail.text!) {
                self.obj.alert(message: "Invalid Phone No", controller: self)
                UContactView.addRedBorder()
                return 
            }
                
            else{
                
                UContactView.removeBorder()}

            if (UserPassword.text?.characters.count)! < 6 {
                
                UPasswordView.addRedBorder()
                self.obj.alert(message: "Password must be atleast 6 digits long", controller: self)
            }
                
            else{
                
                UPasswordView.removeBorder()}
            
           startAnimating(CGSize(width:60 ,height:60) , message: "Verifying User ..." , messageFont: UIFont.boldSystemFont(ofSize: 17) , type:.ballClipRotatePulse , color: UIColor.white
                , backgroundColor: UIColor.clear
            )
            self.LoaderView.isHidden=false
            myobj.VerifyUser(phone: self.UserEmail.text!, password: self.UserPassword.text!, Success: { (json) -> () in
               
                let UserToken = json
                self.removeLoader()
                UserDefaults.standard.setValue(UserToken, forKey: "UserToken")
                self.getProfile(U_token: json)
                self.performSegue(withIdentifier: "SignIn", sender: self)
            }
                , failure: { (message,status) -> () in
                    
                    self.removeLoader()
                    if status == 422{
                     
                        
                        UserInfo.Phone = self.UserEmail.text!
                        UserInfo.Password = self.UserPassword.text!
                        self.obj.ShowAlert(controller: self, identifier: "VerifyPin" , message: message)
                        
                    }
                    else{
                    self.obj.alert(message:"Account does not exist." ,title: self.FailureMsg ,controller: self)}
            }
                , Failure: { (error) -> () in
                    
                    self.removeLoader()
                    self.obj.alert(message:"Can't get respose" ,title: self.FailureMsg ,controller: self)
                    
            })
        }
        else {
            
            self.obj.alert(message: "Please fill the fields first", controller: self)
        }
    }
    
    func removeLoader(){
        
        self.stopAnimating()
        self.LoaderView.isHidden=true
    }

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if identifier == "SignIn"{
            return false
        }
        return true
    }
    
    @IBAction func FBSignInButton(_ sender: Any) {
        
        FBSDKLoginManager().logIn(withReadPermissions: ["email","public_profile"], from: self){
            (result,error) in
            if error != nil{
                
               self.obj.alert(message:error as! String ,title: "Faliure" ,controller: self)
                return
            }
            
            FBSDKGraphRequest(graphPath:"/me" , parameters:["fields":"id,name,email,picture.type(large)"]).start{
                (connection,result,err) in
                
                if err != nil{
                    
                    self.obj.alert(message:err as! String ,title: "Faliure" ,controller: self)
                    return
                }
                
                let info = result as! NSDictionary
                let name = info.value(forKey: "name") as? String
                var img = UIImage(named:"Profile.png")
                
                if let imageURL = info.value(forKey: "picture") as? NSDictionary {
                    let data = imageURL.value(forKey: "data") as? NSDictionary
                    let url = data?.value(forKey: "url") as? String
                    
                    if let Url = NSURL(string: url!) {
                        
                        if let imageData = NSData(contentsOf: Url as URL) {
                            let str64 = imageData.base64EncodedData(options: .lineLength64Characters)
                            let data: NSData = NSData(base64Encoded: str64 , options: .ignoreUnknownCharacters)!
                            img = UIImage(data: data as Data)
                        }
                    }
                }
                
                let storyboard = UIStoryboard(name:"Main", bundle: Bundle.main)
                let destination = storyboard.instantiateViewController(withIdentifier: "SignUp") as! UserSignUpVC
                destination.FB_Name = name!
                destination.image = img
                self.present(destination, animated: true, completion: nil)
                
            }}
    }
    
    
    func AddLines(){

        self.UContactView.SetCorners(radius:5)
        self.UPasswordView.SetCorners(radius:5)
    }
    
    func dismissKeyboard() {
        
        view.endEditing(true)
        
    }
    
    func getProfile(U_token:String){
        
        myobj.MyProfile(token: U_token , Success: { (json) -> () in
            
            if json{
                
                
            }
        }
            , failure: { (message) -> () in
                
                self.obj.alert(message:message ,title: "Faliure" ,controller: self)}
            
            , Failure: { (error) -> () in
                
               self.obj.alert(message:error.description ,title: "Faliure" ,controller: self) 
        })
    }

}

extension UserSignIn : UITextFieldDelegate {
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        if textField == UserPassword{
            
         
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == UserPassword{
            
            self.dismissKeyboard()
        }
        return true
    }
    
}
