//
//  PAT_PopChooseView.swift
//  平安通-组件
//
//  Created by 胡志辉 on 2017/12/25.
//  Copyright © 2017年 胡志辉. All rights reserved.
//



/**
 说明
 1.选择视图有两个类，对应类型大类和类型小类
 2.最好在viewWillDidLoad中初始化
 3.都需要传入当前选择的类别主题theme和cell上显示的titles
 4.需要实现代理，这样才可以判断选择的是哪个单元格，没有选中的时候传入-1
 5.对点击tableViewcell的事件进行代理返回，可以在代理中实现相应处理
 */



import UIKit


private let  cellLeftMarin:CGFloat  = 50
private let  titleLeftMarin:CGFloat = 40
private let rightMarin:CGFloat = 10
private let imgWidth:CGFloat = 20
private let rowHeight:CGFloat = 40






class TQCategorySelectedView: UIView{
    
   
    //传入数据的model
    fileprivate var _TQ_Models : [TQIssueModel]?
    var TQ_Models : [TQIssueModel]?{
        get{
            _TQ_Models = LaunchViewModel.shared.issueTypes
            return _TQ_Models
        }
        set{
            _TQ_Models = newValue
        }
    }
    
    var modelsArray : [TQIssueModel]?
    

    //点击回调
    var handleDidSelectedCallBack : ((_ models:[TQIssueModel]?)->())?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setUpView()
    }
    
    
    fileprivate var tableView:UITableView!
    fileprivate var TQ_Frame : CGRect!
    //选择主题
    fileprivate var TQ_Theme :String? = "选择事件大类"
    fileprivate var titleView = UIView()
    fileprivate var titleLab = UILabel()
    //选择的单元格位置
    fileprivate var selectedRow: Int? = -1
}
//MARK: -布局
extension TQCategorySelectedView{
   private func setUpView(){
        
        ///标题View
        titleView.backgroundColor = UIColor.white
        titleView.frame = CGRect(x: 0, y: 0, width: kSCREEN_WIDTH, height: rowHeight)
        
        self.titleView.addSubview(self.titleLab)
        self.titleLab.textColor = UIColor(hex: kHighlighColor)
        self.titleLab.snp.makeConstraints { (make) in
            make.left.equalTo(titleLeftMarin)
            make.top.right.equalTo(0)
            make.height.equalTo(rowHeight - 0.5)
        }
        let sepLab = UILabel()
        sepLab.backgroundColor = UIColor(red: 0.78, green: 0.78, blue: 0.8, alpha: 1)
        self.titleView.addSubview(sepLab)
        sepLab.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(0)
            make.height.equalTo(0.5)
        }
        
        //tableView
        tableView = UITableView()
        tableView.register(TQCategoryCell.classForCoder(), forCellReuseIdentifier: "title")
        tableView.rowHeight = rowHeight
        tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        tableView.delegate = self
        tableView.dataSource = self
    
        
        self.addSubview(self.titleView)
        self.addSubview(self.tableView)
        
        self.backgroundColor = UIColor(white: 0.0, alpha: 0.0)
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(TQCategorySelectedView.tapDismiss))
        tap.delegate = self
        self.addGestureRecognizer(tap)
    }
    
    ///更新外部数据
    private func updateData(){
        if self.TQ_Models != nil {
            //设置数据
            let count = self.TQ_Models?.count
            self.TQ_Frame = CGRect(x: 0, y: kSCREEN_HEIGHT - CGFloat(count!+1) * rowHeight, width: kSCREEN_WIDTH, height: CGFloat(count!+1) * rowHeight)
        }
        //设置选项卡的标题
        self.titleLab.text = self.TQ_Theme
        
    }
}

//MARK: -回调
extension TQCategorySelectedView{
    //点击背景图收起弹窗
    @objc func tapDismiss() {
        self.disMiss()
    }
}

//MARK: -代理
extension TQCategorySelectedView:UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate{
    
