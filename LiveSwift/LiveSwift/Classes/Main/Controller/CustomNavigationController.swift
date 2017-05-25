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
        let navBar = UINavigationBar.appearance()
        navBar.setBackgroundImage(UIColor.createImageWithColor(UIColor.hexInt(0x303030)), for: .any, barMetrics: .default)
        navBar.titleTextAttributes = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: CGFloat(17)), NSForegroundColorAttributeName: UIColor.white]
        
        // 全屏pop功能
        guard let targets = interactivePopGestureRecognizer!.value(forKey:  "_targets") as? [NSObject] else { return }
        let targetObjc = targets[0]
        let target = targetObjc.value(forKey: "target")
        let action = Selector(("handleNavigationTransition:"))
        let panGes = UIPanGestureRecognizer(target: target, action: action)
        view.addGestureRecognizer(panGes)
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // 拦截所有push进来的控制器
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if childViewControllers.count > 0 {
            view.endEditing(true)
            let backBtn = UIButton(type: .custom)
            backBtn.setImage(UIImage(named: "back"), for: .normal)
            backBtn.setImage(UIImage(named: "back"), for: .highlighted)
            backBtn.sizeToFit()
            backBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0)
            backBtn.addTarget(self, action: #selector(backBtnClick), for: .touchUpInside)
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
            // 隐藏要push的控制器的tabBar
            viewController.hidesBottomBarWhenPushed = true
            
        }
        super.pushViewController(viewController, animated: animated)
    }
    
    // 返回按钮的点击
    @objc private func backBtnClick() {
        popViewController(animated: true)
    }
}

// MARK: - 解决全屏手势失效
extension CustomNavigationController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return self.childViewControllers.count > 1
    }
}
