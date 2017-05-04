


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
            self.getProfile(U_token:token)
            UserDefaults.standard.setValue(UserToken, forKey: "UserToken")
            
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
    @IBAction func GoBack(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
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
                
                print(error)
        })
    }
}
