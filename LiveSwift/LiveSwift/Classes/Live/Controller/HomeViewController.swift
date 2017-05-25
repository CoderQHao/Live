//
//  HomeViewController.swift
//  LiveSwift
//
//  Created by 郝庆 on 2017/5/25.
//  Copyright © 2017年 Enroute. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

}

extension HomeViewController {
    fileprivate func setupUI() {
        title = "首页"
        view.backgroundColor = UIColor.white
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 64 - 44)
        let homeTitleModels = loadTypesData()
        let titles = homeTitleModels.map({ $0.title })
        let style = HQTitleStyle()
        style.isScrollEnable = true
        style.normalColor = (0,0,0)
        style.selectedColor = (255, 127, 0)
        style.isShowIndicatorView = false
        style.isShowCover = true
        var childVcs = [AnchorViewController]()
        for titleModel in homeTitleModels {
           let anchorVc = AnchorViewController()
            anchorVc.homeTitleModel = titleModel
            childVcs.append(anchorVc)
        }
        let pageView = HQPageView(frame: frame, titles: titles, style: style, childVcs: childVcs, parentVc: self)
        view.addSubview(pageView)
    }
    
    fileprivate func loadTypesData() -> [HomeTitleModel] {
        let path = Bundle.main.path(forResource: "types.plist", ofType: nil)!
        let dataArray = NSArray(contentsOfFile: path) as! [[String : Any]]
        var tempArray = [HomeTitleModel]()
        for dict in dataArray {
            tempArray.append(HomeTitleModel(dict: dict))
        }
        return tempArray
    }
}
