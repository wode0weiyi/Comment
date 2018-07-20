//
//  TQTextField.swift
//  PingAnTong_WenZhou
//
//  Created by 胡志辉 on 2018/1/15.
//  Copyright © 2018年 maomao. All rights reserved.
//

import UIKit

class TQTextField: UITextField {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var iconRect = super .leftViewRect(forBounds: bounds)
        iconRect.origin.x += 15
        return iconRect
    }
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 45, dy: 0)
    }
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 45, dy: 0)
    }
}
