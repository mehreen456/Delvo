//
//  MyOrdersVC.swift
//  Delvo
//
//  Created by Apple on 02/03/2017.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit

class MyOrdersVC: UIViewController ,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var MyOrderTable: UITableView!

    var cellHeight:CGFloat = 25
    var array:[NSDictionary] = []
    let obj = DelvoMethods()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let yourNibName = UINib(nibName: "MyOrderCell", bundle: nil)
        MyOrderTable.register(yourNibName, forCellReuseIdentifier: "OrderCell")
        self.MyOrderTable.alwaysBounceVertical = false
        self.navBar()
        if UserDefaults.standard.value(forKey: "MyOrder") != nil {
            
            array = UserDefaults.standard.value(forKey: "MyOrder") as! [NSDictionary]
        }
    }
   
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//      
//        let vw = UIView()
//        vw.backgroundColor = UIColor.ButtonColor()
//        return vw
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight + 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        if array.count == 0{
            return 0}
        else {
            return 1 }
    }
    
    func numberOfSections(in MyOrderTable: UITableView) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        let cell = MyOrderTable.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath) as! MyOrderCell
        
           let dic = array[indexPath.section]
           cell.DropLabel.text = dic["drop_address"] as? String
           cell.PickUpLabel.text = dic["pick_address"] as? String
           cell.OrderLabel.text = dic["detail"] as? String
           cell.TimeLabel.text = dic["Date"] as? String
    
           cellHeight = obj.heightForView(text: (cell.DropLabel?.text)!, frame:cell.DropLabel.frame) + obj.heightForView(text: (cell.PickUpLabel?.text)!, frame:cell.PickUpLabel.frame) + obj.heightForView(text: (cell.OrderLabel?.text)!, frame:cell.OrderLabel.frame) + obj.heightForView(text: (cell.TimeLabel?.text)!, frame:cell.TimeLabel.frame)
        
        return cell
    }
    
    func navBar(){
        
        self.navigationController?.navigationItem.title = "My Orders"
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
}
