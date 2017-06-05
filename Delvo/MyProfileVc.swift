
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

class MyProfileVc: UIViewController ,UINavigationControllerDelegate //,UIImagePickerControllerDelegate{
{
    
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
    let obj = DelvoMethods()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showInfo()
        textfields()
        self.setViews()
        obj.AddGesture(controller:self)
        self.UserContact.isEnabled = false
        self.UserName.isEnabled = false
        self.UserEmail.isEnabled = false
    }
    
    func setViews(){
        
        self.NameView.setBottomBorder()
        self.ConatctView.setBottomBorder()
        self.EmailView.setBottomBorder()
        self.CancleButton.SetCorners(radius: 5)
        self.SaveButton.SetCorners(radius: 5)
        self.PassButton.SetCorners(radius: 5)
    }

    
    func showInfo(){
        
        if UserDefaults.standard.object(forKey: "User") != nil{
            
            UserInfo = UserDefaults.standard.value(forKey: "User") as? [String : AnyObject] ?? [ : ]
            UserName.text = UserInfo["Name"] as! String?
            UserEmail.text = UserInfo["Email"] as! String?
            UserContact.text = UserInfo["Contact"] as! String?
         
        }
    }
    
    func dismissKeyboard() {
        
        view.endEditing(true)
    }
    
    func textfields(){
        
        self.UserName.rx.text.asObservable().subscribe(onNext: {
            text in
             self.UserInfo["Name"] = text as AnyObject?}).addDisposableTo(disposeBag)
        
        self.UserEmail.rx.text.asObservable().subscribe(onNext: {
            text in
            self.UserInfo["Email"] = text as AnyObject?}).addDisposableTo(disposeBag)
       
        self.UserContact.rx.text.asObservable().subscribe(onNext: {
            text in
            self.UserInfo["Contact"] = text as AnyObject?}).addDisposableTo(disposeBag)
    }
    
    @IBAction func CancelButton(_ sender: Any) {
        
        self.IsEditable(value:false)
        

    }
    
    @IBAction func SaveButton(_ sender: Any) {
        
        UserDefaults.standard.setValue(UserInfo, forKey: "User")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UpdateInfo"), object: nil)
        self.IsEditable(value:false)
        

    }
    
    @IBAction func EditButton(_ sender: Any) {
        
       self.IsEditable(value:true)
       self.UserName.becomeFirstResponder()

    }
    
    func IsEditable(value:Bool){
        
        self.EditProfile.isHidden = value
        self.UserContact.isEnabled = value
        self.UserName.isEnabled = value
        self.UserEmail.isEnabled = value
    }

}
