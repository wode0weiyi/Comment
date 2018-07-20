//
//  ExampleIrregularityContentView.swift
//  ESTabBarControllerExample
//
//  Created by lihao on 2017/2/9.
//  Copyright © 2017年 Vincent Li. All rights reserved.
//

import UIKit
import CoreGraphics
import Foundation
import QuartzCore
//import pop
import ESTabBarController_swift

class ExampleIrregularityBasicContentView: ExampleBouncesContentView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        textColor = UIColor.lightGray
        highlightTextColor = UIColor.red
       // iconColor = UIColor.init(white: 255.0 / 255.0, alpha: 1.0)
        highlightIconColor = UIColor.red
        backdropColor = UIColor.white
        highlightBackdropColor = UIColor.white
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ExampleIrregularityContentView: ESTabBarItemContentView {

    // MARK: -
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = false
        
        self.imageView.layer.borderWidth = 5.0
        self.imageView.layer.borderColor = UIColor.white.cgColor
        self.imageView.layer.cornerRadius = 24
        self.imageView.backgroundColor = UIColor.clear
        
        self.insets = UIEdgeInsetsMake(-30, 0, 0, 0)
        titleLabel.textColor = textColor
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func updateDisplay() {
        imageView.image = image
        titleLabel.textColor = selected ? highlightTextColor : textColor
    }
}
