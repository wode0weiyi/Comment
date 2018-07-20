//
//  TQPickView.swift
//  TQImagePicker
//
//  Created by apple-2 on 2017/12/27.
//  Copyright © 2017年 yaoluxiang. All rights reserved.
//

/**
 *图片九宫格
 **/

import UIKit
import SnapKit
import PGImagePicker
import Photos
import Kingfisher

/* 屏幕的宽 */
//public let kSCREEN_WIDTH  = UIScreen.main.bounds.size.width
///* 屏幕的高 */
//public let kSCREEN_HEIGHT  = UIScreen.main.bounds.size.height

enum PickViewType {
    case KPickViewType_Upload_Normal            //上传图片 （默认）
    case KPickViewType_Show                     //展示图片（无删除按钮）
    case KPickViewType_Upload_PlaceHolder       //带有占位图上传图片
}

class TQPickView: UIView {
    
    //展示类型
    var pickViewType:PickViewType?
    
    //更新高度回调
    var updateImageViewCallBack:((_ height: Int) -> ())?
    
    //图片数组回调
    var imageArrayCallBack:((_ imageArray: NSMutableArray) -> ())?
    
    //图片数组
    fileprivate var imageArray:NSMutableArray = NSMutableArray()
    
    //高度
    fileprivate var viewHeight = 0
    
    //加号,需要展示时置为false
    fileprivate var hasPlaceHolderImage:Bool = false
    
    //占位图最大图片数
    var maxNum: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    convenience init(type:PickViewType){
        self.init(frame: CGRect.zero)
        pickViewType = type
    }
    
    convenience init(){
        self.init(type: .KPickViewType_Upload_Normal)
    }
}

//MARK: 布局
extension TQPickView {
    
    //更新视图
    fileprivate func updateImageView(){
        
        //        清除之前添加的imageView
        _ = self.subviews.map {
            $0.removeFromSuperview()
        }
        
        //        运用九宫格排序来对图片进行排列
        let kSpaceX = CGFloat(0)//图片横向之间的间隙
        let kSpaceY = CGFloat(7)//图片竖向之间的间隙
        let kWidth = (self.frame.size.width-kSpaceX*2)/3
        let kHeight = kWidth
        
        let lines = 3 //有多少列（每行要显示几张图片）
        
        if imageArray.count > 0 {
            for (index,item) in imageArray.enumerated() {
                
                let imageModel = item as? AttachmentInfoModel
                
                let row =  CGFloat(index%lines) //当前图片应该在第几行
                
                let imageV = TQPickImageView.init(frame: CGRect(x:(kWidth + kSpaceX) * row, y:(kSpaceY+kHeight)*CGFloat(index/lines), width: kWidth, height: kHeight))
                imageV.delegate = self
                
                if imageModel?.imageData != nil {
                    imageV.imageView.image = imageModel?.imageData
                } else {
                    if imageModel?.fileActualUrl != nil {
                        imageModel?.imageUrl = URL(string: imageModel!.fileActualUrl!)
                    }else if imageModel?.fileUrl != nil {
                        imageModel?.imageUrl = URL(string: imageModel!.fileUrl!)
                    }
                    
                    if imageModel?.imageUrl != nil {
                        imageV.imageView.kf.setImage(with: imageModel?.imageUrl, placeholder: UIImage(named: "图片"), options: nil, progressBlock: nil, completionHandler: { (image, _, _, _) in
                            if image != nil{
                                imageV.imageView.image = image
                                imageModel?.imageData = image
                            }
                        })
                    }else{
                        imageV.imageView.image = UIImage(named:"图片")
                    }
                }
                
                imageV.tag = index
                
                //加号隐藏删除按钮
                if pickViewType == .KPickViewType_Upload_PlaceHolder && index == imageArray.count - 1 && hasPlaceHolderImage  {
                    imageV.hiddenBtn()
                }
                
                //show模式下隐藏删除按钮
                if pickViewType == .KPickViewType_Show  {
                    imageV.hiddenBtn()
                }
                
                self.addSubview(imageV)
            }
        }
        
        var allHeight:Int
        let line = CGFloat(imageArray.count%3)
        
        if line == 0 {
            allHeight = Int(CGFloat(imageArray.count/3)*kHeight + kSpaceY*CGFloat(imageArray.count/3))
        }else{
            allHeight = Int(CGFloat(imageArray.count/3+1)*kHeight + kSpaceY*CGFloat(imageArray.count/3))
        }
        if viewHeight != allHeight {
            viewHeight = allHeight
            if self.updateImageViewCallBack != nil {
                self.updateImageViewCallBack!(viewHeight)
            }
        }
        
        //图片数组传递回调
        let imgArray:NSMutableArray? = NSMutableArray()
        imgArray?.addObjects(from: imageArray as! [Any])
        if hasPlaceHolderImage {
            imgArray?.removeLastObject()
        }
        if self.imageArrayCallBack != nil && imgArray != nil {
            self.imageArrayCallBack!(imgArray!)
        }
        
    }
    
