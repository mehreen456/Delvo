//
//  SideMenuViewController.swift
//  Delvo
//
//  Created by Apple on 12/02/2017.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit

class SideMenuViewController: UIViewController ,UITableViewDelegate ,UITableViewDataSource {

    @IBOutlet weak var MenuTable: UITableView!
    var array = ["Home" , "My Orders" , "Profile Settings" , "SignOut"]
    let cellIdentifier = "SideMenuCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    func numberOfSections(in ResultsTable: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ ResultsTable: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ ResultsTable: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = MenuTable.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! SideTableCell
        
        let string = array[indexPath.row] as String
        cell.TextLabel.text = string
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        if array[indexPath.row] == "My Orders"{
        self.revealViewController().rightRevealToggle(animated: true)
        let storyboard = UIStoryboard(name: "MyOrders", bundle: Bundle.main)
        let destination = storyboard.instantiateViewController(withIdentifier: "Orders") as! MyOrdersVC
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.navController.pushViewController(destination, animated: true)
            
        }
    }
    

}
