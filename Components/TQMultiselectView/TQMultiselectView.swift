//
//  TQMultiselectView.swift
//  PingAnTong_WenZhou
//
//  Created by 王璇 on 2018/1/26.
//  Copyright © 2018年 maomao. All rights reserved.
//

import UIKit
import MJRefresh

fileprivate let rowHeight: CGFloat = 40
fileprivate let buttonWidth: CGFloat = 60

class TQMultiselectView: UIView {
    // 事件步骤id
    var stepId: Int?
    
    // 多选开关，默认多选
    var leftoption = true
    
    // 左侧列表数据源
    fileprivate var _dataArray: [TQOrgModel]?
    var dataArray: [TQOrgModel]? {
        get {
            return _dataArray
        }
        set (newValue) {
            _dataArray = newValue
            self._lTableView.reloadData()
            
            if _dataArray != nil {
                let item = _dataArray!.first
                self.loadOrgWorkersBy(org: item!, loadMore: false)
            }
        }
    }
    
    // 回调
    var selectedCallBack: (([TQOrgModel]?)->())?
    
    // 当前左侧列表选中项
    fileprivate var _currentSelectedIndex = 0
    
    fileprivate let _reformer = TQMultiselectViewModel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setUpView()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGesture(_:)))
        tapGesture.delegate = self
        _maskView.addGestureRecognizer(tapGesture)
        
        _lTableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        _rTableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
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
        return view
    }()
    
    fileprivate lazy var _titleLabel: UILabel = {
        let label = UILabel()
        label.text = "请选择办理部门（人）"
        label.textColor = UIColor(hex: "#11B0FD")
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    fileprivate lazy var _sureButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("确定", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.setTitleColor(UIColor(hex: kHighlighColor), for: .normal)
        button.addTarget(self, action: #selector(buttonClick(_:)), for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var _lTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    fileprivate lazy var _rTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {
            [weak self] in
            self?.loadOrgWorkersBy(org: nil, loadMore: true)
        })
        return tableView
    }()
}

extension TQMultiselectView {
    fileprivate func setUpView() {
        
        self.addSubview(self._maskView)
        _maskView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        self.addSubview(self._contentView);
        _contentView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self)
            make.height.equalTo(self).multipliedBy(0.7)
        }
        
        _contentView.addSubview(self._titleLabel)
        _titleLabel.snp.makeConstraints { (make) in
            make.left.top.equalTo(_contentView)
            make.height.equalTo(rowHeight)
        }
        
        _contentView.addSubview(self._sureButton)
        _sureButton.snp.makeConstraints { (make) in
            make.top.right.equalTo(_contentView)
            make.size.equalTo(CGSize(width: buttonWidth, height: rowHeight))
        }
        
        _contentView.addSubview(self._lTableView)
        _lTableView.snp.makeConstraints { (make) in
            make.left.bottom.equalTo(_contentView)
            make.top.equalTo(_titleLabel.snp.bottom).offset(1)
            make.right.equalTo(_contentView.snp.centerX).offset(-0.5)
        }
        
        _contentView.addSubview(self._rTableView)
        _rTableView.snp.makeConstraints { (make) in
            make.right.bottom.equalTo(_contentView)
            make.top.equalTo(_sureButton.snp.bottom).offset(1)
            make.left.equalTo(_contentView.snp.centerX).offset(0.5)
        }
    }
}

extension TQMultiselectView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if _dataArray == nil {
            return 0
        } else {
            if tableView == _lTableView {
                return _dataArray!.count
            } else {
                let item = _dataArray![_currentSelectedIndex]
                return item.workers == nil ? 0 : item.workers!.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
        
        if tableView == _lTableView {
            let item = _dataArray![indexPath.row]
            cell.textLabel?.text = item.orgName
            cell.textLabel?.textColor = item.selected == true ? UIColor(hex: kHighlighColor) : UIColor.black
        } else {
            let orgModel = _dataArray![_currentSelectedIndex]
            if indexPath.row < orgModel.workers!.count {
                let item = orgModel.workers![indexPath.row]
                cell.textLabel?.text = item.userName
                cell.textLabel?.textColor = item.selected == true ? UIColor(hex: kHighlighColor) : UIColor.black
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == _lTableView {
            self.leftCellSelectedAt(index: indexPath.row)
            _currentSelectedIndex = indexPath.row
            
        } else {
            self.rightCellSelectedAt(index: indexPath.row)
        }
    }
}

extension TQMultiselectView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if NSStringFromClass((touch.view?.classForCoder)!) == "UITableViewCellContentView" {
            return false
        }
        return true
    }
}

