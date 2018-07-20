//
//  BaseReformerPagedHelper.swift
//  PingAnTong_WenZhou
//
//  Created by 王璇 on 2018/1/22.
//  Copyright © 2018年 maomao. All rights reserved.
//

import Foundation

class BaseReformerPagedHelper: NSObject {
    var canLoadMore = true
    var currentPage = 1
    var totalePage = 0
    var records = 0
    
    /**
     *function:     判断是否需要发起请求，根据刷新方式调整显示页数，在发起网络请求前调用
     *parameter:    是否为上拉加载（0:下拉刷新，1:上拉加载）
     *return:       无
     */
    func canLoadData(loadMore: Bool) -> Bool {
        if (loadMore) {
            if (self.canLoadMore) {
                self.currentPage += 1
                return true
            } else {
                return false
            }
        } else {
            self.currentPage = 1
            return true
        }
    }
    
    /**
     *function:     请求成功分页设置，在网络请求成功响应中调用
     *parameter:    jason字典
     *return:       无
     */
    func requestSuccessPageConfigWith(dictionary: NSDictionary?) {
        if (dictionary != nil && dictionary!.isKind(of: NSDictionary.self)) {
            let currentPage = dictionary!["page"] as! Int
            let totalPage=dictionary!["total"] as! Int
            
            self.canLoadMore = currentPage < totalPage
            self.currentPage = currentPage
            self.totalePage = totalPage
            self.records = dictionary!["records"] as! Int;
        }
    }

    /**
     *function:     请求失败分页设置，在网络请求失败中调用
     *return:       无
     */
    func requestFailurePageConfig() {
        if (self.currentPage > 1) {
            self.currentPage -= 1
        }
    }








}