    //处理点击冲突问题
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let touchClass = NSStringFromClass((touch.view?.classForCoder)!)
        if touchClass != NSStringFromClass(self.classForCoder) {
            return false
        }
        return true
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.TQ_Models != nil ? self.TQ_Models!.count : 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "title", for: indexPath) as! TQCategoryCell
        
        cell.model = self.TQ_Models?[indexPath.row]
        
        if indexPath.row == selectedRow! {
            cell.cellTextLabel.textColor = UIColor(hex: kHighlighColor)
        }else{
            cell.cellTextLabel.textColor = UIColor.black
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
    
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedRow = indexPath.row
        tableView.reloadData()
        let model = self.TQ_Models![indexPath.row]
        if model.childrenNum != nil && (model.childrenNum)! > 0 {
            //请求网络获取小类，获取成功调出小类选择视图
            self.getChildType(typeId: model.issueId, complete: {[weak self] (status, responseData, message) in
                if status == TQResponseStatus.tq_success && responseData != nil{
                    self?.tableView.isHidden = true
                    self?.titleView.isHidden = true
                    //请求获取到小类
                    let childView = TQCategorySelectedChildView()
                    childView.TQ_Models = responseData as? [TQIssueModel]
                    childView.TQ_Theme = "小类"
                    if self?.modelsArray != nil && (self?.modelsArray?.count)! > 1{
                        childView.selectedModel = self?.modelsArray![1]
                    }
                    //返回回调
                    childView.handleClickBackBtnCallBack = {
                        self?.tableView.isHidden = false
                        self?.titleView.isHidden = false
                    }
                    //选择回调
                    childView.handleDidSelectedCallBakc = {[weak self](childModel,childRow) in
                        
                        if self?.handleDidSelectedCallBack != nil{
                            self?.handleDidSelectedCallBack!([model,childModel!])
                        }
                        self?.disMiss()
                    }
                    childView.show(view: self)
                }else{
                    TQHUD.hudRemind(text: message)
                }
            })
        }else{
            //直接回调
            
            if self.handleDidSelectedCallBack != nil {
                self.handleDidSelectedCallBack!([model])
            }
            self.disMiss()
        }
        
    }
}

//MARK: -业务
extension TQCategorySelectedView{
    
    ///根据事件大类的id获取小类
    fileprivate func getChildType(typeId:Int?,complete:@escaping NetworkFinished){
        let paramer = ["id":typeId]
        
        NetworkTools.shareNetworkTool.GET(url: tq_getEventChildType_url, parameters: paramer as [String : AnyObject], identifer: nil) { (status, responseData, message) in
            if status == .tq_success && responseData != nil {
                let array = (responseData as! NSDictionary)["issueType"] as? [NSDictionary]
                
                if array == nil {
                    complete(.tq_failure, nil, nil)
                }
                
                var typeArray = [TQIssueModel]()
                for dic in array! {
                    let item = TQIssueModel(dictionary: dic)
                    typeArray.append(item)
                }
                complete(status, typeArray, nil)
            } else {
                complete(status, nil, message)
            }
        }
    }
    
    
    // x显示动画
    public func show(){
        //显示动画之前，要对所有的数据进行重新赋值，避免出现数据不同步
        self.updateData()
        let window: UIWindow? = (UIApplication.shared.delegate?.window)!
        if window != nil {
            window?.addSubview(self)
            self.snp.makeConstraints({ (make) in
                make.top.right.left.equalTo(0)
                make.bottom.equalTo((isIphoneX ? -34.0 : 0))
            })
        }
        //对titleLab、tableView的frame设置
        self.titleView.snp.remakeConstraints { (make) in
            make.top.equalTo((kSCREEN_HEIGHT - self.TQ_Frame.size.height > 100) ? (kSCREEN_HEIGHT - self.TQ_Frame.size.height) : 100)
            make.left.right.equalTo(0)
            make.height.equalTo(rowHeight)
        }
        
        self.tableView.snp.remakeConstraints{ (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(self.titleView.snp.bottom)
            make.bottom.equalTo(0)
        }
        self.tableView.reloadData()
        
        if self.modelsArray != nil {
            let model = self.modelsArray![0]
            for i in 0..<(self.TQ_Models?.count)!{
                let item = self.TQ_Models?[i]
                if model.issueId == item?.issueId{
                    self.selectedRow = i
                }
            }
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.backgroundColor = UIColor(white: 0.0, alpha: 0.3)
        }, completion: { (finished) in
            if finished {
                
            }
        })
    }
    
