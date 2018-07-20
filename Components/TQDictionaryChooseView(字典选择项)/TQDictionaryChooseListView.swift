//
//  DictionaryChooseListView.swift
//  TQImagePicker
//
//  Created by apple-2 on 2018/1/26.
//  Copyright © 2018年 yaoluxiang. All rights reserved.
//

import UIKit

fileprivate let ViewTag = 100

class TQDictionaryChooseListView: UIView {

    @IBOutlet weak var _titleLabel: UILabel!
    @IBOutlet weak var _tableView: UITableView!
    @IBOutlet weak var _sureButton: UIButton!
    @IBOutlet weak var _cancelButton: UIButton!
    
    //回调
    var chooseCallBack: ((AnyObject?) -> ())?
    
    //是否可多选(默认为单选)
    fileprivate var _isMultipleChoose: Bool?
    var isMultipleChoose: Bool? {
        get{
            if _isMultipleChoose == nil {
                _isMultipleChoose = false
            }
            return _isMultipleChoose
        }
        set (newValue){
            _isMultipleChoose = newValue
            _listType = TQDictionaryChooseCell.TQDictionaryChooseCell_multiple
//            _tableView.reloadData()
        }
    }
    
    //列表类型
    var _listType: TQDictionaryChooseCell?
    var listType: TQDictionaryChooseCell? {
        get{
            if _listType == nil {
                _listType = TQDictionaryChooseCell.TQDictionaryChooseCell_single
            }
            return _listType
        }
        set (newValue){
            _listType = newValue
            _tableView.reloadData()
        }
    }
    
    //回调参数
    fileprivate var chooseItem: Any?
    
    //数据源
    fileprivate var dataArray: [Any]?
    
    //多选数据源（反填）
    var selectedArray: [Any]?
    
    fileprivate lazy var _reformer: PeopleServiceLogViewModel = {
        let reformer = PeopleServiceLogViewModel()
        return reformer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setUpViews()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    fileprivate func setUpViews() {
        
    }
}

//MARK:事件处理
extension TQDictionaryChooseListView {
    
    @IBAction func sureButtonClick(_ sender: UIButton) {
        
            if chooseItem != nil {
                if self.chooseCallBack != nil {
                    self.chooseCallBack!(chooseItem as AnyObject)
                }
            }
        self.dismiss()
    }
    
    @IBAction func cancelButtonClick(_ sender: UIButton) {
        self.dismiss()
    }

}

//MARK:外部调用逻辑
extension TQDictionaryChooseListView {
    //, isMultipleChoose: Bool
    static func newInstanceWith(array: [Any], title: String) -> TQDictionaryChooseListView?{
        
        let nibView = Bundle.main.loadNibNamed("TQDictionaryChooseListView", owner: nil, options: nil)
        if let view = nibView?.first as? TQDictionaryChooseListView{
            
            view.backgroundColor = UIColor.init(white: 0.5, alpha: 0.5)
            view._sureButton.layer.borderWidth = 1
            view._sureButton.layer.borderColor = UIColor.gray.cgColor
            view._cancelButton.layer.borderWidth = 1
            view._cancelButton.layer.borderColor = UIColor.gray.cgColor
            
            view._tableView.delegate = view
            view._tableView.dataSource = view
            if array == nil || array.count == 0 {
                view.dataArray = ["省", "市", "县"]
                view._listType = .TQDictionaryChooseCell_explain
            }else{
                view.dataArray = array
                view._tableView.reloadData()
            }
            
            if title.count != 0 {
                view._titleLabel.text = title
            }else {
                view._titleLabel.text = "请选择"
            }
            
            view._tableView!.register(UINib(nibName: "TQDictionaryChooseListViewCell", bundle:nil), forCellReuseIdentifier: "TQDictionaryChooseListViewCell")

            return view
        }
        return nil
    }
    
