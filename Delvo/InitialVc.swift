
//
//  InitialVc.swift
//  Delvo
//
//  Created by Apple on 19/04/2017.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit

class InitialVc: UIViewController {

    @IBOutlet weak var StartButton: UIButton!
    @IBAction func StartButton(_ sender: Any) {
    

        var destination = UIViewController()
        
        if UserDefaults.standard.value(forKey: "UserToken") != nil{
            
            let storyboard = UIStoryboard(name:"Main", bundle: Bundle.main)
            destination = storyboard.instantiateViewController(withIdentifier: "SelectPlan") as! CollectionViewController
            
        }
            
        else{
            
            let storyboard = UIStoryboard(name:"Main", bundle: Bundle.main)
            destination = storyboard.instantiateViewController(withIdentifier: "SignIn") as! UserSignIn
        }
        self.present(destination, animated: false, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        _ = self.navigationController?.navigationBar.isHidden = true
        self.StartButton.SetCorners(radius: 20)
        self.StartButton.addBorder(color: UIColor.white.cgColor, width: 2)
  }
}
