//
//  MyOrdersVC.swift
//  Delvo
//
//  Created by Apple on 02/03/2017.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MyOrdersVC: UIViewController ,UITableViewDelegate{

    @IBOutlet weak var MyOrderTable: UITableView!

    var cellHeight:CGFloat = 375
    var array:[NSDictionary] = []
    let obj = DelvoMethods()
    let delvoMethods = DelvoMethods()
    let disposeBag = DisposeBag()
    var dataSource = Variable<[NSDictionary]>([])
    var MyCell = UITableViewCell()
    var CellHeightsArray :[CGFloat] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = self.MyOrderTable.rx.setDelegate(self)
        if (UserDefaults.standard.value(forKey: "MyOrder")) != nil{
            array =  UserDefaults.standard.value(forKey: "MyOrder") as! [NSDictionary]
            dataSource.value =  self.array
        }
        
        
        let yourNibName = UINib(nibName: "MyOrderCell", bundle: nil)
        MyOrderTable.register(yourNibName, forCellReuseIdentifier: "OrderCell")
        self.navBar()
        
        dataSource.asObservable().bindTo(MyOrderTable.rx.items(cellIdentifier: "OrderCell")){ IndexPath,dic,C_cell in
            
               if let cell = C_cell as? MyOrderCell{
                
                cell.DropLabel.text = dic["drop_address"] as? String
                cell.PickUpLabel.text = dic["pick_address"] as? String
                cell.OrderLabel.text = dic["detail"] as? String
                cell.DateLabel.text = dic["Date"] as? String
                cell.TimeLabel.text = dic["Time"] as? String
                cell.UserName.text = dic["U_Name"] as? String
                cell.UserContact.text = dic["U_Contact"] as? String
                
                cell.DropDetail.text = dic["detail"] as? String
                cell.DropDate.text = dic["Date"] as? String
                cell.DropTime.text = dic["Time"] as? String
                cell.RecieverName.text = dic["U_Name"] as? String
                cell.RecieverContact.text = dic["U_Contact"] as? String

               
                self.cellHeight = self.obj.heightForView(text:cell.DropLabel.text!, frame:cell.DropLabel.frame,size: 13.0) + self.obj.heightForView(text:cell.PickUpLabel.text!, frame:cell.PickUpLabel.frame,size: 13.0) + self.obj.heightForView(text:cell.OrderLabel.text!, frame:cell.OrderLabel.frame,size: 13.0) + self.obj.heightForView(text:cell.DropDetail.text!, frame:cell.DropDetail.frame,size: 13.0) + 330
         
                
               self.CellHeightsArray.append(self.cellHeight)
               self.obj.AddBorder(height: self.cellHeight,view: cell.CellView)
                
            }
            }.addDisposableTo(disposeBag)
                
         self.MyOrderTable.alwaysBounceVertical = false
    }
   
    func navBar(){
        
        self.navigationController?.navigationItem.title = "My Orders"
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
//}

//extension MyOrdersVC : UITableViewDelegate {
  
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if CellHeightsArray.count > indexPath.row {
            return CellHeightsArray[indexPath.row]
        }
        
        return cellHeight
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.array.count == 0{
            return 0 }
        else {
            return 1 }
    }
    
    func numberOfSections(in MyOrderTable: UITableView) -> Int {
        return array.count
    }
    
}

