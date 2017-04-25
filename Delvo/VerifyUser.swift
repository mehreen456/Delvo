


//
//  VerifyUser.swift
//  Delvo
//
//  Created by Apple on 21/04/2017.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit

class VerifyUser: UIViewController {

    @IBOutlet weak var PinTextField: UITextField!
    let obj = OrderDescClassMethods()
    let myobj = ApiParsing()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.PinTextField.inputAccessoryView = obj.AddDoneButton(controller: self)
    }

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return false    }

    @IBAction func Login(_ sender: Any) {
        
        myobj.VerifyPin( phone: UserInfo.Phone, password: UserInfo.Password, pin: self.PinTextField.text!, Success: { (token,message) -> () in
            
            let UserToken = token
            UserDefaults.standard.setValue(UserToken, forKey: "UserToken")
            
            let userProfile:[String : AnyObject] = [
                
                "Name": UserInfo.Name as AnyObject,
                "Contact": UserInfo.Phone as AnyObject,
                "Password": UserInfo.Password as AnyObject,
                "Email": UserInfo.Email as AnyObject,
                "Image": UserInfo.image as AnyObject,
                ]
            
            UserDefaults.standard.setValue(userProfile, forKey: "User")
            self.performSegue(withIdentifier: "SignUp", sender: self)
        }
            , failure: { (message) -> () in
                
                self.obj.alert(message:message ,title: "Failed" ,controller: self)
        }
            , Failure: { (error) -> () in
                
                self.obj.alert(message:"Can't get respose" ,title: "Failed" ,controller: self)
        })

    }
    @IBAction func ResendCodeButton(_ sender: Any) {
        
        myobj.ResendPin( phone: UserInfo.Phone, password: UserInfo.Password, Success: { (message) -> () in
            
             self.obj.alert(message:message ,title: "Sent" ,controller: self)
        }
            , failure: { (message) -> () in
                
                self.obj.alert(message:message ,title: "Failed" ,controller: self)
        }
            , Failure: { (error) -> () in
                
                self.obj.alert(message:"Can't get respose" ,title: "Failed" ,controller: self)
        })

    }
}
