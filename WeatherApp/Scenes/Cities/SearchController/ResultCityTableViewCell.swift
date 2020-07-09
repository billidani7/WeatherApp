//
//  ResultCityTableViewCell.swift
//  WeatherApp
//
//  Created by Vasilis Daningelis on 2/7/20.
//  Copyright © 2020 Vasilis Daningelis. All rights reserved.
//

import UIKit

class ResultCityTableViewCell: UITableViewCell, ResultCityCellView {
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var cityCountryLabel: UILabel!
    @IBOutlet weak var cityRegionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func display(city: City) {
        self.cityNameLabel.text = city.region.count > 0 ? "\(city.name), \(city.region)" : city.name
        self.cityCountryLabel.text = city.country
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
