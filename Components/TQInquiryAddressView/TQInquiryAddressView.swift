//
//  TQInquiryAddressView.swift
//  TQInquiryAddress
//
//  Created by apple-2 on 2018/1/20.
//  Copyright © 2018年 yaoluxiang. All rights reserved.
//

import UIKit

fileprivate let ViewTag = 200

class TQInquiryAddressView: UIView {
    
    //组织机构ID,默认为人员所属组织机构
    var organizationId: Int = (UserInfoViewModel.shared.currentUser?.org?.orgId)!
    
    //数据
    var addressViewBlock:((AnyObject?) -> ())?
    
    fileprivate var dataArray:[TQHouseSiteModel]?
    
    fileprivate var hasVarifyNumber:Bool = false
    
    fileprivate lazy var _reformer: IntensivePeopleViewModel = {
        let reformer = IntensivePeopleViewModel()
        return reformer
    }()
    
    //背景框
    fileprivate lazy var _backgroundView:UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.gray.cgColor
        view.backgroundColor = UIColor.white
        return view
    }()
    
    //标题栏
    fileprivate lazy var _titleLabel:UILabel = {
        let label = UILabel()
        label.text = "查询地址"
        label.textColor = UIColor.blue
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    //分割线
    fileprivate lazy var _line1: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.blue
        return label
    }()
    
    fileprivate lazy var _line2: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.gray
        return label
    }()
    
    //搜索文字
    fileprivate lazy var _serchLabel:UILabel = {
        let label = UILabel()
        label.text = "   房屋地址:"
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    //搜索框
    fileprivate lazy var _searchView: UITextField = {
        let searchTextField = UITextField()
        searchTextField.placeholder = "点击编辑"
        return searchTextField
    }()
    
    //搜索结果列表文字
    fileprivate lazy var _listLabel:UILabel = {
        let label = UILabel()
        label.text = "房屋地址"
        label.textColor = UIColor.gray
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = NSTextAlignment.center
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.gray.cgColor
        return label
    }()
    
    //搜索结果列表
    fileprivate lazy var _tableView:UITableView = {
        let tableView = UITableView()
        tableView.layer.borderWidth = 1
        tableView.layer.borderColor = UIColor.gray.cgColor
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    //查询按钮
    fileprivate lazy var _searchButton:UIButton = {
        let button = UIButton()
        button.setTitle("查询", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.layer.borderColor = UIColor.gray.cgColor
        button.layer.borderWidth = 1
        //背景色
        
        
        button.tag = ViewTag + 0
        button.addTarget(self, action: #selector(buttonClick), for: UIControlEvents.touchUpInside)
        return button
    }()
    
    //确定按钮
    fileprivate lazy var _makeSureButton:UIButton = {
        let button = UIButton()
        button.setTitle("确认", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.gray.cgColor
        button.tag = ViewTag + 1
        button.addTarget(self, action: #selector(buttonClick), for: UIControlEvents.touchUpInside)
        return button
    }()
    
    //取消按钮
    fileprivate lazy var _cancelButton:UIButton = {
        let button = UIButton()
        button.setTitle("取消", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.gray.cgColor
        button.tag = ViewTag + 2
        button.addTarget(self, action: #selector(buttonClick), for: UIControlEvents.touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setUpViews()
    }
    
    fileprivate func setUpViews() {
        
        self.backgroundColor = UIColor.init(white: 0.5, alpha: 0.5)
        self.addSubview(_backgroundView)
        _backgroundView.addSubview(_titleLabel)
        _backgroundView.addSubview(_serchLabel)
        _backgroundView.addSubview(_searchView)
        _backgroundView.addSubview(_searchButton)
        _backgroundView.addSubview(_listLabel)
        _backgroundView.addSubview(_tableView)
        _backgroundView.addSubview(_makeSureButton)
        _backgroundView.addSubview(_cancelButton)
        _backgroundView.addSubview(_line1)
        _backgroundView.addSubview(_line2)
        
        _tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        self.layoutViews()
        //列表数据源
        //        self.loadDataList()
    }
    
}

//MARK:布局
extension TQInquiryAddressView {
    
    func layoutViews() {
        
        _backgroundView.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(15)
            make.right.equalTo(self).offset(-15)
            make.centerY.equalTo(self)
            make.height.equalTo(470)
        }
        
        _titleLabel.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(_backgroundView)
            make.height.equalTo(50)
        }
        
        _line1.snp.makeConstraints { (make) in
            make.left.right.equalTo(_backgroundView)
            make.top.equalTo(_titleLabel.snp.bottom)
            make.height.equalTo(2)
        }
        
        _serchLabel.snp.makeConstraints { (make) in
            make.left.equalTo(_backgroundView).offset(20)
            make.top.equalTo(_titleLabel.snp.bottom).offset(15)
            make.width.equalTo(90)
            make.height.equalTo(_titleLabel)
        }
        
        _searchView.snp.makeConstraints { (make) in
            make.left.equalTo(_serchLabel.snp.right).offset(15)
            make.right.equalTo(_backgroundView).offset(-15)
            make.height.equalTo(_serchLabel)
            make.centerY.equalTo(_serchLabel)
        }
        
        _line2.snp.makeConstraints { (make) in
            make.left.equalTo(_backgroundView).offset(15)
            make.right.equalTo(_backgroundView).offset(-15)
            make.top.equalTo(_serchLabel.snp.bottom)
            make.height.equalTo(0.5)
        }
        
        _searchButton.snp.makeConstraints { (make) in
            make.top.equalTo(_searchView.snp.bottom).offset(10)
            make.right.equalTo(_searchView)
            make.size.equalTo(CGSize(width: 80, height: 40))
        }
        
        _listLabel.snp.makeConstraints { (make) in
            make.top.equalTo(_searchButton.snp.bottom).offset(5)
            make.left.equalTo(_backgroundView).offset(10)
            make.right.equalTo(_backgroundView).offset(-10)
            make.height.equalTo(30)
        }
        
        _tableView.snp.makeConstraints { (make) in
            make.left.right.equalTo(_listLabel)
            make.top.equalTo(_listLabel.snp.bottom).offset(-1)
            make.height.equalTo(200)
            
        }
        
        _makeSureButton.snp.makeConstraints { (make) in
            make.left.equalTo(_backgroundView)
            make.right.equalTo(_cancelButton.snp.left)
            make.bottom.equalTo(_backgroundView)
            make.height.equalTo(50)
            
        }
        
        _cancelButton.snp.makeConstraints { (make) in
            make.right.equalTo(_backgroundView)
            make.top.bottom.width.equalTo(_makeSureButton)
            
        }
    }
}

//MARK:外部调用逻辑
extension TQInquiryAddressView {
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

//MARK:代理
extension TQInquiryAddressView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray == nil ? 0 : dataArray!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let item = dataArray![indexPath.row]
        
//        let label = UILabel()
//        cell.addSubview(label)
//        label.textColor = UIColor.gray
//        label.font = UIFont.systemFont(ofSize: 14)
//        label.textAlignment = .center
//        label.frame = CGRect(x:0, y:0, width: cell.width, height: cell.height)
//
//        label.text = item.address
        cell.textLabel?.text  = item.address
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = UIColor.gray
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = dataArray![indexPath.row]
        if addressViewBlock != nil {
            addressViewBlock!(item)
            self.dismiss()
        }
    }
    
}

//MARK:事件处理
extension TQInquiryAddressView {
    @objc
    fileprivate func buttonClick(sender: UIButton){
        _searchView.resignFirstResponder()
        let buttonTag = sender.tag - ViewTag
        
        switch buttonTag {
        case 0:         //搜索
            if _searchView.text?.count != 0 {
                self.loadDataList()
                
            }else {
                TQHUD.hudRemind(text: "请输入搜索内容")
            }
        case 1:         //确认
            
            if hasVarifyNumber && _searchView.text?.count != 0 {
                
                let model = TQHouseSiteModel()
                model.address = _searchView.text
                model.isBind = false
                model.personNum = 0
                model.isRentalHouse = false
                model.memberNum = 0
                model.commodityhouse = false
                model.repeatCount = 0
                model.giscountNum = 0
                
                if addressViewBlock != nil {
                    addressViewBlock!(model)
                    self.dismiss()
                }
                
            }else {
                TQHUD.hudRemind(text: "请先验证房屋编号")
            }
            print("")
        case 2:         //取消
            self.dismiss()
            
        default:
            print("")
        }
    }
}

//MARK:获取列表数据
extension TQInquiryAddressView {
    
    func  loadDataList() {
        
        let paramDict: [String: Any] = ["houseInfo.address":_searchView.text as Any , "houseInfo.organization.id":organizationId, "tqmobile" : "true"]
        _reformer.getHouseInfoByAddress(dict: paramDict) {[weak self] (status, responseData, message) in
            if (responseData != nil) {
                
                self?.hasVarifyNumber = true
                self?.dataArray = responseData as? [TQHouseSiteModel]
                if self?.dataArray?.count != 0 {
                    self?._tableView.reloadData()
                }else {
                    TQHUD.hudRemind(text: "未发现相关房屋信息，点击确定可以添加")
                }
                
            }else{
                if (message != nil) {
                    TQHUD.hudRemind(text: message)
                }else {
                    TQHUD.hudRemind(text: "查询信息出错")
                }
            }
        }
    }
}

