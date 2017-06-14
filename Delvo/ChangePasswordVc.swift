//
//  ChangePasswordVc.swift
//  Delvo
//
//  Created by Apple on 23/05/2017.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit

class ChangePasswordVc: UIViewController {

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.SubView.addBorder(color:UIColor.PrimaryGrayColor().cgColor, width: 1)
        self.SubView.SetCorners(radius:10)
        self.setViews()
        self.ImageView.GetCircularImage(color: UIColor.PrimaryGrayColor().cgColor)
        let image = UIImage(named: "Password")!
        _ = self.ImageView.image = image.addImagePadding(x: 10, y: 10)
        obj.AddGesture(controller:self)
    }
    
    func setViews(){
        
        self.NewPassView.SetCorners(radius: 5)
        self.RetypePassView.SetCorners(radius: 5)
        self.OldPassView.SetCorners(radius: 5)
        self.SavePassButton.SetCorners(radius: 5)
    }
    
    @IBAction func SavePassword(_ sender: Any){
       
        if NewPass.text != RetypePass.text {
         //    self.obj.alert(message: "Password doesn't match", controller: self)
            return
        }
        
    }
    func dismissKeyboard() {
        
        view.endEditing(true)
        // self.view.frame.origin.y = origin!
    }
    
}
