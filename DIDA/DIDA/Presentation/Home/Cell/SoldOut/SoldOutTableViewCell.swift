//
//  SoldOutTableViewCell.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/02/18.
//

import UIKit
//Sold Out 셀
class SoldOutTableViewCell: UITableViewCell {

    
    @IBOutlet weak var weekButton: UIButton!
    
    @IBOutlet weak var oneMonthButton: UIButton!
    
    @IBOutlet weak var sixMonthsButton: UIButton!
    
    @IBOutlet weak var thisYearButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
