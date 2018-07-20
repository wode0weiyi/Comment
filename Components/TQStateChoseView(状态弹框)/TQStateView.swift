//
//  TQEventStateChooseView.swift
//  PingAnTong_WenZhou
//
//  Created by 王璇 on 2017/12/26.
//  Copyright © 2017年 maomao. All rights reserved.
//

import UIKit

fileprivate let margin = 3
fileprivate let imageWidth = 12
fileprivate let imageHeight = 6
fileprivate let labelHeight = 40

fileprivate let fontSize: CGFloat = 14

class TQStateView: UIView {
    
    // 当前选中indx
    var selectedIndex = 0
    
    // 点击回调
    var chooseCallBack: ((Int, NSDictionary) -> ())?
    
    fileprivate lazy var _textLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: fontSize)
        return label
    }()
    
    fileprivate lazy var _arrowImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "下拉"))
        return imageView
    }()
    
    fileprivate lazy var _chooseView: TQStateChooseView = {
        let chooseView = TQStateChooseView()
        chooseView.frame = CGRect(x: 0, y: 0, width: 100, height: 44)
        chooseView.chooseCallBack = { [weak self](index, item) in
            self?.model = item
            if self?.chooseCallBack != nil {
                self?.selectedIndex = index
                self?.chooseCallBack!(index, item)
            }
        }
        return chooseView
    }()
    
    // 当前选中项
    fileprivate var _model: NSDictionary?
    var model: NSDictionary? {
        get {
            return _model
        }
        set (newValue) {
            _model = newValue
            
            self.updateContentView()
        }
    }
    
    // 传递数据源
    var dataArray: [NSDictionary]? {
        get {
            return self._chooseView.dataArray
        }
        set (newValue) {
            self._chooseView.dataArray = newValue
            
            self.model = newValue?[0]
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setUpView()
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
}

extension TQStateView {
    fileprivate func setUpView() {
        self.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGesture(_:)))
        self.addGestureRecognizer(tapGesture)
        
        self.addSubview(self._textLabel)
        _textLabel.snp.makeConstraints { (make) in
            make.left.top.bottom.equalTo(self)
            make.height.equalTo(labelHeight)
        }
        
        self.addSubview(self._arrowImageView)
        _arrowImageView.snp.makeConstraints { (make) in
            make.left.equalTo(_textLabel.snp.right).offset(margin)
            make.centerY.equalTo(self)
            make.size.equalTo(CGSize(width: imageWidth, height: imageHeight))
            make.right.equalTo(self)
        }
    }
    
    fileprivate func updateContentView() {
        let text = _model?["title"] as? NSString
        let size = text?.boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: fontSize)], context: nil).size
        
        _textLabel.text = text as String?
        
        if size != nil {
            _textLabel.snp.remakeConstraints { (make) in
                make.left.top.bottom.equalTo(self)
                make.height.equalTo(labelHeight)
                make.width.equalTo(ceilf(Float(size!.width)))
            }
            
            self.layoutIfNeeded()
        }
    }
    
    @objc fileprivate func tapGesture(_ gesture: UIGestureRecognizer) {
        self._chooseView.show()
    }
}
