//
//  PAT_GriddingSelectedView.swift
//  平安通-组件
//
//  Created by 胡志辉 on 2017/12/26.
//  Copyright © 2017年 胡志辉. All rights reserved.
//



/**
 说明
 1.网格选择一般都是一个界面只有一个，所以对多个选择的选中问题没有做处理
 2.可以根据项目需求传入一个model，一个是model对象的数组，或者是网格ID，同时传的话，会取最后一个上传的作为展示数据
 3.最好获取到要展示的所有数据
 4.点击回调都已闭包的形式回调，
     如点击tableViewCell的回调是didSelectedRowAtIndexPath
         点击确认按钮的回调是 clickConfirmBtn
 */

import UIKit


private let rowHeight:CGFloat = 40
private let padding :CGFloat = 10
private let textFont : CGFloat = 14
private let cellLeftMarin : CGFloat = 40
private let titleLeftMarin : CGFloat = 40



class TQGriddingSelectedView: UIView,UITableViewDelegate,UITableViewDataSource {
    /*是否需要确认按钮*/
    fileprivate var _isConfirm : Bool?
    var isConfirm : Bool? {
        get{
            return _isConfirm
        }
        set{
            _isConfirm = newValue
            if _isConfirm! {
               confirmBtn.isHidden = true
            }else{
                confirmBtn.isHidden = false
            }
        }
    }
    
    /**
     是否只选择乡镇以下的区域，传入的是层级数字
    0 片组片格
     10 村
     20 镇，街道
     30 区
     40 市
     50 省
     60 全国
     15 联村（社区）
     */
    fileprivate var _internalId : Int! = -1
    var internalId : Int!{
        get{
            return _internalId
        }
        set{
            _internalId = newValue
        }
    }
    
    
    /*数据源*/
   fileprivate var _model : TQOrgModel!
    var model : TQOrgModel!{
        get{
            return _model
        }
        set(value){
            _model = value
            self.leftTitles.removeAll()
            self.rightTitles.removeAll()
            //设置当前选中的selectedModel设置为当前model
            self.selectedModel = _model
            //设置titles数组
            self.leftTitles.append(_model)
            if _model.subArray != nil && (_model.subArray?.count)! > 0 {
                for  subModel in _model.subArray! {
                    self.rightTitles.append(subModel)
                }
            }
        }
    }
    
    fileprivate var _modelArray : [TQOrgModel?]?
    var modelArray : [TQOrgModel?]?{
        get{
            return _modelArray
        }
        set{
            _modelArray = newValue
            self.leftTitles.removeAll()
            self.rightTitles.removeAll()
            //设置titles数组
            for i in 0..<(_modelArray?.count)! {
                if _modelArray?.count == 1{
                    self.selectedModel = _modelArray?[0]
                    self.leftTitles.append(_modelArray?[0])
                }else{
                    if i == (_modelArray?.count)! - 1{
                        self.selectedModel = _modelArray?[i]
                    }else{
                        leftTitles.append(_modelArray?[i])
                    }
                }
            }
            let model = leftTitles[leftTitles.count - 1]
            if model?.subArray != nil && (model?.subArray?.count)! > 0 {
                for  subModel in (model?.subArray)! {
                    self.rightTitles.append(subModel)
                }
            }
            self.reloadData()
        }
    }
    
    fileprivate var _orgId : Int?
     var orgId : Int?{
        get{
           return _orgId
        }
        set{
            _orgId = newValue
            //根据ID获取网格数据
            LaunchViewModel.shared.getOrganizationBy(id: _orgId!) { (status, responseData, message) in
                if status == TQResponseStatus.tq_success && responseData != nil{
                    let orgModel = responseData as! TQOrgModel
                    self.model = orgModel
                }
            }
        }
    }
    
    
    
    
    
    //定义block属性
    var didSelectedRowAtIndexPath:((_ models:[TQOrgModel],_ leftOrRight:Int)->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setUpView()
    }
    
    fileprivate var leftTableView = UITableView()
    fileprivate var rightTableView = UITableView()
    