    //添加占位图
    func addPlaceholderImage() -> AttachmentInfoModel? {
        let model = AttachmentInfoModel()
        model.imageName = "placeholderImage"
        model.imageData = UIImage(named: "jiahao")
        return model
    }
}

//MARK: 暴露接口
extension TQPickView {
    
    //清除图片
    func cleanImages() {
        self.imageArray = []
        _ = self.updateImageView()
    }
    
    //无占位图传入图片接口
    func updatePickViewWith(imageArray: NSMutableArray) {
        hasPlaceHolderImage = false
        self.imageArray = imageArray
        self.updateImageView()
    }
    
/*
     *function: 占位图模式
     *param: 数据反填时传入AttachmentInfoModel数组,无数据时可传入nil
     *param: 最多可上传图片数量
 */
    func updatePlaceholdImageViewWith(imageArray: NSMutableArray, maxNumber: Int) {
        
        //有图片时
        if imageArray.count != 0 {
            hasPlaceHolderImage = false
//            hasPlaceHolderImage = imageArray.count == maxNumber ? true : false
            
            self.imageArray = imageArray
        }
        //有占位图且图片未达到上限时，最后一张为占位图
        maxNum = maxNumber
        if pickViewType == .KPickViewType_Upload_PlaceHolder && !hasPlaceHolderImage && imageArray.count != maxNum{
            
            let placeHolder:AttachmentInfoModel = self.addPlaceholderImage()!
            self.imageArray.add(placeHolder)
            hasPlaceHolderImage = true
        }
        _ = self.updateImageView()
    }
}

//MARK: 小图点击操作
extension TQPickView: BrokeImageDelegate{
    
    func brokeImageDidTapWithIndex(index: Int) {
        print(index)
        if pickViewType == .KPickViewType_Upload_PlaceHolder && index == imageArray.count - 1 && hasPlaceHolderImage {
            let alertSheet = UIActionSheet(title: "请选择", delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles: "相机", "相册")
            
            let window: UIWindow? = (UIApplication.shared.delegate?.window)!
            alertSheet.show(in: window!)
            return
        }
        
        let view = self.subviews[index] as? TQPickImageView
        let imageView = view?.imageView
        
        //图片数组
        let viewArr:[TQPickImageView] = self.subviews as! [TQPickImageView]
        var imageViewArr:[UIImageView] = []
        if viewArr.count != 0 {
            for item in viewArr {
                let imageView = item.imageView
                imageViewArr.append(imageView)
            }
        }
        //最后一张为加号  不显示大图
        if pickViewType == .KPickViewType_Upload_PlaceHolder && hasPlaceHolderImage {
            imageViewArr.removeLast()
        }
        
        let imagePicker = PGImagePicker(currentImageView: imageView , imageViews: imageViewArr)
        let vc: UIViewController = self.firstViewController()!
        vc.present(imagePicker, animated: false, completion: nil)
    }
    
