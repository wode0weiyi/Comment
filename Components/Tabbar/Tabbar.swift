//
//  File.swift
//  Clue-Global
//
//  Created by maomao on 2017/11/22.
//  Copyright © 2017年 王璇. All rights reserved.
//

import Foundation

import UIKit
import ESTabBarController_swift

enum ExampleProvider {
    
    static func customIrregularityStyle(delegate: UITabBarControllerDelegate?) -> ESTabBarController {
        let tabBarController = ESTabBarController()
        tabBarController.delegate = delegate
        tabBarController.tabBar.layer.borderWidth = 0
        tabBarController.tabBar.layer.borderColor = UIColor.black.cgColor
        tabBarController.tabBar.layer.shadowOffset = CGSize.init(width: 0, height: -2)
        tabBarController.tabBar.layer.shadowOpacity = 0.2//阴影透明度，默认0
        //layer.shadowRadius = 4
        
        tabBarController.tabBar.barTintColor = UIColor.white
        tabBarController.shouldHijackHandler = {
            tabbarController, viewController, index in
            if index == 1 {
                return true
            }
            return false
        }
        
        tabBarController.didHijackHandler = {
            [weak tabBarController] tabbarController, viewController, index in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                
                let controller = UIStoryboard(name: "TQEventStoryBoard", bundle: nil).instantiateViewController(withIdentifier: "TQEventIncreaseViewController") as! TQEventIncreaseViewController
                controller.title = "事件新增"
                controller.positionType = newIssue
                controller.eventHeaderType = 0
                controller.isPresent = true
                let nav = UINavigationController.init(rootViewController: controller)
                
                tabBarController?.present(nav, animated: true, completion: nil)
            }
        }
       
        let v1 = UIStoryboard(name: "HomeStoryboard", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController")
        let v2 = UIStoryboard(name: "TQEventStoryBoard", bundle: nil).instantiateViewController(withIdentifier: "TQEventIncreaseViewController") as! TQEventIncreaseViewController
        let v3 = UIStoryboard(name: "SettingStoryboard", bundle: nil).instantiateViewController(withIdentifier: "SettingViewController")
        
        v1.tabBarItem = ESTabBarItem.init(ExampleIrregularityBasicContentView(), title: "工作台", image: UIImage(named: "home_normal"), selectedImage: UIImage(named: "home_selected"))
        v2.tabBarItem = ESTabBarItem.init(ExampleIrregularityContentView(), title: "发布", image: UIImage(named: "publish"), selectedImage: UIImage(named: "publish"))
        v3.tabBarItem = ESTabBarItem.init(ExampleIrregularityBasicContentView(), title: "我的", image: UIImage(named: "mine_normal"), selectedImage: UIImage(named: "mine_selected"))
        
        let n1 = UINavigationController.init(rootViewController: v1)
        let n2 = UINavigationController.init(rootViewController: v2)
        let n3 = UINavigationController.init(rootViewController: v3)
       
        
        v1.title = "工作台"
        v2.title = "新增"
        v3.title = "设置"
       
        
        tabBarController.viewControllers = [n1, n2, n3]
        return tabBarController
    }
}