// MARK: - 点击回调
extension TQMultiselectView {
    @objc fileprivate func tapGesture(_ gesture: UIGestureRecognizer) {
        if _dataArray != nil{
            // 筛选出左侧列表选中项
            for org in _dataArray! {
                if org.selected == true {
                    org.selected = false
                    // 筛选出右侧列表中的选项
                    if org.workers != nil {
                        var tempWorkers = [UserBaseModel]()
                        for worker in org.workers! {
                            if worker.selected == true {
                                worker.selected = false
                                tempWorkers.append(worker)
                            }
                        }
                        org.workers = tempWorkers.count > 0 ? tempWorkers : nil
                    }
                }
            }
        }
        self.dismiss()
    }
    
    @objc fileprivate func buttonClick(_ sender: UIButton) {
        if selectedCallBack != nil && _dataArray != nil {
            var array = [TQOrgModel]()
            // 筛选出左侧列表选中项
            for org in _dataArray! {
                if org.selected == true {
                    // 筛选出右侧列表中的选项
                    if org.workers != nil {
                        var tempWorkers = [UserBaseModel]()
                        for worker in org.workers! {
                            if worker.selected == true {
                                tempWorkers.append(worker)
                            }
                        }
                        org.workers = tempWorkers.count > 0 ? tempWorkers : nil
                    }
                    array.append(org)
                }
            }
            selectedCallBack!(array.count > 0 ? array : nil)
        }
        self.dismiss()
    }
    
    // 左侧列表选中
    fileprivate func leftCellSelectedAt(index: Int) {
        // 当前选中项
        let item = _dataArray![index]
        
        // 单选模式,取消之前选中项
        if leftoption == false {
            let lastItem = _dataArray![_currentSelectedIndex]
            if lastItem.selected == true {
                lastItem.selected = false
                
                // 之前选项子项全部清除选中状态
                if lastItem.workers != nil {
                    for workers in lastItem.workers! {
                        workers.selected = false
                    }
                }
            } else {
                // 当单选模式下，已选项与_currentSelectedIndex 值不一致，则全部设置为未选中
                for org in _dataArray! {
                    if org.selected == true && org.orgId != item.orgId {
                        org.selected = false
                        org.workers = nil
                    }
                }
            }
        }
        
        
        // 当前项之前没有被选中，则直接设置为选中状态
        if item.selected == false {
            item.selected = true
        } else {
            // 若当前项没有子项选中
            if item.workers == nil {
                item.selected = false
            }
            // 若当前项有子项，子项有被选中则当前项保留选中状态
            else {
                var isSelected = false
                for worker in item.workers! {
                    if worker.selected == true {
                        isSelected = true
                        break
                    }
                }
                item.selected = isSelected
            }
        }
        
        _lTableView.reloadData()
        
        // 加载右侧列表数据
        self.loadOrgWorkersBy(org: item, loadMore: false)
    }
    
    // 右侧列表选中
    fileprivate func rightCellSelectedAt(index: Int) {
        let org = _dataArray![_currentSelectedIndex]
        
        // 选中当前项
        if org.workers!.count > index {
            let worker = org.workers![index]
            worker.selected = !worker.selected
        }
        
        // 若右侧子项全部为未选中，则左侧项也标记为未选中
        var isSelected = false
        for worker in org.workers! {
            if worker.selected == true {
                isSelected = true
                break
            }
        }
        org.selected = isSelected
        
        _lTableView.reloadData()
        _rTableView.reloadData()
    }
}

// MARK: - 接口
extension TQMultiselectView {
    // 获取部门人员信息
    fileprivate func loadOrgWorkersBy(org: TQOrgModel?, loadMore: Bool) {
        
        var org = org
        if org == nil && loadMore == true {
            org = self._dataArray![self._currentSelectedIndex]
        }
        
        self._reformer.loadWorkerWith(org: org!, loadMore: loadMore) {[weak self] (status, responseData, message) in
            if self?.dataArray != nil {
                let currentOrg = self!._dataArray![self!._currentSelectedIndex]
                
                let workers = responseData as? [UserBaseModel]
                // 反选工作人员
                if currentOrg.workers != nil && workers != nil {
                    for user in currentOrg.workers! {
                        for work in workers! {
                            if user.userId == work.userId {
                                work.selected = user.selected
                                break
                            }
                        }
                    }
                }
                
                if loadMore == true {
                    if currentOrg.workers != nil && workers != nil {
                        currentOrg.workers! += workers!
                    }
                } else {
                    currentOrg.workers = workers
                }
                self?._rTableView.mj_footer.endRefreshing()
                self?._rTableView.reloadData()
            }
        }
    }
}

// MARK: 业务逻辑
extension TQMultiselectView {
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
