//
//  MainViewController.swift
//  LiveSwift
//
//  Created by 郝庆 on 2017/5/25.
//  Copyright © 2017年 Enroute. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAllChildControllers()
        setupTabBar()
    }
    
    /// 创建所有的子控制器
    private func setupAllChildControllers() {
        setupOneChildController(vc: LiveViewController(), imageName: "live", title: "直播")

        let vc1 = UIViewController()
        vc1.view.backgroundColor = UIColor.white
        let vc2 = UIViewController()
        vc2.view.backgroundColor = UIColor.white
        let vc3 = UIViewController()
        vc3.view.backgroundColor = UIColor.white

        setupOneChildController(vc: vc1, imageName: "ranking", title: "排行")
        setupOneChildController(vc: vc2, imageName: "found", title: "发现")
        setupOneChildController(vc: vc3, imageName: "mine", title: "我的")
    }
    
    /// 创建一个子控制器
    private func setupOneChildController(vc: UIViewController, imageName: String, title: String) {
        let nav = CustomNavigationController(rootViewController: vc)
        vc.tabBarItem.title = title
        vc.tabBarItem.image = UIImage(named: imageName + "-n")
        vc.tabBarItem.selectedImage = UIImage(named: imageName + "-p")
        vc.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -2)
        addChildViewController(nav)
    }
    
    /// 设置TabBar的样式
    private func setupTabBar() {
        tabBar.isTranslucent = false
        tabBar.backgroundImage = UIColor.createImageWithColor(UIColor.white)
        // 设置TabBar的字体
        let item = UITabBarItem.appearance()
        item.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.hexInt(0xbdbbbc)], for: .normal)
        item.setTitleTextAttributes([NSForegroundColorAttributeName: #colorLiteral(red: 0.8431372549, green: 0.6392156863, blue: 0.3058823529, alpha: 1)], for: .selected)
    }
    
}
