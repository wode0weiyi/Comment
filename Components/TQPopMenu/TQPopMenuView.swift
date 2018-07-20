//
//  TQPopMenuView.swift
//  PingAnTong_WenZhou
//
//  Created by maomao on 2018/1/24.
//  Copyright © 2018年 maomao. All rights reserved.
//

import Foundation
import UIKit

public protocol SwiftPopMenuDelegate {
    func swiftPopMenuDidSelectIndex(index:Int,seletedID:Int)
}

class TQPopMenuView: UIView {
    
    public var delegate : SwiftPopMenuDelegate?
    
    
    let KScrW:CGFloat = UIScreen.main.bounds.size.width
    let KScrH:CGFloat = UIScreen.main.bounds.size.height
    
    private var myFrame:CGRect!
    
    private var arrowView : UIView! = nil
    private var arrowViewWidth : CGFloat = 15
    private var arrowViewHeight : CGFloat = 8
    
    
    //／*  -----------------------  可变参数 ------------------------------------------ *／
    
    //小箭头距离右边距离
    public var arrowViewMargin : CGFloat = 15
    //圆角弧度
    public var cornorRadius:CGFloat = 5
    
    //pop文字颜色
    public var popTextColor:UIColor = UIColor.white
    //pop背景色
    public var popMenuBgColor:UIColor = UIColor.black.withAlphaComponent(0.6)
    
    
    
    var tableView:UITableView! = nil
    public var popData:[(ID:Int,title:String)]! = [(ID:Int,title:String)](){
        didSet{
            //计算行
            rowHeightValue = (self.myFrame.height - arrowViewHeight)/CGFloat(popData.count)
            initViews()
        }
        
    }
    
    
    public var didSelectMenuBlock:((_ index:Int,_ seletedID:Int)->Void)?
    
    
    static let cellID:String = "SwiftPopMenuCellID"
    var rowHeightValue:CGFloat = 44
    
    
    
    
    /**
     位置是popmenu相对整个屏幕的位置
     
     - parameter frame: <#frame description#>
     
     - returns: <#return value description#>
     */
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.frame = CGRect(x: 0, y: 0, width: KScrW, height: KScrH)
        myFrame = frame
    }
    
    
    /// 位置是popmenu相对整个屏幕的位置
    ///
    /// - Parameters:
    ///   - frame: <#frame description#>
    ///   - arrowMargin: 箭头距离右边距离
    init(frame: CGRect,arrowMargin:CGFloat) {
        super.init(frame: frame)
        
        arrowViewMargin = arrowMargin
        self.frame = CGRect(x: 0, y: 0, width: KScrW, height: KScrH)
        myFrame = frame
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss()
    }
    
    public func show() {
        UIApplication.shared.keyWindow?.addSubview(self)
    }
    
    public func dismiss() {
        self.removeFromSuperview()
    }
    
    
    func initViews() {
        self.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        //箭头
//        arrowView=UIView(frame: CGRect(x: myFrame.origin.x, y: myFrame.origin.y, width: myFrame.width, height: arrowViewHeight))
//        let layer=CAShapeLayer()
//        let path=UIBezierPath()
//        path.move(to: CGPoint(x:myFrame.width - arrowViewMargin - arrowViewWidth/2, y: 0))
//        path.addLine(to: CGPoint(x: myFrame.width - arrowViewMargin - arrowViewWidth, y: arrowViewHeight))
//        path.addLine(to: CGPoint(x: myFrame.width - arrowViewMargin, y: arrowViewHeight))
//        layer.path=path.cgPath
//        layer.fillColor = popMenuBgColor.cgColor
//        arrowView.layer.addSublayer(layer)
//        self.addSubview(arrowView)
        
        tableView=UITableView(frame: CGRect(x: myFrame.origin.x,y: myFrame.origin.y + arrowViewHeight,width: myFrame.width,height: myFrame.height - arrowViewHeight), style: .plain)
        tableView.register(SwiftPopMenuCell.classForCoder(), forCellReuseIdentifier: TQPopMenuView.cellID)
        tableView.backgroundColor = popMenuBgColor
        tableView.layer.cornerRadius = cornorRadius
        tableView.layer.masksToBounds = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.bounces = false
        tableView.isScrollEnabled = false
        UIView.animate(withDuration: 0.3) {
            self.addSubview(self.tableView)
        }
        
        
        
    }
    
}

class SwiftPopMenuCell: UITableViewCell {
   
    var lblTitle:UILabel!
    var line:UIView!
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.clear
        
        lblTitle = UILabel()
        lblTitle.font = UIFont.systemFont(ofSize: 14)
        lblTitle.textAlignment = .center
        self.contentView.addSubview(lblTitle)
        
        line = UIView()
        line.backgroundColor = UIColor(red: 222/255.0, green: 222/255.0, blue: 222/255.0, alpha: 0.5)
        self.contentView.addSubview(line)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fill(title:String,textColor:UIColor,islast:Bool = false) {
        self.lblTitle.text = title
        self.line.isHidden = islast
        lblTitle.textColor = textColor
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
      
        self.lblTitle.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width , height: self.bounds.size.height)
        self.line.frame = CGRect(x: 0, y: self.frame.size.height - 1, width: self.frame.size.width, height: 1)
        
    }
    
    
}

extension TQPopMenuView : UITableViewDataSource{
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return popData.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if popData.count>indexPath.row {
            let cell = tableView.dequeueReusableCell(withIdentifier: TQPopMenuView.cellID) as! SwiftPopMenuCell
            let model = popData[indexPath.row]
            if indexPath.row == popData.count - 1 {
                cell.fill( title: model.title,textColor: popTextColor, islast: true)
            }else{
                cell.fill(title: model.title,textColor: popTextColor)
            }
            return cell
        }
        
        return UITableViewCell()
    }
    
}

extension TQPopMenuView : UITableViewDelegate{
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let model = popData[indexPath.row]
        
        if self.delegate != nil{
            self.delegate?.swiftPopMenuDidSelectIndex(index: indexPath.row, seletedID: model.ID)
        }
        if didSelectMenuBlock != nil {
            didSelectMenuBlock!(indexPath.row,model.ID)
        }
        
    }
}
