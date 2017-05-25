//
//  HQPageCollectionView.swift
//  HQPageView
//
//  Created by 郝庆 on 2017/5/8.
//  Copyright © 2017年 Enroute. All rights reserved.
//

import UIKit

protocol HQPageCollectionViewDataSource: class {
    func numberOfSections(in pageCollectionView: HQPageCollectionView) -> Int
    func pageCollectionView(_ collectionView: HQPageCollectionView, numberOfItemsInSection section: Int) -> Int
    func pageCollectionView(_ pageCollectionView: HQPageCollectionView ,_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
}

protocol HQPageCollectionViewDelegate: class {
    func pageCollectionView(_ pageCollectionView: HQPageCollectionView, didSelectItemAt indexPath: IndexPath)
}

class HQPageCollectionView: UIView {
    
    weak var dataSource: HQPageCollectionViewDataSource?
    weak var delegate: HQPageCollectionViewDelegate?
    
    fileprivate var titles: [String]
    fileprivate var isTitleInTop: Bool
    fileprivate var style: HQTitleStyle
    fileprivate var layout: HQPageCollectionViewLayout
    fileprivate var collectionView: UICollectionView!
    fileprivate var pageControl: UIPageControl!
    fileprivate var titleView: HQTitleView!
    fileprivate var sourceIndexPath: IndexPath = IndexPath(item: 0, section: 0)
    
    init(frame: CGRect, titles: [String], style: HQTitleStyle, isTitleInTop: Bool, layout: HQPageCollectionViewLayout) {
        self.titles = titles
        self.style = style
        self.isTitleInTop = isTitleInTop
        self.layout = layout
        
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK:- 设置UI界面
extension HQPageCollectionView {
    fileprivate func setupUI() {
        // 1.创建titleView
        let titleY = isTitleInTop ? 0 : bounds.height - style.titleHeight
        let titleFrame = CGRect(x: 0, y: titleY, width: bounds.width, height: style.titleHeight)
        titleView = HQTitleView(frame: titleFrame, titles: titles, style: style)
        titleView.backgroundColor = style.backgroundColor
        addSubview(titleView)
        titleView.delegate = self
        
        // 2.创建UIPageControl
        let pageControlHeight : CGFloat = 20
        let pageControlY = isTitleInTop ? (bounds.height - pageControlHeight) : (bounds.height - pageControlHeight - style.titleHeight)
        let pageControlFrame = CGRect(x: 0, y: pageControlY, width: bounds.width, height: pageControlHeight)
        pageControl = UIPageControl(frame: pageControlFrame)
        pageControl.isEnabled = false
        addSubview(pageControl)
        
        // 3.创建UICollectionView
        let collectionViewY = isTitleInTop ? style.titleHeight : 0
        let collectionViewFrame = CGRect(x: 0, y: collectionViewY, width: bounds.width, height: bounds.height - style.titleHeight - pageControlHeight)
        collectionView = UICollectionView(frame: collectionViewFrame, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        addSubview(collectionView)
        pageControl.backgroundColor = collectionView.backgroundColor
    }
}


// MARK:- 对外暴露的方法
extension HQPageCollectionView {
    func register(cell : AnyClass?, identifier : String) {
        collectionView.register(cell, forCellWithReuseIdentifier: identifier)
    }
    
    func register(nib : UINib, identifier : String) {
        collectionView.register(nib, forCellWithReuseIdentifier: identifier)
    }
    
    func reloadData() {
        collectionView.reloadData()
    }
}


// MARK:- UICollectionViewDataSource
extension HQPageCollectionView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource?.numberOfSections(in: self) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let itemCount = dataSource?.pageCollectionView(self, numberOfItemsInSection: section) ?? 0
        
        if section == 0 {
            pageControl.numberOfPages = (itemCount - 1) / (layout.cols * layout.rows) + 1
        }
        
        return itemCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return dataSource!.pageCollectionView(self, collectionView, cellForItemAt: indexPath)
    }
}

// MARK:- UICollectionViewDelegate
extension HQPageCollectionView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.pageCollectionView(self, didSelectItemAt: indexPath)
    }
    
    /// scrollView结束了滚动动画以后就会调用这个方法（比如 setContentOffset(offset, animated: true);方法执行的动画完毕后）
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        // 1.取出在屏幕中显示的Cell
        let point = CGPoint(x: layout.sectionInset.left + 1 + collectionView.contentOffset.x, y: layout.sectionInset.top + 1)
        guard let indexPath = collectionView.indexPathForItem(at: point) else { return }
        // 2.判断分组是否有发生改变
        if sourceIndexPath.section != indexPath.section {
            // 3.1.修改pageControl的个数
            let itemCount = dataSource?.pageCollectionView(self, numberOfItemsInSection: indexPath.section) ?? 0
            pageControl.numberOfPages = (itemCount - 1) / (layout.cols * layout.rows) + 1
            
            // 3.2.设置titleView位置
            titleView.getSelectedIndex(indexPath.section)
            titleView.setScale(CGFloat(indexPath.section))
            
            // 3.3.记录最新indexPath
            sourceIndexPath = indexPath
        }
        
        // 3.根据indexPath设置pageControl
        pageControl.currentPage = indexPath.item / (layout.cols * layout.rows)
    }
    
    /// 手指松开scrollView后，scrollView停止减速完毕就会调用这个
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewDidEndScrollingAnimation(scrollView)
    }
}


// MARK:- HQTitleViewDelegate
extension HQPageCollectionView: HQTitleViewDelegate {
    func titleView(_ titleView: HQTitleView, selectedIndex index: Int) {
        let indexPath = IndexPath(item: 0, section: index)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
    }
}
