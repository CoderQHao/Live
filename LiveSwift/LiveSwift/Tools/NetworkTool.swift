//
//  NetworkTool.swift
//  LiveSwift
//
//  Created by 郝庆 on 2017/5/25.
//  Copyright © 2017年 Enroute. All rights reserved.
//

import UIKit
import Alamofire

enum methodType {
    case get
    case post
}

class NetworkTool {
    class func requestData(URLString: String, type: methodType, parameters: [String: Any]? = nil, finishedCallBack: @escaping (_ result: Any) -> ()) {
        
        let method = type == .get ? HTTPMethod.get : HTTPMethod.post
        Alamofire.request(URLString, method: method, parameters: parameters).responseJSON { (response) in
            
            guard let result = response.result.value else {
                print(response.result.error!)
                return
            }
            
            finishedCallBack(result)
        }
    }
}
