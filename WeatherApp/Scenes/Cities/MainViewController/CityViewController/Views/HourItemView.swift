//
//  HourItemView.swift
//  WeatherApp
//
//  Created by Vasilis Daningelis on 3/7/20.
//  Copyright © 2020 Vasilis Daningelis. All rights reserved.
//

import UIKit

protocol HourItemViewDelegate: class {
    func didSelectHour(atIndex index: Int)
}

class HourItemView: UIView {
    
    @IBOutlet weak var timeLabel: UILabelPadding!
    @IBOutlet weak var tempratureLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    
    weak var delegate: HourItemViewDelegate?
    
    var isSelected: Bool = false
    var index: Int = 0
    
    static func instantiate(hourWeather: WeatherCondition, index: Int, isSelected: Bool = false) -> HourItemView {
        let view: HourItemView = initFromNib()
        view.isSelected = isSelected
        view.index = index
        view.backgroundColor = isSelected ? UIColor(white: 0.8, alpha: 0.4) : UIColor.clear
        view.timeLabel.text = WeatherCondition.outputTimeFormatter.string(from: hourWeather.dateObject)
        view.tempratureLabel.text = hourWeather.tempC + "°"
         
        view.weatherImageView.image = UIImage(named: hourWeather.weatherCode.getSmallWeatherImageName(isDayTime: hourWeather.isDayTime) )  
        
        view.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: view, action: #selector(view.handleTap(_:)))
        view.addGestureRecognizer(tap)
        
        view.setSelected(isSelected)
        
        return view
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        if isSelected {
            return
        }
        setSelected(true)
        delegate?.didSelectHour(atIndex: index)
    }

    func setSelected(_ selected: Bool){
        isSelected = selected
        backgroundColor = isSelected ? UIColor(white: 0.6, alpha: 0.4) : UIColor.clear

        if isSelected {
            timeLabel.textColor = .black
            timeLabel.layer.borderWidth = 2.0
            timeLabel.layer.cornerRadius = 8
            timeLabel.backgroundColor = UIColor.white
            timeLabel.layer.borderColor = UIColor.white.cgColor
            timeLabel.layer.masksToBounds = true

        }else{
            timeLabel.textColor = .white
            timeLabel.layer.borderWidth = 0.0
            timeLabel.layer.cornerRadius = 0
            timeLabel.backgroundColor = UIColor.clear
            timeLabel.layer.borderColor = UIColor.clear.cgColor
            timeLabel.layer.masksToBounds = true
        }

    }
    
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