    func brokeImageDidDeleteWithIndex(index: Int) {
        print(index)
        imageArray.removeObject(at: index)
        //当图片由饱和状态变为不饱和状态时，需要添加占位图
        if pickViewType == .KPickViewType_Upload_PlaceHolder && !hasPlaceHolderImage {
            imageArray = self.placeholderImageArrayWith(array: imageArray)
        }
        
        self.updateImageView()
//        if self.updateImageViewCallBack != nil {
//            self.updateImageViewCallBack!(viewHeight)
//        }
    }
}

//MARK: - 带有占位图上传图片
//MARK: 弹框代理
extension TQPickView: UIActionSheetDelegate{
    
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int){
        print(buttonIndex)
        if buttonIndex == 1 {
            initCameraPicker()
        }else if buttonIndex == 2{
            initPhotoPicker()
        }
    }
}

//MARK: 拍照、相册选择代理
extension TQPickView:UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    func initCameraPicker(){
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .camera
        //在需要的地方present出来
        self.firstViewController()?.present(cameraPicker, animated: true, completion: nil)
    }
    
    func initPhotoPicker(){
        
        weak var weakSelf = self
        let maxSelect = pickViewType == .KPickViewType_Upload_PlaceHolder ? maxNum - self.imageArray.count + 1 : maxNum - self.imageArray.count
        
        _ = self.presentHGImagePicker(maxSelected:maxSelect) { (assets) in
            //结果处理
            let imageArr: NSMutableArray = NSMutableArray()
            
            for asset in assets {
                _ = PHImageManager.default().requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .default, options: nil, resultHandler: { (image, _: [AnyHashable : Any]?) in
                    let imageModel: AttachmentInfoModel = self.transformModelWith(image: image!)!
                    imageModel.imageName = "\(Date.timestampToMillisecond()).jpg"

                    imageArr.add(imageModel)
                    if  imageArr.count == assets.count  {
                        weakSelf?.imageArray.removeLastObject()
                        weakSelf?.imageArray.addObjects( from: imageArr as! [Any])
                        if weakSelf?.pickViewType == .KPickViewType_Upload_PlaceHolder{
                            weakSelf?.imageArray = (weakSelf?.placeholderImageArrayWith(array: (weakSelf?.imageArray)!))!
                        }
                        _ = weakSelf?.updateImageView()
                    }
                })
            }
        }
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if info[UIImagePickerControllerOriginalImage] != nil {
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            let imageModel: AttachmentInfoModel = self.transformModelWith(image: image)!
            if imageArray.count == 0 {
                imageArray.insert(imageModel, at: 0)
            }else{
                imageArray.insert(imageModel, at: imageArray.count - 1)
            }
            if imageArray.count > maxNum {
                imageArray.removeLastObject()
                hasPlaceHolderImage = false
            }
            //        imageArray = self.placeholderImageArrayWith(array: self.imageArray)
            _ = updateImageView()
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    //加号图片处理
    fileprivate func placeholderImageArrayWith(array: NSMutableArray) -> NSMutableArray {
        
        //需要展示占位图时，最后一张为占位图
        if array.count < maxNum{
            let placeHolder:AttachmentInfoModel = self.addPlaceholderImage()!
            array.add(placeHolder)
            hasPlaceHolderImage = true
        }else{
            hasPlaceHolderImage = false
        }
        
        return array
    }
    
    //将UIImage转换成AttachmentInfoModel
    func transformModelWith(image: UIImage) -> AttachmentInfoModel? {
        let model = AttachmentInfoModel()
        model.imageData = image
        return model
    }
}

//MARK: - 获取当前View所在controller的逻辑
extension TQPickView {
    //返回该view所在VC
    fileprivate  func firstViewController() -> UIViewController? {
        for view in sequence(first: self.superview, next: { $0?.superview }) {
            if let responder = view?.next {
                if responder.isKind(of: UIViewController.self){
                    return responder as? UIViewController
                }
            }
        }
        return nil
    }
}