    func show() {
        let window: UIWindow? = (UIApplication.shared.delegate?.window)!
        if window != nil {
            window?.addSubview(self)
            window?.bringSubview(toFront: self)
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
extension TQDictionaryChooseListView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray == nil ? 0 : self.dataArray!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:TQDictionaryChooseListViewCell = tableView.dequeueReusableCell(withIdentifier: "TQDictionaryChooseListViewCell", for: indexPath) as! TQDictionaryChooseListViewCell
        
        var content = dataArray![indexPath.row]
        
        if content is String {
            content = dataArray![indexPath.row] as! String
        }else if content is TQConfigModel {
            let model = dataArray![indexPath.row] as! TQConfigModel
            content = model.displayName!
        }else if content is CheckDetailInfoModel {
            let model = dataArray![indexPath.row] as! CheckDetailInfoModel
            content = model.displayName
        }
        
        var dict = ["text": content]
        switch listType {
        case .TQDictionaryChooseCell_single?:
             cell.updateCellWith(data: content as AnyObject, type: listType!)
            
        case .TQDictionaryChooseCell_multiple?:
            dict ["isChoose"] = false
            if selectedArray != nil && selectedArray?.count != 0{
                for item in selectedArray! {
                    var selectedContent: String?
                    if item is String {
                        selectedContent = item as? String
                    }else if item is TQConfigModel {
                        let model = item as! TQConfigModel
                        selectedContent = model.displayName!
                    }else if item is CheckDetailInfoModel {
                        let model = item as! CheckDetailInfoModel
                        selectedContent = model.displayName
                    }
//                    else if item is TQStaffTypeModel {
//                        let model = item as! TQStaffTypeModel
//                        selectedContent = model.displayName!
//                    }
                    if selectedContent == content as? String {
                        dict ["isChoose"] = true
                    }
                }
            }
            
             cell.updateCellWith(data: dict as AnyObject, type: listType!)
            
        case .TQDictionaryChooseCell_explain?:
            
            dict["title"] = content as! String
            if selectedArray != nil && selectedArray?.count != 0{
                let item = selectedArray![indexPath.row]
                var selectedContent: String?
                if item is String {
                    selectedContent = item as? String
                }else if item is TQConfigModel {
                    let model = selectedArray![indexPath.row] as! TQConfigModel
                    selectedContent = model.displayName!
                }else if item is CheckDetailInfoModel {
                    let model = selectedArray![indexPath.row] as! CheckDetailInfoModel
                    selectedContent = model.displayName!
                }
                dict["text"] = selectedContent
            }
            
            cell.updateCellWith(data: dict as AnyObject, type: listType!)
        default:
            print("")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let content = dataArray![indexPath.row]
        
        switch listType {
        case .TQDictionaryChooseCell_single?:
            chooseItem = content
            
        case TQDictionaryChooseCell.TQDictionaryChooseCell_multiple?:
            //查找当前选择数组中是否有此item，若有则删除，若没有则添加，同时刷新视图
            if selectedArray != nil && selectedArray?.count != 0{
                var hasItem:Bool = false
                var array = selectedArray
                for (index,item) in selectedArray!.enumerated() {
                    var selectedContent: String?
                    if item is String {
                        selectedContent = item as? String
                    }else if item is TQConfigModel {
                        let model = item as! TQConfigModel
                        selectedContent = model.displayName!
                    }else if item is CheckDetailInfoModel {
                        let model = item as! CheckDetailInfoModel
                        selectedContent = model.displayName!
                    }
                    if selectedContent == content as? String {
                        hasItem = true
                        array?.remove(at: index)
                    }
                }
                selectedArray = array
                if !hasItem {
                    selectedArray?.append(content)
                }
                
            }else{
                selectedArray = [content]
            }
            chooseItem = selectedArray
            self._tableView.reloadData()
            
        case TQDictionaryChooseCell.TQDictionaryChooseCell_explain?:
            if indexPath.row == 0 {
                //省
                self.loadProvinceListData()
            }else if indexPath.row == 1{
                //市
                guard let array = selectedArray as? [Any] else {
                    return
                }
                let item = array[0] as! String
                if item.count != 0 {
                    self.loadCityListDataWith(province: item)
                }else{
                    return
                }
            }else if indexPath.row == 2{
                //县
                guard let array = selectedArray as? [Any] else {
                    return
                }
                let item = array[1] as! String
                if item.count != 0 {
                    self.loadCountyListDataWith(city: item)
                }else{
                    return
                }
            }
            
        default:
            print("")
        }
        
    }
}

//MARK:获取列表数据
extension TQDictionaryChooseListView {
    
    func loadTitleArray() {
        self.dataArray = ["省", "市", "县"]
    }
    
    //省
    func loadProvinceListData() {
        _reformer.loadProvinceListData(complete: { (status, responseData, message) in
            
            if responseData != nil {
                let array = responseData as! [Any]
                if array.count != 0 {
                    if let dictView = TQDictionaryChooseListView.newInstanceWith(array: array, title: "省份"){
                        dictView.show()
                        dictView.chooseCallBack = {[weak self] (data) in
                            print(data as Any)
                            if data is String {
                                if self?.selectedArray == nil {
                                    self?.selectedArray = ["","",""]
                                }
                                self?.selectedArray?.replaceSubrange(Range(0..<1), with: [data as! String])
                            }
                            self?._tableView.reloadData()
                            self?.chooseItem = self?.selectedArray
                        }
                    }
                }
            }else {
                if message != nil {
                    TQHUD.hudRemind(text: message)
                }else{
                    TQHUD.hudRemind(text: "获得所有省份出现未知错误")
                }
            }
            
        })
    }
    
    //市
    func loadCityListDataWith(province: String) {
        _reformer.loadCityListDataWith(province: province, complete: { (status, responseData, message) in
            
            if responseData != nil {
                let array = responseData as! [Any]
                if array.count != 0 {
                    if let dictView = TQDictionaryChooseListView.newInstanceWith(array: array, title: "市"){
                        dictView.chooseCallBack = {[weak self] (data) in
                            print(data as Any)
                            if data is String {
                                if self?.selectedArray == nil {
                                    self?.selectedArray = ["","",""]
                                }
                                self?.selectedArray?.replaceSubrange(Range(1..<2), with: [data as! String])
                            }
                            self?._tableView.reloadData()
                            self?.chooseItem = self?.selectedArray
                        }
                        dictView.show()
                    }
                }
            }else {
                if message != nil {
                    TQHUD.hudRemind(text: message)
                }else{
                    TQHUD.hudRemind(text: "获得所有市出现未知错误")
                }
            }
            
        })
    }
    
    //县区
    func loadCountyListDataWith(city: String) {
        _reformer.loadCountyListDataWith(county: city, complete: { (status, responseData, message) in
            if responseData != nil {
                let array = responseData as! [Any]
                if array.count != 0 {
                    if let dictView = TQDictionaryChooseListView.newInstanceWith(array: array, title: "县"){
                        dictView.chooseCallBack = {[weak self] (data) in
                            print(data as Any)
                            if data is String {
                                if self?.selectedArray == nil {
                                    self?.selectedArray = ["","",""]
                                }
                                self?.selectedArray?.replaceSubrange(Range(2..<3), with: [data as! String])
                            }
                            self?._tableView.reloadData()
                            self?.chooseItem = self?.selectedArray
                        }
                        dictView.show()
                    }
                }

            }else {
                if message != nil {
                    TQHUD.hudRemind(text: message)
                }else{
                    TQHUD.hudRemind(text: "获得所有县出现未知错误")
                }
            }
            
        })
    }
    
}
