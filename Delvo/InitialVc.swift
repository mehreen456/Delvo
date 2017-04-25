
//
//  InitialVc.swift
//  Delvo
//
//  Created by Apple on 19/04/2017.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit

class InitialVc: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        var destination = UIViewController()
       // UserDefaults.standard.removeObject(forKey: "User")
        if UserDefaults.standard.value(forKey: "UserToken") != nil{
            
            let storyboard = UIStoryboard(name:"Main", bundle: Bundle.main)
            destination = storyboard.instantiateViewController(withIdentifier: "SelectPlan") as! CollectionViewController
            
        }

        else{
            
            let storyboard = UIStoryboard(name:"Main", bundle: Bundle.main)
            destination = storyboard.instantiateViewController(withIdentifier: "SignIn") as! UserSignIn
        }
       // self.navigationController?.pushViewController(destination, animated: false)
        present(destination, animated: false, completion: nil)
        
    }

}
