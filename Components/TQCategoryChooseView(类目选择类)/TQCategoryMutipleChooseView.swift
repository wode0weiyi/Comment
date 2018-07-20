//
//  TQCategoryMutipleChooseView.swift
//  PingAnTong_WenZhou
//
//  Created by 胡志辉 on 2018/1/25.
//  Copyright © 2018年 maomao. All rights reserved.
//

import UIKit

let tableViewHeight = kSCREEN_HEIGHT - 150


class TQCategoryMutipleChooseView: UIView {
    //数据源
    fileprivate var _dataArray : [chooseModel]?
    var dataArray :[chooseModel]?{
        get{
            if _dataArray == nil {
                _dataArray = [chooseModel]()
            }
            return _dataArray
        }
        set{
            _dataArray = newValue
            tqHeight = CGFloat((_dataArray?.count)! * 40) > tableViewHeight ? tableViewHeight : CGFloat((_dataArray?.count)! * 40)
            tableView?.reloadData()
        }
    }

    //选中的cell的数组
    var _selectedModels : [chooseModel]?
    //事件步骤ID
    var issueStepId : Int?
    //事件办理类型
    var chooseType : String?

    //设置是否多选
   fileprivate var _allowsMultipleSelection : Bool?
    var allowsMultipleSelection : Bool?{
        get{
            if _allowsMultipleSelection == nil {
                _allowsMultipleSelection = false
            }
            return _allowsMultipleSelection
        }
        set{
            _allowsMultipleSelection = newValue
            self.tableView?.allowsMultipleSelection = _allowsMultipleSelection!
            if _allowsMultipleSelection! {
                self.confirmBtn?.isHidden = false
            }
        }
    }
    //设置当前选择的主题
  fileprivate var _theme : String?
    var theme : String?{
        get{
            return _theme
        }
        set{
            _theme = newValue
            self.titleLab?.text = _theme
        }
    }
    
    
    //回调
    var handleChooseCallBack : (([chooseModel]?)->())?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setUpView()
    }
    
    
    fileprivate var titleView : UIView?
    fileprivate var tableView: UITableView?
    fileprivate var titleLab : UILabel?
    fileprivate var confirmBtn: UIButton?
    fileprivate var tqHeight: CGFloat?
    fileprivate lazy var _remofer : TQEventViewModel = {
       let remofer = TQEventViewModel()
        return remofer
    }()
}

//MARK: - 布局
extension TQCategoryMutipleChooseView{
    fileprivate func setUpView(){
        self.backgroundColor = UIColor(white: 0.0, alpha: 0.0)
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(TQCategoryMutipleChooseView.tapBackGround))
        tap.delegate = self
        self.addGestureRecognizer(tap)
        
        
        tableView = UITableView()
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.rowHeight = 40.0
        tableView?.register(MutipleCell.classForCoder(), forCellReuseIdentifier: "mutipleCell")
        tableView?.allowsMultipleSelection = false
        self.addSubview(tableView!)
        tableView?.snp.makeConstraints({ (make) in
            make.left.right.equalTo(0)
            make.bottom.equalTo((0))
            make.height.equalTo(0)
        })
        
        titleView = UIView()
        titleView?.backgroundColor = UIColor.white
//        titleView?.isUserInteractionEnabled = false
        self.addSubview(titleView!)
        titleView?.snp.makeConstraints({ (make) in
            make.bottom.equalTo((tableView?.snp.top)!)
            make.height.equalTo(48)
            make.left.right.equalTo(0)
        })
        
