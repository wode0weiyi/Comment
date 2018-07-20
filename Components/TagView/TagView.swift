//
//  TagView.swift
//  PingAnTong_WenZhou
//
//  Created by apple-2 on 2018/7/5.
//  Copyright © 2018年 maomao. All rights reserved.
//

import UIKit

fileprivate let buttonTag = 200

class TagView: UIView {

    //数据源
    fileprivate var _tagsArray:[String]?
    var tagsArray :[String] {
        get {
            if _tagsArray == nil {
                _tagsArray = [String]()
            }
            return _tagsArray!
        }
        set (newValue) {
            _tagsArray = newValue
            self.creatView()
        }
    }
    
    //高度
    var tagViewHeight:CGFloat?
    
    var tagsGestureBlock:((Int) -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setUpView(){
        self.backgroundColor = UIColor.white
//        self.addGestureRecognizer(UIGestureRecognizer(target: self, action:#selector(didClickHeader)))
    }
    
    func creatView(){
        let marginX:CGFloat = 15
        let marginY:CGFloat = 10
        let height:CGFloat = 30
        var markButton:UIButton?
        if _tagsArray != nil && (_tagsArray?.count)! > 0 {
            for (index,value) in (_tagsArray?.enumerated())!{
                let width = self.calculateLabelWidthWith(string: value, font: 16) + 20
                let tagbtn = UIButton.init(type: UIButtonType.custom)
                tagbtn.setTitle(value, for: UIControlState.normal)
                tagbtn.tag = buttonTag + index
                tagbtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
                tagbtn.setTitleColor(UIColor(hex:"#333333"), for: UIControlState.normal)
                tagbtn.layer.borderColor = UIColor(hex:"#dadada").cgColor
                tagbtn.layer.borderWidth = 1
                tagbtn.layer.cornerRadius = 1
                tagbtn.addTarget(self, action: #selector(btnClick(sender:)), for:.touchUpInside)
                if markButton == nil {
                    tagbtn.frame = CGRect(x:marginX, y:marginY, width:width, height:height)
                }else{
                    if (markButton?.frame.origin.x)! + (markButton?.frame.size.width)! + marginX + width + marginX > kSCREEN_WIDTH {
                        tagbtn.frame = CGRect(x:marginX, y:(markButton?.frame.origin.y)! + (markButton?.frame.size.height)! + marginY, width:width, height:height)
                    }else{
                        tagbtn.frame = CGRect(x:(markButton?.frame.origin.x)! + (markButton?.frame.size.width)! + marginX, y:(markButton?.frame.origin.y)!, width: width, height:height)
                        
                    }
                }
                
                markButton = tagbtn
                self.addSubview(markButton!)
            }
        }
        
        var rect = self.frame
        rect.size.height = (markButton?.frame.origin.y)! + (markButton?.frame.size.height)! + marginY
        self.frame = rect
        tagViewHeight = self.frame.size.height
    }
    
}

extension TagView {
    
    @objc func btnClick(sender:UIButton?) {
        if self.tagsGestureBlock != nil {
            self.tagsGestureBlock!((sender?.tag)! - buttonTag)
        }
    }
    
    fileprivate func calculateLabelWidthWith(string:String,font:CGFloat) -> CGFloat {
        
        let attri:Dictionary = [NSAttributedStringKey.font:UIFont.systemFont(ofSize: font)]
        let size = string.boundingRect(with: CGSize(width: kSCREEN_WIDTH, height: 10000), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes:attri , context: nil)
        
        return size.width
    }
}

