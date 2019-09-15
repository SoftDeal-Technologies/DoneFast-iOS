//
//  CustomerPropertyTableCell.swift
//  DoneFast
//
//  Created by Ciber on 8/22/19.
//  Copyright © 2019 Ciber. All rights reserved.
//

import UIKit

class CustomerPropertyTableCell: UITableViewCell {
  @IBOutlet weak var newPropTitleLabel: UILabel!
  @IBOutlet weak var locationLabel: UILabel!
  @IBOutlet weak var propertyIdLabel: UILabel!
  @IBOutlet weak var addressLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
