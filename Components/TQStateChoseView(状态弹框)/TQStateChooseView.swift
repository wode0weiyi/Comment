//
//  TQStateChooseView.swift
//  PingAnTong_WenZhou
//
//  Created by 王璇 on 2017/12/26.
//  Copyright © 2017年 maomao. All rights reserved.
//

import UIKit

fileprivate let labelTag        = 100
fileprivate let checkBoxTag     = 101

fileprivate let margin          = 15
fileprivate let checkBoxWidth   = 14
fileprivate let checkBoxHeight  = 9

class TQStateChooseView: UIView {
    
    // 点击回调
    var chooseCallBack: ((Int, NSDictionary) -> ())?
    
    // 选中项
    var selectedIndex: Int = 0
    
    // 数据源
    fileprivate var _dataArray: [NSDictionary]?
    var dataArray: [NSDictionary]? {
        get {
            return _dataArray
        }
        set (newValue) {
            _dataArray = newValue
        }
    }
    
    fileprivate lazy var _maskView: UIView = {
        let maskView = UIView()
        maskView.backgroundColor = UIColor.black
        maskView.alpha = 0.7
        return maskView
    }()

    fileprivate lazy var _tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.clear
        tableView.isScrollEnabled = false
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        tableView.rowHeight = 40
        return tableView
    }()
    
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

// MARK: 布局
extension TQStateChooseView {
    fileprivate func setUpView() {
        self.backgroundColor = UIColor.clear
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGesture(_:)))
        tapGesture.delegate = self
        self.addGestureRecognizer(tapGesture)

        
        self.addSubview(self._maskView)
        _maskView.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(kNavigationH)
            make.left.right.bottom.equalTo(self)
        }
        
        self.addSubview(self._tableView)
        _tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(_maskView)
        }
    }
}


// MARK: 代理
extension TQStateChooseView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _dataArray == nil ? 0 : _dataArray!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        
        var titleLabel = cell.viewWithTag(labelTag) as? UILabel
        if titleLabel == nil {
            titleLabel = UILabel()
            titleLabel!.font = UIFont.systemFont(ofSize: 14)
            titleLabel!.tag = labelTag
            
            cell.contentView.addSubview(titleLabel!)
            titleLabel!.snp.makeConstraints({ (make) in
                make.left.equalTo(cell).offset(margin)
                make.centerY.equalTo(cell)
            })
            
            let line = UIView()
            line.backgroundColor = UIColor(hex: kSeparateColor)
            
            cell.contentView.addSubview(line)
            line.snp.makeConstraints({ (make) in
                make.left.right.bottom.equalTo(cell)
                make.height.equalTo(1)
            })
        }
        
        var checkBox = cell.viewWithTag(checkBoxTag) as? UIImageView
        if checkBox == nil {
            checkBox = UIImageView(image: UIImage(named: "对勾"))
            checkBox!.tag = checkBoxTag
            
            cell.contentView.addSubview(checkBox!)
            checkBox!.snp.makeConstraints({ (make) in
                make.right.equalTo(cell).offset(-margin)
                make.centerY.equalTo(cell)
                make.size.equalTo(CGSize(width: checkBoxWidth, height: checkBoxHeight))
            })
        }
        
        cell.selectionStyle = .none
        let item = _dataArray![indexPath.row] as NSDictionary
        titleLabel!.text = item["title"] as? String
        titleLabel!.textColor = indexPath.row == selectedIndex ? UIColor(hex: kHighlighColor) : UIColor(hex: "#333333")
        checkBox!.isHidden = indexPath.row != selectedIndex
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        tableView.reloadData()
        
        if chooseCallBack != nil {
            chooseCallBack!(indexPath.row, _dataArray![indexPath.row])
        }
        
        self.dismiss()
    }
}

extension TQStateChooseView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if NSStringFromClass((touch.view?.classForCoder)!) == "UITableViewCellContentView" {
            return false
        }
        return true
    }
}

extension TQStateChooseView {
    @objc fileprivate func tapGesture(_ gesture: UIGestureRecognizer) {
        self.dismiss()
    }
}

// MARK: 业务方法
extension TQStateChooseView {
    func show() {
        let window: UIWindow? = (UIApplication.shared.delegate?.window)!
        if window != nil {
            window?.addSubview(self)
            self.snp.makeConstraints({ (make) in
                make.edges.equalTo(window!)
            })
        }
    }
    
    func dismiss() {
        self.removeFromSuperview()
    }
}
