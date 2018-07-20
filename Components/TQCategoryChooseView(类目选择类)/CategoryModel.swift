//
//  CategoryModel.swift
//  PingAnTong_WenZhou
//
//  Created by 胡志辉 on 2018/1/19.
//  Copyright © 2018年 maomao. All rights reserved.
//

import UIKit
import HandyJSON

class CategoryModel: NSObject, HandyJSON {
    var categoryId: Int?
    
    var content: String?
    
    var childrenNum: Int?
    
    var category: String?
    
    override required init() {
    }
    
    init(dictionary: NSDictionary) {
        
        categoryId = dictionary["id"] as? Int
        
        content = dictionary["content"] as? String
        
        childrenNum = dictionary["childrenNum"] as? Int
        
        category = dictionary["category"] as? String
    }
    
    func mapping(mapper: HelpingMapper) {
        mapper <<< self.categoryId <-- "id"
    }
}
