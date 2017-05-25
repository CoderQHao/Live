//
//  CustomNavigationController.swift
//  LiveSwift
//
//  Created by 郝庆 on 2017/5/25.
//  Copyright © 2017年 Enroute. All rights reserved.
//

import UIKit

class CustomNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.interactivePopGestureRecognizer?.delegate = self
    }
    
}

// MARK: - 解决全屏手势失效
extension CustomNavigationController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return self.childViewControllers.count > 1
    }
}
