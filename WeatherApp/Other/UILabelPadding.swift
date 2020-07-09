//
//  UILabelPadding.swift
//  WeatherApp
//
//  Created by Vasilis Daningelis on 4/7/20.
//  Copyright © 2020 Vasilis Daningelis. All rights reserved.
//
//  UILabelPadding.swift
//  WeatherApp
//
//  Created by Vasilis Daningelis on 4/7/20.
//  Copyright © 2020 Vasilis Daningelis. All rights reserved.
//

import UIKit

class UILabelPadding: UILabel {

    var padding = UIEdgeInsets(top: 0, left: 7, bottom: 0, right: 7)
        
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }

   override var intrinsicContentSize : CGSize {
        let superContentSize = super.intrinsicContentSize
        let width = superContentSize.width + padding.left + padding.right
        let heigth = superContentSize.height + padding.top + padding.bottom
        return CGSize(width: width, height: heigth)
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let superSizeThatFits = super.sizeThatFits(size)
        let width = superSizeThatFits.width + padding.left + padding.right
        let heigth = superSizeThatFits.height + padding.top + padding.bottom
        return CGSize(width: width, height: heigth)
    }


}


