//
//  TableViewCell.swift
//  DIDA
//
//  Created by 김두리 on 2023/02/27.
//

import UIKit

struct IconTableCellModel {
    let icon: UIImage?
    let title: String?
}

class TableViewCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }

    func bind(_ model: IconTableCellModel) {
        self.iconImageView.image = model.icon
        self.contentLabel.text = model.title
    }
}