    //MARK:隐藏动画
    public func disMiss(){
        UIView.animate(withDuration: 0.3, animations: {
            self.backgroundColor = UIColor(white: 0.0, alpha: 0.0)
        }) { (finished) in
            if finished {
                self.removeFromSuperview()
            }
        }
    }
}



/*****--------------------------------------------------------***/


class TQCategorySelectedChildView: UIView,UITableViewDelegate,UITableViewDataSource {
   
   
    
    var TQ_Models : [TQIssueModel]?
    var TQ_Theme:String?
    var selectedModel : TQIssueModel?
    
    //点击回调
    var handleDidSelectedCallBakc : ((_ model:TQIssueModel?,_ childRow:Int?)->())?
    //返回按钮的回调
    var handleClickBackBtnCallBack : (()->())?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setUpView()
    }
    
    fileprivate var tableView = UITableView()
    fileprivate var titleView = UIView()
    fileprivate var titleLab = UILabel()
    fileprivate var TQ_Frame:CGRect!
}
//布局
extension TQCategorySelectedChildView{
    func setUpView() {
        //titleView位置设置
        self.titleView.backgroundColor = UIColor.white
        self.titleView.frame = CGRect(x: 0, y: 0, width: kSCREEN_WIDTH, height: rowHeight)
        let backBtn = UIButton(type: UIButtonType.custom)
        backBtn.setImage(UIImage(named:"小类返回"), for: UIControlState.normal)
        backBtn.addTarget(self, action: #selector(TQCategorySelectedChildView.tapBackBtn(btn:)), for: UIControlEvents.touchUpInside)
        self.titleView.addSubview(backBtn)
        backBtn.snp.makeConstraints { (make) in
            make.left.top.equalTo(0)
            make.bottom.equalTo(-0.5)
            make.width.equalTo(titleLeftMarin)
        }
        
        self.titleView.addSubview(self.titleLab)
        self.titleLab.textColor = UIColor(hex: kHighlighColor)
        self.titleLab.font = UIFont.systemFont(ofSize: 14.0)
        self.titleLab.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.equalTo(backBtn.snp.right)
            make.right.equalTo(0)
            make.height.equalTo(rowHeight-0.5)
        }
        
        let sepLab = UILabel()
        sepLab.backgroundColor = UIColor(red: 0.78, green: 0.78, blue: 0.8, alpha: 1)
        self.titleView.addSubview(sepLab)
        sepLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(self.titleLab.snp.bottom)
            make.height.equalTo(0.5)
        }
        
        //tableView
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = rowHeight
        self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        self.tableView.register(TQCategoryCell.classForCoder(), forCellReuseIdentifier: "titles")
        
        self.addSubview(self.titleView)
        self.addSubview(self.tableView)
        
        //backView
        self.backgroundColor = UIColor.clear
        let tap = UITapGestureRecognizer(target: self, action: #selector(TQCategorySelectedChildView.tapDismiss))
        tap.delegate = self
        self.addGestureRecognizer(tap)
    }
    
    //数据的更新
    private func updateData(){
        if self.TQ_Models != nil{
            let count = self.TQ_Models?.count
            self.TQ_Frame = CGRect(x: 0, y: kSCREEN_HEIGHT - CGFloat(count! + 1) * rowHeight , width: kSCREEN_WIDTH, height: CGFloat(count! + 1) * rowHeight)
        }
        self.titleLab.text = self.TQ_Theme
    }
}
//回调
extension TQCategorySelectedChildView{
    //返回按钮的点击事件
    @objc func tapBackBtn(btn:UIButton){
        self.disMiss()
        if self.handleClickBackBtnCallBack != nil {
            self.handleClickBackBtnCallBack!()
        }
    }
    //点击背景，视图消失
    @objc func tapDismiss(){
        self.disMiss()
    }
}
//代理
extension TQCategorySelectedChildView:UIGestureRecognizerDelegate{
    
