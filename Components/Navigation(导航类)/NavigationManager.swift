//
//  NavigationManager.swift
//  Clue-Global
//
//  Created by 王璇 on 2017/11/20.
//  Copyright © 2017年 王璇. All rights reserved.
//

import UIKit
class NavigationManager {
    
    // 获取当前显示的视图
    static func getCurrentViewController() -> UIViewController?{
        let rootController = UIApplication.shared.delegate?.window??.rootViewController
        
        if rootController?.isKind(of: UITabBarController.self) == false {
            return nil
        }
     
        let currentTabBarController: UITabBarController = rootController as! UITabBarController
        
        let currentNavigatinController: UINavigationController = currentTabBarController.selectedViewController as! UINavigationController
        return currentNavigatinController.visibleViewController
    }
    
    // 压栈操作
    static func pushViewController(controller: UIViewController) {
        let currentViewController = self.getCurrentViewController()
        currentViewController?.navigationController?.pushViewController(controller, animated: true)
    }
    
    // 出栈操作
    static func popViewController() {
        let currentViewController = self.getCurrentViewController()
        currentViewController?.navigationController?.popViewController(animated: true)
    }
}
