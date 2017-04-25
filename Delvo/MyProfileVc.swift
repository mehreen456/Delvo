
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

class MyProfileVc: UIViewController ,UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    
    @IBOutlet weak var UserEmail: UITextField!
    @IBOutlet weak var UserContact: UITextField!
    @IBOutlet weak var UserName: UITextField!
    @IBOutlet weak var UserImg: UIImageView!
    let disposeBag = DisposeBag()
    var UserInfo:[String : AnyObject] = [ : ]
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showInfo()
        ShowImg()
        textfields()
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
       
            UserImg.image = image
            UserInfo["Image"] = UIImagePNGRepresentation(image)! as NSData
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func ShowImg(){
        
          UserImg.GetCircularImage()
    }
    
    func showInfo(){
        
        if UserDefaults.standard.object(forKey: "User") != nil{
            
            UserInfo = UserDefaults.standard.value(forKey: "User") as? [String : AnyObject] ?? [ : ]
            UserName.text = UserInfo["Name"] as! String?
            UserEmail.text = UserInfo["Email"] as! String?
            UserContact.text = UserInfo["Contact"] as! String?
            let imageData = UserInfo["Image"] as! NSData?
            self.UserImg.image = UIImage(data: imageData as! Data)
        }
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
        
    }
    
    @IBAction func SaveButton(_ sender: Any) {
        
        UserDefaults.standard.setValue(UserInfo, forKey: "User")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UpdateInfo"), object: nil)
    }
    
    @IBAction func UploadImg(_ sender: Any) {
        
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        image.allowsEditing = false
        self.present(image,animated: true)
    }
    
}
