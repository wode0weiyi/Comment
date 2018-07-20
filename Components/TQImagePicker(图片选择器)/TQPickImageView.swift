//
//  TQPickImageView.swift

/**
*  将imageView封装成可删除的样式
**/

import Foundation
import UIKit

protocol BrokeImageDelegate: NSObjectProtocol {
    
    //点击图片
    func brokeImageDidTapWithIndex(index:Int)
    
    //点击删除
    func brokeImageDidDeleteWithIndex(index:Int)
}

class TQPickImageView: UIView {
    
    
    
    weak var delegate:BrokeImageDelegate?
    
    lazy var imageView:UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill //图片的填充方式
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true //用户交互一定要打开，否则手势不会响应
        //   添加点击手势
        let singleTap = UITapGestureRecognizer.init(target: self, action: #selector(viewTheBigImage(ges:)))
        singleTap.numberOfTapsRequired = 1
        imageView.addGestureRecognizer(singleTap)
        return imageView
    }()
    
    lazy var deleteBtn:UIButton = {
        let deleteBtn = UIButton()
        deleteBtn.setImage(UIImage(named:"imageDelete"), for: UIControlState.normal)
        deleteBtn.addTarget(self, action: #selector(brokeViewDelete), for: UIControlEvents.touchUpInside)
        return deleteBtn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(imageView)
        self.addSubview(deleteBtn)
        
        self.updateConstraints()
    }
    
    func hiddenBtn() {
        deleteBtn.isHidden = true
//        let imageArr: NSMutableArray = NSMutableArray()
    }
    
    override func updateConstraints() {
        
        imageView.snp.makeConstraints { (make) in
            make.top.left.equalTo(self).offset(5)
            make.bottom.right.equalTo(self)
        }
        
        deleteBtn.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 30, height: 30))
            make.top.equalToSuperview().offset(-5)
            make.right.equalToSuperview().offset(5)
        }
        super.updateConstraints()
    }
    
    @objc func brokeViewDelete() {
        self.delegate?.brokeImageDidDeleteWithIndex(index: self.tag)
    }
    
    @objc func viewTheBigImage(ges:UIGestureRecognizer) {
        self.delegate?.brokeImageDidTapWithIndex(index: self.tag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
