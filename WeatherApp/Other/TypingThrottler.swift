//
//  TypingThrottler.swift
//  WeatherApp
//
//  Created by Vasilis Daningelis on 2/7/20.
//  Copyright © 2020 Vasilis Daningelis. All rights reserved.
//

import Foundation

final class TypingThrottler {
    
    typealias Handler = (String) -> Void
    
    let interval: TimeInterval
    
    let handler: Handler
    
    // `handler` will only be called after the user has stopped typing for `interval` seconds
    init(interval: TimeInterval = 0.3, handler: @escaping Handler) {
        self.interval = interval
        self.handler = handler
    }
    
    private var workItem: DispatchWorkItem?
    
    //Call this every time the text changes in a text field
    func handleTyping(with text: String) {
        
        // Cancel the currently pending item
        workItem?.cancel()
        
        // Wrap our request in a work item
        workItem = DispatchWorkItem { [weak self] in
            self?.handler(text)
        }
        
        if let workItem = self.workItem {
            DispatchQueue.main.asyncAfter(deadline: .now() + interval, execute: workItem)
        }
    }
}
