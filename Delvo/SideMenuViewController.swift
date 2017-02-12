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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func numberOfSections(in ResultsTable: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ ResultsTable: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ ResultsTable: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = MenuTable.dequeueReusableCell(withIdentifier: "SideMenuCell", for: indexPath) as! SideTableCell
        
        let string = array[indexPath.row] as String
        cell.TextLabel.text = string
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    

}
