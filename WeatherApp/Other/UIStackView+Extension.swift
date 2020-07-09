//
//  UIStackView+Extension.swift
//  WeatherApp
//
//  Created by Vasilis Daningelis on 3/7/20.
//  Copyright © 2020 Vasilis Daningelis. All rights reserved.
//

import UIKit

extension UIStackView {

    func addBackground(color: UIColor) {
        let subview = UIView(frame: bounds)
        subview.backgroundColor = color
        subview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subview, at: 0)
    }

}
