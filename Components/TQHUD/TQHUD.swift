//
//  TQHUD.swift
//  PingAnTong_WenZhou
//
//  Created by 胡志辉 on 2018/1/15.
//  Copyright © 2018年 maomao. All rights reserved.
//

import UIKit

enum TQHUDType:Int {
    case wait = 0//只有转圈加载
    case waitWithText//转圈下面加文字
    case info //显示提示信息，带图片
    case success//成功样式
    case fail//错误样式
    case remind//提示信息，纯文本
}

class TQHUD: NSObject {
    
    //MARK:-加载
    class func hudWait() {
        SwiftProgressHUD.showWait()
    }
    ///加载并附有文字
    class func hudWait(text:String?){
        let str = text
        if str != nil {
            SwiftProgressHUD.showWait(text: str!)
        }
        
        
    }
    //MARK:-显示文字的样式
    class func hudSubTitle(text:String?) {
        let str = text
        if str != nil {
            SwiftProgressHUD.showInfo(str!, autoClear: true, autoClearTime: Int(1))
        }
        
    }
    //MARK:-成功样式
   @objc class func hudSuccess(text:String?){
        SwiftProgressHUD.hideAllHUD()
    let str = text
    if str != nil {
        SwiftProgressHUD.showSuccess(str!, autoClear: true, autoClearTime: Int(1))
    }
    
    }
    //MARK:-错误样式
    class func hudFaid(text:String?){
        SwiftProgressHUD.hideAllHUD()
        let str = text
        if str != nil {
            SwiftProgressHUD.showFail(str!, autoClear: true, autoClearTime: Int(1))
        }
        
    }
    //MARK:-错误提示（比如密码不一致）
    class func hudRemind(text:String?){
        SwiftProgressHUD.hideAllHUD()
        let str = text
        if str != nil {
           SwiftProgressHUD.showOnlyText(str!)
        }
        
    }
    //MARK:-隐藏
    @objc class func hide() {
        SwiftProgressHUD.hideAllHUD()
    }
}
