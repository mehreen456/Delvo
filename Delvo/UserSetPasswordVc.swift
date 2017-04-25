



//
//  UserSetPasswordVc.swift
//  Delvo
//
//  Created by Apple on 12/04/2017.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit

class UserSetPasswordVc: UIViewController {

    var UserName = ""
    var UserContact = ""
    var UserEmail = ""
    var ImageData:NSData? = nil
    let obj = OrderDescClassMethods()
    
    @IBOutlet weak var ConfirmPassword: UITextField!
    @IBOutlet weak var Password: UITextField!
  
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func DoneButton(_ sender: Any) {
       
        if ConfirmPassword.text != Password.text {
            self.obj.alert(message: "Password doesn't match", controller: self)
            return
        }
        if  UserName != "" && UserContact != "" && Password.text != "" && UserEmail != "" {
            
            let userProfile:[String : AnyObject] = [
                
                "Name": UserName as AnyObject,
                "Contact": UserContact as AnyObject,
                "Password": Password.text as AnyObject,
                "Email": UserEmail as AnyObject,
                "Image": ImageData!,
                ]
            
            UserDefaults.standard.setValue(userProfile, forKey: "User")}
        }
   }
