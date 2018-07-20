//
//  TQAcceptView.swift
//  PingAnTong_WenZhou
//
//  Created by 王璇 on 2018/1/30.
//  Copyright © 2018年 maomao. All rights reserved.
//

import UIKit

fileprivate let buttonTag = 100

fileprivate let margin = 15
fileprivate let contentHeight = 200
fileprivate let labelWidth = 80
fileprivate let labelHeight = 40
fileprivate let textFieldHeight = 30
fileprivate let buttonWidth = 60
fileprivate let buttonHeight = 30

class TQAcceptView: UIView {
    
    // 承办人姓名
    var name: String? {
        get {
            return _textField1.text
        }
        set (newValue) {
            _textField1.text = newValue
        }
    }
    
    // 承办人联系方式
    var mobile: String? {
        get {
            return _textField2.text
        }
        set (newValue) {
            _textField2.text = newValue
        }
    }
    
    // 按钮点击回调
    var buttonClickCallBack: ((Int)->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setUpView()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGesture(_:)))
        self.addGestureRecognizer(tapGesture)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    fileprivate lazy var _maskView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black
        view.alpha = 0.4
        return view
    }()
    
    fileprivate lazy var _contentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 5
        return view
    }()
    
    fileprivate lazy var _label1: UILabel = {
        let label = UILabel()
        label.text = "承办人员："
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    fileprivate lazy var _label2: UILabel = {
        let label = UILabel()
        label.text = "联系手机："
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    fileprivate lazy var _textField1: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    fileprivate lazy var _textField2: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.keyboardType = .numberPad
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    fileprivate lazy var _button1: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("受理", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.layer.cornerRadius = 3
        button.backgroundColor = UIColor(hex: kHighlighColor)
        button.tag = buttonTag
        button.addTarget(self, action: #selector(buttonClick(_:)), for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var _button2: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("受理并办理", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.layer.cornerRadius = 3
        button.backgroundColor = UIColor(hex: kHighlighColor)
        button.tag = buttonTag + 1
        button.addTarget(self, action: #selector(buttonClick(_:)), for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var _button3: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("取消", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.layer.cornerRadius = 3
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(hex: "#E0E0E0").cgColor
        button.tag = buttonTag + 2
        button.addTarget(self, action: #selector(buttonClick(_:)), for: .touchUpInside)
        return button
    }()
}

extension TQAcceptView {
    fileprivate func setUpView() {
        self.addSubview(self._maskView)
        _maskView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        self.addSubview(self._contentView)
        _contentView.snp.makeConstraints { (make) in
            make.center.equalTo(self)
            make.left.equalTo(self).offset(margin)
            make.right.equalTo(self).offset(-margin)
            make.height.equalTo(contentHeight)
        }
        
        _contentView.addSubview(self._label1)
        _label1.snp.makeConstraints { (make) in
            make.top.equalTo(_contentView).offset(margin * 2)
            make.left.equalTo(_contentView).offset(margin)
            make.width.equalTo(labelWidth)
            make.height.equalTo(labelHeight)
        }
        
        _contentView.addSubview(self._textField1)
        _textField1.snp.makeConstraints { (make) in
            make.left.equalTo(_label1.snp.right).offset(margin)
            make.right.equalTo(_contentView).offset(-margin)
            make.height.equalTo(textFieldHeight)
            make.centerY.equalTo(_label1)
        }
        
        
        _contentView.addSubview(self._label2)
        _label2.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(_label1)
            make.top.equalTo(_label1.snp.bottom).offset(margin)
        }
        
        _contentView.addSubview(self._textField2)
        _textField2.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(_textField1)
            make.centerY.equalTo(_label2)
        }
        
        _contentView.addSubview(self._button1)
        _button1.snp.makeConstraints { (make) in
            make.left.equalTo(_label2)
            make.top.equalTo(_label2.snp.bottom).offset(margin * 2)
            make.size.equalTo(CGSize(width: buttonWidth, height: buttonHeight))
        }
        
        _contentView.addSubview(self._button2)
        _button2.snp.makeConstraints { (make) in
            make.centerX.equalTo(_contentView)
            make.top.height.equalTo(_button1)
            make.width.equalTo(buttonWidth * 2)
        }
        
        _contentView.addSubview(self._button3)
        _button3.snp.makeConstraints { (make) in
            make.right.equalTo(_contentView).offset(-margin)
            make.top.size.equalTo(_button1)
        }
    }
}

// MARK: 回调
extension TQAcceptView {
    @objc fileprivate func tapGesture(_ gesture: UIGestureRecognizer) {
        self.dismiss()
    }
    
    @objc fileprivate func buttonClick(_ sender: UIButton) {
        if sender.tag - buttonTag != 2 {
            if _textField1.text == nil || _textField1.text == "" {
                TQHUD.hudRemind(text: "请输入承办人")
                return
            }
            
            if _textField2.text == nil || _textField2.text == "" {
                TQHUD.hudRemind(text: "请输入承办人联系方式")
                return
            }
        } else {
            self.dismiss()
            return
        }
        
        if buttonClickCallBack != nil {
            buttonClickCallBack!(sender.tag - buttonTag)
            self.dismiss()
        }
    }
}

// MARK: 业务逻辑
extension TQAcceptView {
    func show() {
        let window: UIWindow? = (UIApplication.shared.delegate?.window)!
        if window != nil {
            window?.addSubview(self)
            self.snp.makeConstraints({ (make) in
                make.edges.equalTo(window!)
            })
        }
    }
    
    fileprivate func dismiss() {
        self.removeFromSuperview()
    }
}