    fileprivate var titleView = UIView()
    fileprivate var backGroundView = UIView()
    fileprivate var midSepLab = UILabel()
    fileprivate var confirmBtn = UIButton(type: UIButtonType.custom)
    fileprivate var selectedRow : NSInteger = -1//右边视图选中单元格
    fileprivate var leftTitles : [TQOrgModel?] = [TQOrgModel?]()
    fileprivate var rightTitles : [TQOrgModel?] = [TQOrgModel?]()
    //获取点击单元格上面model
    fileprivate var selectedModel : TQOrgModel!
    
}
//MARK: 布局
extension TQGriddingSelectedView{
   fileprivate func setUpView() {
        //初始化控件
        //titleView
        self.titleView.frame = CGRect(x: 0, y: 0, width: kSCREEN_WIDTH, height: rowHeight)
        self.titleView.backgroundColor = UIColor.white
        
        /*确定按钮*/
        confirmBtn.setTitle("确定", for: UIControlState.normal)
        confirmBtn.setTitleColor(UIColor.init(hex: kHighlighColor), for: UIControlState.normal)
        confirmBtn.titleLabel?.font = UIFont.systemFont(ofSize: textFont)
        confirmBtn.addTarget(self, action: #selector(TQGriddingSelectedView.clickConfirmBtn(btn:)), for: UIControlEvents.touchUpInside)
        self.titleView.addSubview(confirmBtn)
        confirmBtn.snp.makeConstraints { (make) in
            make.top.right.bottom.equalTo(0)
            make.width.equalTo(60)
        }
    
        /*显示标题的lab*/
        let titleLab = UILabel()
        self.titleView.addSubview(titleLab)
        titleLab.text = "选择部门"
        titleLab.textColor = UIColor.init(hex: kHighlighColor)
        titleLab.font = UIFont.systemFont(ofSize: textFont)
        
        titleLab.snp.makeConstraints { (make) in
            make.left.equalTo(padding)
            make.top.equalTo(0)
            make.right.equalTo(confirmBtn.snp.left).offset(10)
            make.height.equalTo(rowHeight-0.5)
        }
        
        /*分隔线*/
        let sepLab = UILabel()
        self.titleView.addSubview(sepLab)
        sepLab.backgroundColor = UIColor(red: 0.78, green: 0.78, blue: 0.8, alpha: 1)
        sepLab.snp.makeConstraints { (make) in
            make.bottom.equalTo(0)
            make.left.right.equalTo(0)
            make.height.equalTo(0.5)
        }
        
        /*左边tableView*/
        self.leftTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0 )
        self.leftTableView.tableFooterView = UIView()
        self.leftTableView.delegate = self
        self.leftTableView.dataSource = self
        self.leftTableView.register(GriddingSelectedCellA.classForCoder(), forCellReuseIdentifier: "leftTitles")
        
        /*右边tableView*/
        self.rightTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        self.rightTableView.tableFooterView = UIView()
        self.rightTableView.dataSource = self
        self.rightTableView.delegate = self
        self.rightTableView.rowHeight = rowHeight
        self.rightTableView.register(GriddingSelectedCellB.classForCoder(), forCellReuseIdentifier: "rightTitles")
        
        //中间的分隔线
        self.midSepLab.backgroundColor = UIColor(red: 0.78, green: 0.78, blue: 0.8, alpha: 1)
        
        //backGroundView
        self.backGroundView.backgroundColor = UIColor(white: 0.0, alpha: 0.0)
        self.backGroundView.frame = CGRect(x: 0, y: 0, width: kSCREEN_WIDTH, height: kSCREEN_HEIGHT)
        self.backGroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(TQGriddingSelectedView.tapBackGroundView)))
        
        self.addSubview(self.backGroundView)
        self.addSubview(self.titleView)
        self.addSubview(self.leftTableView)
        self.addSubview(self.midSepLab)
        self.addSubview(self.rightTableView)
    }
}
//MARK:-按钮的响应方法
extension TQGriddingSelectedView{
    /**
     确认按钮的实现方法
     */
    @objc func clickConfirmBtn(btn:UIButton){
        let orgModel = self.leftTitles.last!
        if self._internalId != -1 {
            if (orgModel?.orgInternalId)! > (self._internalId)!{
                TQHUD.hudRemind(text: "请选择乡镇、社区或网格层级")
            }else{
                self.disMiss()
            }
        }else{
            self.disMiss()
        }
        self.completeCallBack(indexPath: IndexPath(row: self.leftTitles.count - 1, section: 0), leftOrRight: 0)
    }
    
