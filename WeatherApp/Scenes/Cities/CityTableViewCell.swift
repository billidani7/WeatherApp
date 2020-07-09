//
//  CityTableViewCell.swift
//  WeatherApp
//
//  Created by Vasilis Daningelis on 1/7/20.
//  Copyright © 2020 Vasilis Daningelis. All rights reserved.
//

import UIKit

class CityTableViewCell: UITableViewCell, CityCellView {
    
    @IBOutlet weak var cityTitleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func display(title: String) {
        cityTitleLabel.text = title
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
