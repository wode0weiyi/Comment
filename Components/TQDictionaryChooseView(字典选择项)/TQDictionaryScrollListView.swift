//
//  TQDictionaryScrollListView.swift
//  PingAnTong_WenZhou
//
//  Created by apple-2 on 2018/6/13.
//  Copyright © 2018年 maomao. All rights reserved.
//

import UIKit

fileprivate let middleLeft:CGFloat = 86.5
fileprivate let rightLeft:CGFloat = 172.5

class TQDictionaryScrollListView: UIView {

    @IBOutlet weak var _leftView: UILabel!
    @IBOutlet weak var _middleView: UILabel!
    @IBOutlet weak var _rightView: UILabel!
    @IBOutlet weak var _scrollView: UIScrollView!
    @IBOutlet weak var _closeBotton: UIButton!
    @IBOutlet weak var _titleLabel: UILabel!
    
    
    @IBOutlet weak var _leftLabelLeftToSuper: NSLayoutConstraint!           //0
    @IBOutlet weak var _middleLabelLeftToSuper: NSLayoutConstraint!         //86.5
    @IBOutlet weak var _rightLabelLeftToSuper: NSLayoutConstraint!          //172.5
    
    var titles:[String]?
    
    //回调
    var chooseCallBack: ((AnyObject?) -> ())?
    
    fileprivate var _selectedIndex:Int?
    
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

//MARK:scrollViewDelegate
extension TQDictionaryScrollListView:UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offSet: CGPoint = scrollView.contentOffset
        print("------offset:%f----",offSet)

        if _selectedIndex == 0  {       //当前选中为第一列
            if offSet.x >= middleLeft {
                //换位
                self._leftView.text = self.titles?[0]
                self._middleView.text = self.titles?[1]
                self._rightView.text = ""
                
                self._middleLabelLeftToSuper.constant = middleLeft
                self._rightLabelLeftToSuper.constant = rightLeft
                self.layoutIfNeeded()
                
                _selectedIndex = 1
                
            }else if offSet.x >= 0{
                
                self._middleLabelLeftToSuper.constant = middleLeft - offSet.x
                self._rightLabelLeftToSuper.constant = rightLeft - offSet.x
                self.layoutIfNeeded()
            }
        }else if _selectedIndex == 1{
            if offSet.x <= 0 {
                //换位
                self._leftView.text = ""
                self._middleView.text = self.titles?[0]
                self._rightView.text = self.titles?[1]
                
                self._middleLabelLeftToSuper.constant = middleLeft
                self._leftLabelLeftToSuper.constant = 0
                self.layoutIfNeeded()
                
                _selectedIndex = 0
                
            }else if offSet.x <= middleLeft {
                self._middleLabelLeftToSuper.constant = 2 * middleLeft - offSet.x
                self._leftLabelLeftToSuper.constant = middleLeft - offSet.x
                self.layoutIfNeeded()
            }
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if self._middleLabelLeftToSuper.constant == middleLeft {
            return
        }else{
            if _selectedIndex == 0 {
                //复位
                
                self._middleLabelLeftToSuper.constant = middleLeft
                self._rightLabelLeftToSuper.constant = rightLeft
                self.layoutIfNeeded()
            }else{
                //复位
                
                self._middleLabelLeftToSuper.constant = middleLeft
                self._leftLabelLeftToSuper.constant = 0
                self.layoutIfNeeded()
            }
        }
        
    }
    
}

//MARK:事件处理
extension TQDictionaryScrollListView{
    
    @IBAction func _closeButtonClick(_ sender: UIButton) {
        self.dismiss()
    }
    
}

//MARK:外部调用逻辑
extension TQDictionaryScrollListView {
    //, isMultipleChoose: Bool
    static func newInstanceWith(rowArray: [Any],columnArray:[Any], title: String) -> TQDictionaryScrollListView?{
        
        let nibView = Bundle.main.loadNibNamed("TQDictionaryScrollListView", owner: nil, options: nil)
        if let view = nibView?.first as? TQDictionaryScrollListView{
            
            view.backgroundColor = UIColor.init(white: 0.5, alpha: 0.5)
            view._closeBotton.layer.borderWidth = 1
            view._closeBotton.layer.borderColor = UIColor.gray.cgColor
            view._selectedIndex = 0
            view._scrollView.delegate = view
             view._scrollView.contentSize = CGSize(width: view._scrollView.frame.width * 2 , height: view._scrollView.frame.height)
//            view._tableView.delegate = view
//            view._tableView.dataSource = view
            if rowArray != nil || rowArray.count != 0 {
                view.titles = rowArray as? [String]
                view._middleView.text = rowArray[0] as? String
                view._rightView.text = rowArray[1] as? String
//                view.dataArray = ["省", "市", "县"]
//                view._listType = .TQDictionaryChooseCell_explain
            }else{
//                view.dataArray = array
//                view._tableView.reloadData()
            }
            
            if title.count != 0 {
                view._titleLabel.text = title
            }else {
                view._titleLabel.text = "请选择"
            }
            
//            view._tableView!.register(UINib(nibName: "TQDictionaryChooseListViewCell", bundle:nil), forCellReuseIdentifier: "TQDictionaryChooseListViewCell")
            
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