        titleLab = UILabel()
        titleLab?.font = UIFont.systemFont(ofSize: 14.0)
        titleLab?.textColor = UIColor(hex: kHighlighColor)
        titleView?.addSubview(titleLab!)
        titleLab?.snp.makeConstraints({ (make) in
            make.left.equalTo(15)
            make.center.equalTo((titleView?.snp.center)!)
            make.height.equalTo(20)
        })
        confirmBtn = UIButton()
        confirmBtn?.setTitle("确定", for: UIControlState.normal)
        confirmBtn?.setTitleColor(UIColor(hex:kHighlighColor), for: UIControlState.normal)
        confirmBtn?.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        confirmBtn?.addTarget(self, action: #selector(TQCategoryMutipleChooseView.confirmBtnClick(sender:)), for: UIControlEvents.touchUpInside)
        titleView?.addSubview(confirmBtn!)
        confirmBtn?.snp.makeConstraints({ (make) in
            make.top.bottom.equalTo(0)
            make.right.equalTo(-15)
            make.width.equalTo(70)
        })
        confirmBtn?.isHidden = true
        
        let sepLab = UILabel()
        sepLab.backgroundColor = UIColor(red: 0.78, green: 0.78, blue: 0.8, alpha: 1)
        titleView?.addSubview(sepLab)
        sepLab.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(0)
            make.height.equalTo(1)
        }
    }
}

//MARK: - 回调
extension TQCategoryMutipleChooseView{
    @objc fileprivate func confirmBtnClick(sender:UIButton){
        //获取多选的单元格上面的数据
       
        if self.dataArray != nil && (self.dataArray?.count)! > 0 {
            var models = [chooseModel]()
            
            for item in self.dataArray!{
                if item.isSelected!{
                    models.append(item)
                }
            }
            if self.handleChooseCallBack != nil{
                self.handleChooseCallBack!(models)
            }
        }
        self.disMiss()
    }
    
    @objc fileprivate func tapBackGround(){
        self.disMiss()
    }
}

//MARK: - 代理
extension TQCategoryMutipleChooseView:UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate{
    
    //处理点击冲突问题
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let touchClass = NSStringFromClass((touch.view?.classForCoder)!)
        if touchClass != NSStringFromClass(self.classForCoder) {
            return false
        }
        return true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray != nil ? (self.dataArray?.count)! : 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mutipleCell", for: indexPath) as? MutipleCell
        let model = self.dataArray![indexPath.row]
        cell?.cellTextLab?.textColor = model.isSelected == true ? UIColor(hex: kHighlighColor) : UIColor.black
        
        cell?.renderWithData(item: self.dataArray?[indexPath.row])
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if  !_allowsMultipleSelection! {
            let model = self.dataArray![indexPath.row]
            model.isSelected = true
            self._selectedModels = [model]
           //如果不是多选，
            if self.handleChooseCallBack != nil{
                self.handleChooseCallBack!([self.dataArray![indexPath.row]])
            }
            self.disMiss()
        }
        if _allowsMultipleSelection == true  {
            //如果是多选
            let model = self.dataArray![indexPath.row]
            if model.isSelected!{
                model.isSelected = false
            }else{
                model.isSelected = true
            }
            self.tableView?.reloadData()
        }
    }
}

//MARK: -出现和隐藏方法
extension TQCategoryMutipleChooseView{
    func show(){
        let window : UIWindow? = (UIApplication.shared.delegate?.window)!
        window?.addSubview(self)
        self.snp.makeConstraints { (make) in
            make.top.right.left.equalTo(0)
            make.bottom.equalTo((isIphoneX ? -34.0 : 0))
        }
        tableView?.snp.updateConstraints({ (make) in
            make.height.equalTo(tqHeight!)
        })
        UIView.animate(withDuration: 0.2) {
            self.backgroundColor = UIColor(white: 0.0, alpha: 0.3)
        }
//        self.isHidden = true
        //获取网络数据
//        self.loadHnadInfo()
    }
    
    fileprivate func disMiss(){
        UIView.animate(withDuration: 0.2, animations: {
            self.backgroundColor = UIColor(white: 0.0, alpha: 0.0)
        }) { (finished) in
          self.removeFromSuperview()
        }
    }
}

