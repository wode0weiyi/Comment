//
//  AttachmentInfoModel.swift
//  TQImagePicker
//
//  Created by apple-2 on 2018/1/16.
//  Copyright © 2018年 yaoluxiang. All rights reserved.
//

import UIKit
import HandyJSON

class AttachmentInfoModel: NSObject, HandyJSON, NSCoding {
   
    //名称
    var imageName: String?
    
    //
    var imageData: UIImage?
    
    //链接
    var imageUrl: URL?
    
    //大图链接
//    var bigImageUrl:URL?
    
    // 图片网络连接
    var fileActualUrl: String?
    
    //检查中的图片网络连接名称为fileUrl
    var fileUrl: String?
    
    //网络图片id
    var fileID: Int?
    
    override required init() {}
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(imageName, forKey: "imageName")
        aCoder.encode(imageData, forKey: "imageData")
        aCoder.encode(imageUrl, forKey: "imageUrl")
        aCoder.encode(fileID, forKey: "fileID")

    }
    
    required init?(coder aDecoder: NSCoder) {
        
        imageName = aDecoder.decodeObject(forKey: "imageName") as! String?
        imageData = aDecoder.decodeObject(forKey: "imageData") as! UIImage?
        imageUrl = aDecoder.decodeObject(forKey: "imageUrl") as! URL?
        fileID = aDecoder.decodeObject(forKey: "fileID") as! Int?
    }
    
    func mapping(mapper: HelpingMapper) {
        mapper <<< self.imageName <-- "fileName"
        mapper <<< self.fileActualUrl <-- "fileActualUrl"
        //检查中的附件名称为fileUrl
        mapper <<< self.fileUrl <-- "fileUrl"
        mapper <<< self.fileID <-- "id"
    }
}
