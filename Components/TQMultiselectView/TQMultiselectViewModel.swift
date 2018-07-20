//
//  TQMultiselectViewModel.swift
//  PingAnTong_WenZhou
//
//  Created by 王璇 on 2018/2/27.
//  Copyright © 2018年 maomao. All rights reserved.
//

import Foundation

class TQMultiselectViewModel: BaseReformerPagedHelper {
    
    func loadWorkerWith(org: TQOrgModel, loadMore: Bool, complete: @escaping NetworkFinished) {
        
        if self.canLoadData(loadMore: loadMore) == false {
            complete(.tq_failure, nil, nil)
            return
        }
        
        let parameters = ["rows": "100","sord": "desc","sidx": "id","page": String(self.currentPage),"user.organization.id":NSNumber(integerLiteral: org.orgId!)] as [String : AnyObject]
        
        NetworkTools.shareNetworkTool.cancelTask(key: tq_event_handle_user_url)
        NetworkTools.shareNetworkTool.POST(url: tq_event_handle_user_url, parameters: parameters, identifer: tq_event_handle_user_url) {[weak self] (status, responseData, message) in
            
            if status == .tq_success && responseData != nil {
               self?.requestSuccessPageConfigWith(dictionary: responseData as? NSDictionary)
                
                let users = (responseData as! NSDictionary)["rows"]
                let workers = [UserBaseModel].deserialize(from: users as?  [NSDictionary])
                
                complete(status, workers, nil)
            } else {
                self?.requestFailurePageConfig()
                
                complete(.tq_failure, nil, message)
            }
        }
    }
}