    //MARK:-点击背景方法
    @objc func tapBackGroundView(){
        self.disMiss()
    }
}
//MARK: - 代理
extension TQGriddingSelectedView{
    //MARK:-uitableViewDelegate &  uitableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var leftOrRight : Int = 0
        if tableView == self.rightTableView {
            leftOrRight = 1
            return self.rightTitles.count
        }else{
            return self.leftTitles.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var leftOrRight : Int = 0
        var title : String?
        if self.rightTableView == tableView {
            leftOrRight = 1
            title = self.rightTitles[indexPath.row]?.orgName
        }else{
            title = self.leftTitles[indexPath.row]?.orgName
        }
        
        
        
        if leftOrRight == 1 {
            //右边tableViewcell样式
            let cell = tableView.dequeueReusableCell(withIdentifier: "rightTitles", for: indexPath) as! GriddingSelectedCellB
            cell.cellTextLab.text = title
            
            //根据传入的选中row，显示选中状态
            if self.selectedModel != nil{
                if selectedModel.orgId == self.rightTitles[indexPath.row]?.orgId{
                    cell.cellTextLab.textColor = UIColor(hex: kHighlighColor)
                }else{
                    cell.cellTextLab.textColor = UIColor.black
                }
            }
            
            return cell
        }else{
            //左边tableViewCell样式
            let cell = tableView.dequeueReusableCell(withIdentifier: "leftTitles", for: indexPath) as! GriddingSelectedCellA
            cell.cellTextLab.text = title
            
            //如果点击右边tableView，有下级数据的时候，则左边视图最后一行选中
            //根据传入的选中row，显示选中状态
            if self.selectedModel != nil{
                if selectedModel.orgId == self.leftTitles[indexPath.row]?.orgId{
                    cell.cellTextLab.textColor = UIColor(hex: kHighlighColor)
                }else{
                    cell.cellTextLab.textColor = UIColor.black
                }
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var leftOrRight:Int = 0
        if self.rightTableView == tableView {
            leftOrRight = 1
            //获取点击cell对应的model类型
            selectedModel = self.rightTitles[indexPath.row]
        }else{
            //获取点击cell对应的model类型
            selectedModel = self.leftTitles[indexPath.row]
        }
        
        //如果点击的是右边tableView,如果有下级数据，则将cell上的model直接加到leftTitles数组中，没有的话，则直接选中消失
        var orgModel : TQOrgModel! = TQOrgModel(dictionary: NSDictionary())
        
        if leftOrRight == 1 {
            orgModel = self.rightTitles[indexPath.row]
            //获取下级的层级
            LaunchViewModel.shared.getOrganizationBy(id: orgModel.orgId!, complete: {[weak self] (status, responseData, message) in
                if status == TQResponseStatus.tq_success && responseData != nil{
                    //获取下级层级成功，判断下级层级是否有数据
                    //model获取的是点击的本级数据
                    let model : TQOrgModel? = responseData as? TQOrgModel
                    self?.rightTitles[indexPath.row] = model
                    //判断subArray是否有数据，有的话重新对数据源赋值
                    if model?.subArray != nil && (model?.subArray?.count)! > 0 {
                        self?.leftTitles.append(model)
                        self?.rightTitles.removeAll()
                        for subModel in (model?.subArray)! {
                            self?.rightTitles.append(subModel)
                        }
                    }else{
                        //获取不到本级的下级数据，则根据具体情况做处理
                        self?.completeCallBack(indexPath: indexPath, leftOrRight: leftOrRight)
                        //判断是否需要做区域选择限制处理
                        if self?._internalId != -1{
                            if (model?.orgInternalId)! > (self?._internalId)!{
                                TQHUD.hudRemind(text: "请选择乡镇、社区或网格层级")
                            }else{
                               self?.disMiss()
                            }
                        }else{
                          self?.disMiss()
                        }
                        
                        
                    }
                }else if status != .tq_repeat {
                    //获取数据失败，则直接返回数据
                    self?.completeCallBack(indexPath: indexPath, leftOrRight: leftOrRight)
                    let orgModel = self?.rightTitles[indexPath.row]
                
                    if self?._internalId != -1 {
                        if (orgModel?.orgInternalId)! > (self?._internalId)!{
                            TQHUD.hudRemind(text: "请选择乡镇、社区或网格层级")
                        }else{
                            self?.disMiss()
                        }
                    }else{
                        self?.disMiss()
                    }
                    
                }
                
                self?.reloadData()
                
                self?.leftTableView.scrollToRow(at: IndexPath(row: (self?.leftTitles.count)! - 1, section: 0), at: UITableViewScrollPosition.bottom, animated: false)
            })
            
            
        }else{
            //如果点击的是左边的tableView，则将cell上modeldsubAry数据赋值给self。rightTitles数组中,leftTitles则移除掉点击cell后面的所有数据
            orgModel = self.leftTitles[indexPath.row]
            self.rightTitles = (orgModel?.subArray)!
            let index = indexPath.row + 1
            for index in index..<self.leftTitles.count{
                self.leftTitles.removeLast()
            }
            self .reloadData()
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.leftTableView == tableView {
            //获取当前cell显示的title
            let title = self.leftTitles[indexPath.row]?.orgName
            //计算高度
            let height = self.heightForRow(title: title! as NSString)
            
            return height + 20
        }
        return rowHeight
    }
}
//MARK:-回调
extension TQGriddingSelectedView{
    //两种情况的回调，一种是选中的是左边cell，点击确定；一种是直接点击右边cell，没有下级的回调
    fileprivate func completeCallBack(indexPath:IndexPath,leftOrRight:Int){
        var orgModel : TQOrgModel?
        var models = self.leftTitles
        if leftOrRight == 1 {
            orgModel = self.rightTitles[indexPath.row]
            models.append(orgModel)
        }
        if self.didSelectedRowAtIndexPath != nil {
            self.didSelectedRowAtIndexPath!(models as! [TQOrgModel],leftOrRight)
        }
    }
}

//MARK:-外部调用的列表刷新,显示和隐藏
extension TQGriddingSelectedView{
   public func reloadData(){
        self.leftTableView.reloadData()
        self.rightTableView.reloadData()
    }
    public func show(){
        let window: UIWindow? = (UIApplication.shared.delegate?.window)!
        if window != nil {
            window?.addSubview(self)
            self.snp.makeConstraints({ (make) in
                make.top.left.right.equalTo(0)
                make.bottom.equalTo((isIphoneX ? -34.0 : 0))
            })
        }
        
        //重新布局
        self.titleView.snp.remakeConstraints { (make) in
            make.top.equalTo(150)
            make.width.equalTo(kSCREEN_WIDTH)
            make.height.equalTo(rowHeight)
        }
        self.leftTableView.snp.remakeConstraints { (make) in
            make.top.equalTo(self.titleView.snp.bottom)
            make.width.equalTo(50)
            make.height.equalTo(kSCREEN_HEIGHT - 150 - rowHeight)
            make.left.equalTo(0)
        }
        self.midSepLab.snp.remakeConstraints { (make) in
            make.top.height.equalTo(self.leftTableView)
            make.width.equalTo(0.5)
            make.left.equalTo(self.leftTableView.snp.right)
        }
        self.rightTableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.leftTableView)
            make.left.equalTo(self.midSepLab.snp.right)
            make.height.equalTo(self.leftTableView)
            make.width.equalTo(kSCREEN_WIDTH - 50)
        }
        
        UIView.animate(withDuration: 0.3) {
            self.backGroundView.backgroundColor = UIColor(white: 0.0, alpha: 0.3)
        }
        if self.leftTitles.count > 2 {
            self.leftTableView.scrollToRow(at: IndexPath(row: (self.leftTitles.count) - 1, section: 0), at: UITableViewScrollPosition.bottom, animated: false)
        }
    }
    public func disMiss(){
        
        UIView.animate(withDuration: 0.2, animations: {
            self.backGroundView.backgroundColor = UIColor(white: 0.0, alpha: 0.0)
        }) { (finished) in
            if finished {
                self.removeFromSuperview()
            }
        }
    }
}

//MARK:-计算类方法
extension TQGriddingSelectedView{
    private func heightForRow(title:NSString)->(CGFloat){
        let normalText: NSString = title
        let size = CGSize.init(width: 14.0, height: 1000)
        let dic = NSDictionary(object: UIFont.systemFont(ofSize: textFont), forKey: NSAttributedStringKey.font as NSCopying)
        let stringSize = normalText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [NSAttributedStringKey : Any], context:nil).size
        return stringSize.height + 5
        
    }
}



/**
 左边tableview的cell样式
 */
class GriddingSelectedCellA: UITableViewCell {
     var cellTextLab = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: UITableViewCellStyle.default, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = UITableViewCellSelectionStyle.none
        //添加cellTextLab
        self.contentView.addSubview(self.cellTextLab)
        self.cellTextLab.font = UIFont.systemFont(ofSize: textFont)
        self.cellTextLab.numberOfLines = 0
        self.cellTextLab.snp.makeConstraints { (make) in
            make.top.equalTo(padding)
            make.bottom.equalTo(-padding)
            make.center.equalTo(self.contentView)
            make.width.equalTo(textFont)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

/**
 右边tableView的Cell样式
 */
class GriddingSelectedCellB: UITableViewCell {
    
     var cellTextLab = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: UITableViewCellStyle.default, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = UITableViewCellSelectionStyle.none
        //添加cellTetxLabel
        self.contentView.addSubview(self.cellTextLab)
        self.cellTextLab.font = UIFont.systemFont(ofSize: textFont)
        
        self.cellTextLab.snp.makeConstraints { (make) in
            make.left.equalTo(cellLeftMarin)
            make.right.equalTo(-padding)
            make.top.bottom.equalTo(0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

