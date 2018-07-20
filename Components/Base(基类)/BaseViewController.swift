//
//  BaseViewController.swift
//  Clue-Global
//
//  Created by 王璇 on 2017/11/17.
//  Copyright © 2017年 王璇. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 屏幕向下偏移至导航栏底部
        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        
        // 导航栏默认色
        self.navigationController?.navigationBar.barTintColor = UIColor(hex: kHighlighColor)
        
        // 导航栏文字颜色
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18), NSAttributedStringKey.foregroundColor: UIColor.white]
        
        // 设置导航栏半透明
        //self.navigationController?.navigationBar.isTranslucent = true

        // 设置导航栏背景图片
        //self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)

        // 设置导航栏阴影图片
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
}

extension BaseViewController {
    
    func creatLeftButton() {
        let leftBarBtn = UIBarButtonItem(image: UIImage(named: "左箭头"), style: .plain, target: self, action: #selector(leftButtonClick as (UIBarButtonItem) -> ()))        
        self.navigationItem.leftBarButtonItem = leftBarBtn
    }
    
    @objc func leftButtonClick(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
}
