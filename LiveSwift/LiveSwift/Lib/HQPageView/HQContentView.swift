//
//  HQContentView.swift
//  HQPageView
//
//  Created by 郝庆 on 2017/5/8.
//  Copyright © 2017年 Enroute. All rights reserved.
//

import UIKit

@objc protocol HQContentViewDelegate : class {
    func contentView(_ contentView: HQContentView, index: Int)
    func contentView(_ contectView: HQContentView, scale: CGFloat)
}

private let kHQContentCellID = "kHQContentCellID"

class HQContentView: UIView {
    
    // MARK: 定义属性
    fileprivate var childVcs : [UIViewController]!
    fileprivate weak var parentVc : UIViewController!
    weak var delegate: HQContentViewDelegate?
    
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = self.bounds.size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collectionView.scrollsToTop = false
        collectionView.bounces = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.frame = self.bounds
        collectionView.isPagingEnabled = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kHQContentCellID)
        collectionView.backgroundColor = UIColor.clear
        return collectionView
    }()

    // MARK: 构造函数
    init(frame: CGRect, childVcs: [UIViewController], parentViewController: UIViewController) {
        super.init(frame: frame)
        
        self.childVcs = childVcs
        self.parentVc = parentViewController
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK:- 设置界面内容
extension HQContentView {
    fileprivate func setupUI() {
        for vc in childVcs {
            parentVc.addChildViewController(vc)
        }
        addSubview(collectionView)
    }
}

// MARK: - UICollectionViewDataSource && UICollectionViewDelegate
extension HQContentView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVcs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kHQContentCellID, for: indexPath)
        cell.backgroundColor = UIColor.white
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }
        let childVc = childVcs[indexPath.item]
        childVc.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(childVc.view)
        return cell
    }
    
    /// scrollView结束了滚动动画以后就会调用这个方法（比如 setContentOffset(offset, animated: true);方法执行的动画完毕后）
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        // 一些临时变量
        let width = scrollView.frame.size.width
        let offsetX = scrollView.contentOffset.x
        
        // 当前位置需要显示的控制器的索引
        let index = Int(offsetX / width)
        
        delegate?.contentView(self, index: index)
    }
    
    /// 手指松开scrollView后，scrollView停止减速完毕就会调用这个
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewDidEndScrollingAnimation(scrollView)
    }
    
    /// 只要scrollView在滚动，就会调用
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scale = scrollView.contentOffset.x / scrollView.frame.size.width
        delegate?.contentView(self, scale: scale)
    }
}

// MARK: - 对外暴露的方法
extension HQContentView {
    func setCurrentIndex(_ currentIndex: Int) {
        // 让底部的内容collectionView滚动到对应位置
        var offset = collectionView.contentOffset
        offset.x = CGFloat(currentIndex) * collectionView.bounds.width
        collectionView.setContentOffset(offset, animated: true)
    }    
}

