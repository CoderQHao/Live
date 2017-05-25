//
//  HomeViewModel.swift
//  LiveSwift
//
//  Created by 郝庆 on 2017/5/25.
//  Copyright © 2017年 Enroute. All rights reserved.
//

import UIKit

class HomeViewModel: NSObject {
    lazy var anchorModels = [AnchorModel]()
}

extension HomeViewModel {
    func loadHomeData(type: HomeTitleModel, index: Int, finishedCallback: @escaping () -> ()) {
        let parameters = ["type" : type.type, "index" : index, "size" : 48]
        NetworkTool.requestData(URLString: "http://qf.56.com/home/v4/moreAnchor.ios", type: .get, parameters: parameters) { (result) in
            guard let resultDict = result as? [String : Any] else { return }
            guard let messageDict = resultDict["message"] as? [String: Any] else { return }
            guard let dataArray = messageDict["anchors"] as? [[String: Any]] else { return }
            
            for (index, dict) in dataArray.enumerated() {
                let anchor = AnchorModel(dict: dict)
                anchor.isEvenIndex = index % 2 == 0
                self.anchorModels.append(anchor)
            }
            
            finishedCallback()
        }
    }
}
