//
//  UserSignUpVC.swift
//  Delvo
//
//  Created by Apple on 03/04/2017.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit

class UserSignUpVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var ToastView: UIView!
    @IBOutlet weak var ProfileImage: UIImageView!
    @IBOutlet weak var U_FirstName: UITextField!
    @IBOutlet weak var U_Contact: UITextField!
    @IBOutlet weak var U_Email: UITextField!
    @IBOutlet weak var ConfirmPassword: UITextField!
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var SignUpView: UIView!
    @IBOutlet var MainView: UIView!
    @IBOutlet weak var UContactView: UIView!
    @IBOutlet weak var UConfirmPassView: UIView!
    @IBOutlet weak var UEmailView: UIView!
    @IBOutlet weak var UPasswordView: UIView!
   
    var FB_Name = ""
    var image:UIImage? = nil
    let PhoneValidationError = "Invalid PhoneNo"
    let EmailValidationError = "Invalid Email"
    let DelvoMethodObj = DelvoMethods()
    let obj = OrderDescClassMethods()
    let myobj = ApiParsing()
    var frameorigin:CGRect?
    var origin:CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ToastView.isHidden = true
        SignUpView.addBorder()
        self.ProfileImage.GetCircularImage()
        if FB_Name != "" && image != nil{
            self.U_FirstName.text = FB_Name
            self.ProfileImage.image = image
        }
        self.setDelegate()
        self.setOrigin()
        DelvoMethodObj.AddGesture(controller: self)
        self.U_Contact.inputAccessoryView = obj.AddDoneButton(controller: self)
        ConfirmPassword.isSecureTextEntry = true
        Password.isSecureTextEntry = true
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            ProfileImage.image = image
            
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return false    }
    
    
    @IBAction func SignUp(_ sender: Any) {
        
        self.view.frame.origin.y = self.origin!
        if  U_FirstName.text != "" && U_Contact.text != "" && Password.text != "" {
            
            self.CheckValidations()
            self.SendSignUpInfo()
            
        }
            
        else {
            
            DelvoMethodObj.Toast(view: self.view, ToastView: self.ToastView, message:"Please fill the fields first")
        }
    }
    
    @IBAction func CameraButton(_ sender: Any) {
        
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        image.allowsEditing = false
        self.present(image,animated: true)
        
    }
    
//    func SaveUserInfo(){
//        
//        var i:NSData = UIImagePNGRepresentation(UIImage(named:"Profile.png")!)! as NSData
//        
//        if self.ProfileImage.image != nil{
//            i = UIImagePNGRepresentation(self.ProfileImage.image!)! as NSData}
//        
//        UserInfo.Email = self.U_Email.text!
//        UserInfo.Name = self.U_FirstName.text!
//        UserInfo.Password = self.Password.text!
//        UserInfo.Phone = self.U_Contact.text!
//        UserInfo.image = i as Data
//        
//        
//    }
//    
    func setOrigin(){
        
        origin = self.view.frame.origin.y
        self.frameorigin = self.view.frame
    }
    
    func setDelegate(){
        
        self.U_Email.delegate = self
        self.U_FirstName.delegate = self
        self.U_Contact.delegate = self
        self.Password.delegate = self
        self.ConfirmPassword.delegate = self
    }
    
    func dismissKeyboard() {
        
        view.endEditing(true)
        self.view.frame.origin.y = origin!
    }
    @IBAction func GoBack(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func CheckValidations(){
        
        if !obj.isValidEmail(email: self.U_Email.text!) {
            self.obj.alert(message: EmailValidationError, controller: self)
            UEmailView.addRedBorder()
            return
        }
            
        else{
            
            UEmailView.removeBorder()}
        
        if !obj.validate(phoneNumber: self.U_Contact.text!) {
            self.obj.alert(message: PhoneValidationError, controller: self)
            UContactView.addRedBorder()
            return
        }
            
        else{
            
            UContactView.removeBorder()}
        
        if (Password.text?.characters.count)! < 6 {
            
            UPasswordView.addRedBorder()
            self.obj.alert(message: "Password must be atleast 6 digits long", controller: self)
        }
        else{
            
            UPasswordView.removeBorder()}
        
        if ConfirmPassword.text != Password.text {
            self.obj.alert(message: "Password doesn't match", controller: self)
            UConfirmPassView.addRedBorder()
            return
        }
        else{
            
            UConfirmPassView.removeBorder()}
        
    }
    
    func SendSignUpInfo(){
        
        myobj.UserSignUp(Name: U_FirstName.text!, Phone: U_Contact.text!, Email: U_Email.text!, Password:  Password.text!, Password_confirmation: ConfirmPassword.text!, Success: { (message) -> () in
            
         //   self.SaveUserInfo()
            self.obj.ShowAlert(controller: self, identifier: "EnterPin", message: message)
        }
            , failure: { (message) -> () in
                
                self.obj.alert(message:message ,title: "Failed" ,controller: self)
        }
            , Failure: { (error) -> () in
                
                self.obj.alert(message:"Internet connection failed." ,title: "Failed" ,controller: self)
        })
    }
    
}

extension UserSignUpVC: UITextFieldDelegate{
    
    // Mark ~ Textfiels Delegate Methods
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == self.U_Contact {
            
            self.view.frame.origin.y = self.origin! - 70
        }
        
        if textField == self.Password {
            
            self.view.frame.origin.y = self.origin! - 100
        }
        
        if textField == self.ConfirmPassword {
            
            self.view.frame.origin.y = self.origin! - 130
        }
        
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        self.view.frame.origin.y = self.origin!
        return true
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.view.endEditing(true)
        return true
    }
    
    
    
}