//MARK: -根据传进来的id获取数据
extension TQCategoryMutipleChooseView{
    //获取办理所需的信息
    fileprivate func loadHnadInfo(){
        var dic : NSDictionary?
        TQHUD.hudWait()
        self._remofer.getHandInfoWith(issueStepId:issueStepId) {[weak self] (status, responseData, message) in
            TQHUD.hide()
            if status == TQResponseStatus.tq_success && responseData != nil{
                dic = responseData as? NSDictionary
                if self?.chooseType != nil{
                    self?.getDataWithHandType(type: (self?.chooseType)!, dic: dic)
                }
            }
        }
        self.isHidden = false
    }
    //根据获取到的办理所需信息，进行数组赋值
    fileprivate func getDataWithHandType(type:String?,dic:NSDictionary?){
        var currentArray : [chooseModel]? = [chooseModel]()
        
        if dic!["targetOrgs"] != nil{
            let orgDic = dic!["targetOrgs"] as? NSDictionary
            if type == "submit" || type == "close" {//上报或者结案
                currentArray?.removeAll()
                if orgDic!["submitAdmin"] != nil{
                    let submitAdmins : [NSDictionary]? = orgDic?["submitAdmin"] as? [NSDictionary]
                    for item in submitAdmins!{
                        let orgModel = chooseModel(dictionary: item, type: "org")
                        currentArray?.append(orgModel)
                    }
                }
                if orgDic!["submitFun"] != nil{
                    let submitFuns : [NSDictionary]? = orgDic?["submitFun"] as? [NSDictionary]
                    for item in submitFuns!{
                        let orgModel = chooseModel(dictionary: item, type: "org")
                        currentArray?.append(orgModel)
                    }
                }
                self.dataArray = currentArray
                tableView?.snp.updateConstraints({ (make) in
                    make.height.equalTo(tqHeight!)
                })
                self.tableView?.reloadData()
            }
            if type == "assign"{//交办
                currentArray?.removeAll()
                if orgDic!["assignAdmin"] != nil{
                    let assignAdmins: [NSDictionary]? = orgDic?["assignAdmin"] as? [NSDictionary]
                    for item in assignAdmins!{
                        let orgModel = chooseModel(dictionary: item, type: "org")
                        currentArray?.append(orgModel)
                    }
                }
                if orgDic!["assignFun"] != nil{
                    let assignFuns :[NSDictionary]? = orgDic?["assignFun"] as? [NSDictionary]
                    for item in assignFuns!{
                        let orgModel = chooseModel(dictionary: item, type: "org")
                        currentArray?.append(orgModel)
                    }
                }
               self.dataArray = currentArray
                tableView?.snp.updateConstraints({ (make) in
                    make.height.equalTo(tqHeight!)
                })
                self.tableView?.reloadData()
            }
            
        }
        if type == "canDoList" {
            currentArray?.removeAll()
            if dic!["canDoList"] != nil{
                let doList : [NSDictionary]? = dic!["canDoList"] as? [NSDictionary]
                for item in doList!{
                    let model = chooseModel(dictionary: item, type: "handType")
                    currentArray?.append(model)
                }
            }
            self.dataArray = currentArray
            tableView?.snp.updateConstraints({ (make) in
                make.height.equalTo(tqHeight!)
            })
            self.tableView?.reloadData()
        }
    }
}

/***********************************
 cell
 **********************************/

class MutipleCell: UITableViewCell {
    fileprivate var cellTextLab: UILabel?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: UITableViewCellStyle.default, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = UITableViewCellSelectionStyle.none
        self.setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.selectionStyle = UITableViewCellSelectionStyle.none
        self.setUpView()
    }
    
    fileprivate func setUpView(){
        cellTextLab = UILabel()
        cellTextLab?.font = UIFont.systemFont(ofSize: 14.0)
        self.contentView.addSubview(cellTextLab!)
        cellTextLab?.snp.makeConstraints({ (make) in
            make.left.equalTo(20)
            make.center.equalTo(self.contentView.snp.center)
            make.height.equalTo(20)
            make.right.equalTo(-20)
        })
    }
}
//MARK: - 赋值方法
extension MutipleCell{
    func renderWithData(item:chooseModel?) {
        self.cellTextLab?.text = item?.title
    }
}



class chooseModel: NSObject {
    var title : String?
    var ID : Int?
    var isSelected : Bool? = false
    
     override init() {
        super.init()
    }
    
    init(dictionary:NSDictionary,type:String?) {
        if type == "org"{//网格类型的字典
            title = dictionary["orgName"] as? String
            ID = (dictionary["id"] as? NSNumber)?.intValue
        }
        if type == "handType"{//办理类型字典
            title = dictionary["desc"] as? String
            ID = (dictionary["code"] as? NSNumber)?.intValue
        }
    }
    
}




