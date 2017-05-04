//
//  CollectionViewController.swift
//  Delvo
//
//  Created by Apple on 10/04/2017.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CollectionViewController: UIViewController , UICollectionViewDelegateFlowLayout {
  
    @IBOutlet weak var collectionView: UICollectionView!

    let disposeBag = DisposeBag()
    
    let Menu = Observable.just([
        
        SideMenuItems(item:"Food Items",image:UIImage(named:"food")!),
        SideMenuItems(item:"Movie Tickets",image:UIImage(named:"ticket")!),
        SideMenuItems(item:"Parcel",image:UIImage(named:"parcel")!),
        SideMenuItems(item:"Money",image:UIImage(named:"money")!),
        SideMenuItems(item:"Bills",image:UIImage(named:"bills")!),
        SideMenuItems(item:"Others",image:UIImage(named:"other")!)
        
        ])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.rx.setDelegate(self).addDisposableTo(disposeBag)
        
        Menu.asObservable().bindTo(self.collectionView.rx.items(cellIdentifier: "Cell")) {  row,menuItem,cell in
            
            if let C_cell = cell as? PlanCollectionCell{
            
            C_cell.PlanImage.image = menuItem.image
            C_cell.PlanName.text = menuItem.item
           
            }
            }.addDisposableTo(disposeBag)
        
        collectionView.rx.modelSelected(SideMenuItems.self).subscribe(onNext:{ menuItem in
        
            }).addDisposableTo(disposeBag)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let cellWidth = (width - 30) / 2
        let height = collectionView.bounds.height
        let cellheight = (height - 20) / 3
        return CGSize(width: cellWidth, height:cellheight)
    }
}
