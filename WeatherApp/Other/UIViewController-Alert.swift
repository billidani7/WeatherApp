//
//  UIViewController-Alert.swift
//  WeatherApp
//
//  Created by Vasilis Daningelis on 30/6/20.
//  Copyright © 2020 Vasilis Daningelis. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func presentAlert(withTitle title:String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
}
