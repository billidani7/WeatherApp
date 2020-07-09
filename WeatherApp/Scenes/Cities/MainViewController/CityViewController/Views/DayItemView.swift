//
//  DayItemView.swift
//  WeatherApp
//
//  Created by Vasilis Daningelis on 3/7/20.
//  Copyright © 2020 Vasilis Daningelis. All rights reserved.
//

import UIKit

protocol DayItemViewDelegate: class {
    func didSelectDay(atIndex index: Int)
}

class DayItemView: UIView {

    var isSelected: Bool = false
    var index: Int = 0
    weak var delegate: DayItemViewDelegate?
    
    @IBOutlet weak var dateLabel: UILabelPadding!
    @IBOutlet weak var tempratureLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    
    static func instantiate(dayWeather: DayWeather, index: Int, isSelected: Bool = false) -> DayItemView {
        let view: DayItemView = initFromNib()
        view.isSelected = isSelected
        view.index = index
        view.backgroundColor = isSelected ? UIColor(white: 0.6, alpha: 0.4) : UIColor.clear
        
        let tap = UITapGestureRecognizer(target: view, action: #selector(view.handleTap(_:)))
        view.addGestureRecognizer(tap)
        if index == 0 {
            view.dayLabel.text = NSLocalizedString("today", comment: "").uppercased()
        }else{
            view.dayLabel.text = DayWeather.outputDayFormatter.string(from: dayWeather.date ?? Date()).uppercased()
            
        }
    
        view.dateLabel.text = DayWeather.outputDateFormatter.string(from: dayWeather.date ?? Date())
        
        view.tempratureLabel.text = "\(dayWeather.mintempC)° | \(dayWeather.maxtempC)°"
    
        view.weatherImageView.image = UIImage(named: dayWeather.hourlyCondition.first?.weatherCode.getSmallWeatherImageName() ?? "clear-day" )
        
        view.setSelected(isSelected)
        
        return view
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        if isSelected {
            return
        }
        setSelected(true)
        delegate?.didSelectDay(atIndex: index)
    }
    
    func setSelected(_ selected: Bool){
        isSelected = selected
        backgroundColor = isSelected ? UIColor(white: 0.6, alpha: 0.4) : UIColor.clear
        
        if isSelected {
            dayLabel.textColor = .black
            dayLabel.layer.borderWidth = 2.0
            dayLabel.layer.cornerRadius = 8
            dayLabel.backgroundColor = UIColor.white
            dayLabel.layer.borderColor = UIColor.white.cgColor
            dayLabel.layer.masksToBounds = true
            
        }else{
            dayLabel.textColor = .white
            dayLabel.layer.borderWidth = 0.0
            dayLabel.layer.cornerRadius = 0
            dayLabel.backgroundColor = UIColor.clear
            dayLabel.layer.borderColor = UIColor.clear.cgColor
            dayLabel.layer.masksToBounds = true
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
