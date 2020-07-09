//
//  CityViewController.swift
//  WeatherApp
//
//  Created by Vasilis Daningelis on 3/7/20.
//  Copyright © 2020 Vasilis Daningelis. All rights reserved.
//

import UIKit
import Lottie

class CityViewController: UIViewController, DayItemViewDelegate, HourItemViewDelegate, CityView {
    var configurator = CityConfiguratorImplementation()
    var presenter: CityPresenter!
    
    private(set) var city: City?
    private(set) var hourItemViews: [HourItemView] = []
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var fiveDaysStackView: UIStackView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tempratureLabel: UILabel!
    
    var animationView =  AnimationView()
    
    var currentSelectedHourIndex: Int = 0
    var currentSelectedDayIndex: Int = 0
    
    var dayItemViews: [DayItemView] = []
    
    class func instantiate(city: City) -> CityViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CitiesViewController") as!CityViewController
        vc.city = city
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(cityViewController: self)
        presenter.viewDidLoad()

        fiveDaysStackView.addBackground(color: UIColor(white: 0.5, alpha: 0.4))
        fiveDaysStackView.axis = .horizontal
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
    
        animationView.contentMode = .scaleAspectFill
        animationView.backgroundBehavior = .pauseAndRestore
        animationView.loopMode = .loop
        view.addSubview(animationView)
        
        animationView.bottomAnchor.constraint(equalTo: tempratureLabel.topAnchor, constant: 0).isActive = true
        animationView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        animationView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        animationView.heightAnchor.constraint(equalToConstant: 200).isActive = true
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
        animationView.play()
    }
    
    override func viewWillLayoutSubviews() {
        
        let itemsCount =  CGFloat(presenter.city.weather?.fiveDayForecast[currentSelectedDayIndex].hourlyCondition.count ?? 0)
        let itemWidth = CGFloat((UIScreen.main.bounds.width - 40) / 5)
        let spacing = CGFloat(10.0)
        
        scrollView.contentSize = CGSize(width: ((itemsCount) * (itemWidth)) + ((itemsCount - 1)  * spacing) , height: 90)
        
        let scrollToX = (CGFloat(currentSelectedHourIndex) * itemWidth) +  CGFloat((currentSelectedHourIndex * 10))
        scrollView.scrollRectToVisible(CGRect(x: scrollToX, y: 0, width: self.scrollView.frame.size.width, height: self.scrollView.frame.size.height), animated: true)
    }
    
    func setupDayViews() {
        for i in 0..<(presenter.city.weather?.fiveDayForecast.count ?? 0) {
            let dayWeather = presenter.city.weather!.fiveDayForecast[i]
            let view = DayItemView.instantiate(dayWeather: dayWeather, index: i, isSelected: i == 0 ? true : false)
            view.delegate = self
            
            //dayItemViews.append(view)
            fiveDaysStackView.addArrangedSubview(view)
        }
    }
    
    func updateTempratureLabel() {
        let temp = presenter.city.weather!.fiveDayForecast[currentSelectedDayIndex].hourlyCondition[currentSelectedHourIndex].tempC
        tempratureLabel.text = "\(temp)°"
        
        let isDayTime = presenter.city.weather!.fiveDayForecast[currentSelectedDayIndex]
                                    .hourlyCondition[currentSelectedHourIndex]
                                    .isDayTime
        
        let animationName = presenter.city.weather!.fiveDayForecast[currentSelectedDayIndex]
                                    .hourlyCondition[currentSelectedHourIndex]
                                    .weatherCode
                                    .getWeatherAnimationName(isDayTime: isDayTime)
        
        
        
        animationView.animation = Animation.named(animationName)
        animationView.play()
    }
    
    func setupHourlyForecastScrollView() {
        
        scrollView.subviews.forEach {
            $0.removeFromSuperview()
        }
        hourItemViews.removeAll()
        
        self.scrollView.backgroundColor = UIColor(white: 0.7, alpha: 0.4)
        
        let itemWidth = (UIScreen.main.bounds.width - 40)  / 5
        var i = 0
        for hourlyCondition in presenter.city.weather!.fiveDayForecast[currentSelectedDayIndex].hourlyCondition {
            
            let hourItemView = HourItemView.instantiate(hourWeather: hourlyCondition,
                                                        index: i,
                                                        isSelected: i == currentSelectedHourIndex ? true : false)
            hourItemView.delegate = self
            
            hourItemView .translatesAutoresizingMaskIntoConstraints = false
            
            self.scrollView.addSubview(hourItemView )
            hourItemView .widthAnchor.constraint(equalToConstant: itemWidth).isActive = true
            hourItemView.heightAnchor.constraint(equalToConstant: 90.0).isActive = true
            if i == 0 {
                hourItemView .leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: 0).isActive = true
            }
            
            hourItemView .leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: (CGFloat(i) * itemWidth) +  CGFloat((i * 10))).isActive = true
            i += 1
            
            hourItemViews.append(hourItemView)
            //print("dayView.leadingAnchor.constraint \(hourItemView .frame.origin.x)")
        }

    }
    
    // MARK: - DayItemViewDelegate
    
    func didSelectDay(atIndex index: Int) {
        print("didSelect = \(index)")
        
        let previousSelectedDayView = fiveDaysStackView.arrangedSubviews[currentSelectedDayIndex] as! DayItemView
        previousSelectedDayView.setSelected(false)
        
        // If the previous selection was `Today`,
        // search for the current time forecast
        if currentSelectedDayIndex == 0 {
            
            let hourlyForecast = presenter.city.weather!.fiveDayForecast[index].hourlyCondition
            let currentDate = Date()
            
            if let currentTimeIndex = hourlyForecast
                                            .firstIndex(
                                                where: {
                                                    let result = $0.dateObject.compareTimeOnly(to: currentDate)
                                                    return result == .orderedDescending
                                                }
                                            )
            {
                currentSelectedHourIndex = currentTimeIndex
                
            }
            
        }
        
        currentSelectedDayIndex = index
        
        if index == 0 { // Today
            currentSelectedHourIndex = 0 // Now
        }
        
        updateTempratureLabel()
        setupHourlyForecastScrollView()
        
    }
    
    // MARK: - HourItemViewDelegate
    
    func didSelectHour(atIndex index: Int) {
        print("didSelectHour = \(index)")
        
        guard currentSelectedHourIndex < hourItemViews.count else {
            return
        }
        let previousSelectedHourView = hourItemViews[currentSelectedHourIndex]
        previousSelectedHourView.setSelected(false)
    
        currentSelectedHourIndex = index
        
        updateTempratureLabel()
    }
    
    
    
    func refreshView() {
        setupDayViews()
        setupHourlyForecastScrollView()
        updateTempratureLabel()
    }
    
}
