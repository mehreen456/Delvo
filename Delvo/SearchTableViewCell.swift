//
//  SearchTableViewCell.swift
//  Delvo
//
//  Created by Apple on 13/02/2017.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit
import RxSwift

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var LocationLabel: UILabel!
    var disposeBagCell:DisposeBag = DisposeBag()
    
    override func prepareForReuse() {
        disposeBagCell = DisposeBag()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