    //处理点击冲突问题
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let touchClass = NSStringFromClass((touch.view?.classForCoder)!)
        
        if touchClass != NSStringFromClass(self.classForCoder) {
            return false
        }
        return true
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.TQ_Models != nil ? (self.TQ_Models?.count)! : 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "titles", for: indexPath) as! TQCategoryCell
        cell.model = self.TQ_Models?[indexPath.row]
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        //判断是否为选中的单元格
        if self.selectedModel != nil && self.selectedModel?.issueId != nil {
            if self.selectedModel?.issueId == cell.model?.issueId {
                cell.cellTextLabel.textColor = UIColor(hex: kHighlighColor)
            }else{
                cell.cellTextLabel.textColor = UIColor.black
            }
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.disMiss()
        let model = self.TQ_Models![indexPath.row]
        
        //点击的时候回调
        if (self.handleDidSelectedCallBakc != nil) {
            self.handleDidSelectedCallBakc!(model,indexPath.row)
        }
    }
}
//业务逻辑
extension TQCategorySelectedChildView{
    //MARK:-显示动画
    func show(view:UIView?){
        //在view显示出来之前对数据进行更新
        self.updateData()
        //添加控件到view上面
        if view != nil {
            view?.addSubview(self)
            self.snp.makeConstraints({ (make) in
                make.edges.equalTo(view!)
            })
        }
        //对控件进行重新布局
        self.titleView.snp.remakeConstraints{ (make) in
            make.top.equalTo((kSCREEN_HEIGHT - self.TQ_Frame.size.height > 100) ? (kSCREEN_HEIGHT - self.TQ_Frame.size.height) : 100)
            make.height.equalTo(rowHeight)
            make.left.right.equalTo(0)
        }
        
        self.tableView.snp.remakeConstraints { (make) in
            make.top.equalTo(self.titleView.snp.bottom)
            make.left.right.equalTo(0)
            make.bottom.equalTo(0)
        }
        UIView.animate(withDuration: 0.2) {

        }
    }
    //MARK:-隐藏动画
    func disMiss(){
        UIView.animate(withDuration: 0.2, animations: {
//            self.backgroundColor = UIColor(white: 0.0, alpha: 0.0)
        }) { (finished) in
            if finished {
//                self.removeFromSuperview()
                self.superview?.removeFromSuperview()
            }
        }
    }
}

//MARK: - 获取项目名
class PublicCategory: NSObject{
    //单利
    static var shared = PublicCategory()
    
     func getObjectName()->String?{
        //获取所有信息字典
       let infoDictionary = Bundle.main.infoDictionary;
         //获取项目名称
        let executableFile = infoDictionary!["kCFBundleExecutableKey"] as? String
        return executableFile
    }
}


class TQCategoryCell: UITableViewCell {
    
    fileprivate  var cellTextLabel = UILabel()
    fileprivate var cellAccessoryView = UIImageView()
    fileprivate var separatorLab = UILabel()
    fileprivate  var _model : TQIssueModel?
    var model : TQIssueModel?{
        get{
            return _model
        }
        set{
            _model = newValue
            self.cellTextLabel.text = _model?.content
            if _model?.childrenNum != nil && (_model?.childrenNum)! > 0 {
                self.accessoryType = .disclosureIndicator
            }else{
                self.accessoryType = .none
            }
        }
    }
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: UITableViewCellStyle.default, reuseIdentifier: reuseIdentifier)
        //显示titles的label
        self.cellTextLabel.font = UIFont.systemFont(ofSize: 14.0)
        self.contentView.addSubview(cellTextLabel)
        self.cellTextLabel.snp.makeConstraints { (make) in
            make.left.equalTo(cellLeftMarin)
            make.right.equalTo(0)
            make.height.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



