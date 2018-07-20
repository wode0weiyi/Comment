//
//  TQDictionaryChooseListViewCell.swift
//  TQImagePicker
//
//  Created by apple-2 on 2018/2/4.
//  Copyright © 2018年 yaoluxiang. All rights reserved.
//

import UIKit

enum TQDictionaryChooseCell {
    case TQDictionaryChooseCell_single      //展示单一文字
    case TQDictionaryChooseCell_multiple    //复选框
    case TQDictionaryChooseCell_explain     //说明性文字（title：Content）
}

protocol TQDictionaryChooseListViewCellProtocol {
    func updateCellWith(data:AnyObject?, type:TQDictionaryChooseCell)
}
class TQDictionaryChooseListViewCell: UITableViewCell {
    
    
    @IBOutlet weak var _leftButton: UIButton!
    @IBOutlet weak var _titleLabel: UILabel!
    @IBOutlet weak var _textLabel: UILabel!
    
    @IBOutlet weak var _textLabelLeftToSuper: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension TQDictionaryChooseListViewCell:TQDictionaryChooseListViewCellProtocol {
    func updateCellWith(data: AnyObject?, type: TQDictionaryChooseCell) {
        
        _leftButton.isHidden = true
        _titleLabel.isHidden = true
        
        //更新布局
        switch type {
        case TQDictionaryChooseCell.TQDictionaryChooseCell_single:
            print("")
        case TQDictionaryChooseCell.TQDictionaryChooseCell_multiple:
            _leftButton.isHidden = false
            _textLabelLeftToSuper.constant = 20 + 15 + 10
            self.layoutIfNeeded()
        case TQDictionaryChooseCell.TQDictionaryChooseCell_explain:
            _titleLabel.isHidden = false
            _textLabelLeftToSuper.constant = 80 + 15 + 10
        }
        
        // 内容
        if data != nil {
            if data! is String {
                _textLabel.text = data as? String
            }else if data! is [String : Any] {
                let dict = data as! [String : Any]
                if dict["title"] != nil {
                    _titleLabel.text = dict["title"] as? String
                }
                if dict ["text"] != nil {
                    _textLabel.text = dict["text"] as? String
                }
                if dict ["isChoose"] != nil {
                    _leftButton.isSelected = (dict["isChoose"] as? Bool)!
                }
            }
        }
    }
    
}
