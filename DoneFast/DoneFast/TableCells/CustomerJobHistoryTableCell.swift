//
//  CustomerPropertyTableCell.swift
//  DoneFast
//
//  Created by Ciber on 8/22/19.
//  Copyright © 2019 Ciber. All rights reserved.
//

import UIKit

class CustomerJobHistoryTableCell: UITableViewCell
{
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var jobIdLabel: UILabel!
  @IBOutlet weak var requestIdLabel: UILabel!
  @IBOutlet weak var statusLabel: UILabel!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
