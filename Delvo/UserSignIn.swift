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

class UserSignIn: UIViewController {
    
    @IBOutlet weak var OrLabel: UILabel!
    @IBOutlet weak var UserEmail: UITextField!
    @IBOutlet weak var UserPassword: UITextField!
    @IBOutlet weak var ToastView: UIView!
    @IBOutlet weak var LoginView: UIView!
    @IBOutlet weak var LineView: UIView!
    @IBOutlet weak var FBView: UIView!
    @IBOutlet weak var EmailView: UIView!
    @IBOutlet weak var UContactView: UIView!
    let obj = OrderDescClassMethods()
    let myobj = ApiParsing()
    let DMobj = DelvoMethods()
    let FailureMsg = "Failed"
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        UserEmail.delegate = self
        UserPassword.delegate = self
        DMobj.AddGesture(controller:self)
        self.UserEmail.inputAccessoryView = obj.AddDoneButton(controller: self)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.AddLines()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewDidAppear(true)
//        self.navigationController?.navigationBar.isHidden = true
//    }
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewDidDisappear(true)
//        self.navigationController?.navigationBar.isHidden = false
//    }
    
    @IBAction func SignInButton(_ sender: Any) {
        
        if !(UserEmail.text?.isEmpty)! && !(UserPassword.text?.isEmpty)! {
           
            if !obj.validate(phoneNumber: self.UserEmail.text!) {
                self.obj.alert(message: "Invalid Phone No", controller: self)
                UContactView.addRedBorder()
                return 
            }
                
            else{
                
                UContactView.removeBorder()}
            
            myobj.VerifyUser(phone: self.UserEmail.text!, password: self.UserPassword.text!, Success: { (json) -> () in
               
                let UserToken = json
                UserDefaults.standard.setValue(UserToken, forKey: "UserToken")
                self.performSegue(withIdentifier: "SignIn", sender: self)
            }
                , failure: { (message,status) -> () in
                    if status == 422{
                     
                        UserInfo.Phone = self.UserEmail.text!
                        UserInfo.Password = self.UserPassword.text!
                        self.obj.ShowAlert(controller: self, identifier: "VerifyPin" , message: message)
                        
                    }
                    else{

                    self.obj.alert(message:message ,title: self.FailureMsg ,controller: self)}
            }
                , Failure: { (error) -> () in
                    
                    self.obj.alert(message:"Can't get respose" ,title: self.FailureMsg ,controller: self)
            })
        }
        else {
            
            self.obj.alert(message: "Please fill the fields first", controller: self)
        }
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
                print("Login Failed")
                return
            }
            
            FBSDKGraphRequest(graphPath:"/me" , parameters:["fields":"id,name,email,picture.type(large)"]).start{
                (connection,result,err) in
                
                if err != nil{
                    
                    print(err as! NSError)
                    return
                }
                
                print(result as! NSDictionary)
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
        
        self.DMobj.drawLine(startPoint: CGPoint(x:LineView.frame.origin.x + 10 , y:(LineView.frame.origin.y + LineView.frame.height/2)), endPoint: CGPoint(x:OrLabel.frame.origin.x + 15, y:(LineView.frame.origin.y + LineView.frame.height/2)), view: self.view)
        
        self.DMobj.drawLine(startPoint: CGPoint(x: OrLabel.frame.origin.x + OrLabel.frame.size.width + 35 , y:(LineView.frame.origin.y + LineView.frame.height/2)), endPoint: CGPoint(x:LineView.frame.size.width + 10 , y:(LineView.frame.origin.y + LineView.frame.height/2)), view: self.view)
        self.FBView.addBorder()
        self.LoginView.addBorder()
        self.ToastView.isHidden = true
    }
    
    func dismissKeyboard() {
        
        view.endEditing(true)
        
    }
}

extension UserSignIn : UITextFieldDelegate {
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        if textField == UserEmail{
            
            
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
