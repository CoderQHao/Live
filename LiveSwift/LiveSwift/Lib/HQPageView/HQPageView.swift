//
//  HQPageView.swift
//  HQPageView
//
//  Created by 郝庆 on 2017/5/8.
//  Copyright © 2017年 Enroute. All rights reserved.
//

import UIKit

class HQPageView: UIView {
    
    // MARK: 定义属性
    fileprivate var titles: [String]!
    fileprivate var style: HQTitleStyle!
    fileprivate var childVcs: [UIViewController]!
    fileprivate weak var parentVc: UIViewController!
    
    fileprivate var titleView: HQTitleView!
    fileprivate var contentView: HQContentView!
    
    // MARK: 自定义构造函数
    init(frame: CGRect, titles: [String], style: HQTitleStyle, childVcs: [UIViewController], parentVc: UIViewController) {
        super.init(frame: frame)
        
        assert(titles.count == childVcs.count, "标题&控制器个数不同,请检测!!!")
        self.style = style
        self.titles = titles
        self.childVcs = childVcs
        self.parentVc = parentVc
        parentVc.automaticallyAdjustsScrollViewInsets = false
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK:- 设置界面内容
extension HQPageView {
    fileprivate func setupUI() {
        let titleH: CGFloat = style.titleHeight
        let titleFrame = CGRect(x: 0, y: 0, width: frame.width, height: titleH)
        titleView = HQTitleView(frame: titleFrame, titles: titles, style : style)
        titleView.delegate = self
        titleView.backgroundColor = style.backgroundColor
        addSubview(titleView)
        
        let contentFrame = CGRect(x: 0, y: titleH, width: frame.width, height: frame.height - titleH)
        contentView = HQContentView(frame: contentFrame, childVcs: childVcs, parentViewController: parentVc)
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        contentView.delegate = self
        addSubview(contentView)
    }
}

// MARK: - HQTitleViewDelegate && HQContentViewDelegate
extension HQPageView: HQTitleViewDelegate, HQContentViewDelegate {
    func titleView(_ titleView: HQTitleView, selectedIndex index: Int) {
        contentView.setCurrentIndex(index)
    }
    
    func contentView(_ contentView: HQContentView, index: Int) {
        titleView.getSelectedIndex(index)
    }
    
    func contentView(_ contectView: HQContentView, scale: CGFloat) {
        titleView.setScale(scale)
    }
}
