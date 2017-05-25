//
//  HQTitleView.swift
//  HQPageView
//
//  Created by 郝庆 on 2017/5/8.
//  Copyright © 2017年 Enroute. All rights reserved.
//

import UIKit

protocol HQTitleViewDelegate: class {
    func titleView(_ titleView: HQTitleView, selectedIndex index: Int)
}

class HQTitleView: UIView {
    
    // MARK: 定义属性
    fileprivate var titles: [String]!
    fileprivate var style: HQTitleStyle!
    fileprivate lazy var titleLabels: [UILabel] = [UILabel]()
    weak var delegate : HQTitleViewDelegate?
    fileprivate let indicatorView = UIView()
    
    // MARK: - 懒加载
    fileprivate lazy var titleScrollView: UIScrollView = {
        $0.showsHorizontalScrollIndicator = false
        $0.scrollsToTop = false
        $0.bounces = false
        $0.frame = self.bounds
        return $0
    }(UIScrollView())
    
    // 底部分割线
    fileprivate lazy var splitLineView: UIView = {
        $0.backgroundColor = self.style.splitLineColor
        $0.frame = CGRect(x: 0, y: self.frame.height - self.style.splitLineH, width: self.frame.width, height: self.style.splitLineH)
        return $0
    }(UIView())
    
    // 遮盖的View
    fileprivate lazy var coverView: UIView = {
        $0.backgroundColor = self.style.coverBgColor
        $0.alpha = 0.7
        return $0
    }(UIView())

    // MARK: 自定义构造函数
    init(frame: CGRect, titles: [String], style: HQTitleStyle) {
        super.init(frame: frame)
        self.titles = titles
        self.style = style
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK:- 设置UI界面
extension HQTitleView {
    fileprivate func setupUI() {
        // 添加Scrollview
        addSubview(titleScrollView)
        
        // 添加底部分割线
        if style.isShowSplitLine {
            addSubview(splitLineView)
        }
        
        // 设置所有的标题Label
        setupTitleLabels()
        
        // 设置Label的位置
        setupTitleLabelsPosition()
        
        // 添加底部的指示器
        if style.isShowIndicatorView {
            setupIndicatorView()
        }
        
        // 添加遮盖的View
        if style.isShowCover {
            setupCoverView()
        }
    }
    
    private func setupTitleLabels() {
        for (index, title) in titles.enumerated() {
            let label = HQTitleLabel()
            label.style = style
            label.tag = index
            label.text = title
            label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(titleLabelClick(_ :))))
            titleLabels.append(label)
            titleScrollView.addSubview(label)
            if (index == 0) { label.scale = 1.0 }
        }
    }
    
    private func setupTitleLabelsPosition() {
        var titleX: CGFloat = 0.0
        var titleW: CGFloat = 0.0
        let titleY: CGFloat = 0.0
        let titleH: CGFloat = frame.height
        let count = titles.count
        for (index, label) in titleLabels.enumerated() {
            if style.isScrollEnable {
                let rect = (label.text! as NSString).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: 0.0), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: style.font], context: nil)
                if style.isNeedScale {
                    titleW = rect.width * style.scaleRange
                } else { titleW = rect.width }
                
                if index == 0 {
                    titleX = style.titleMargin * 0.5
                } else {
                    let preLabel = titleLabels[index - 1]
                    titleX = preLabel.frame.maxX + style.titleMargin
                }
            } else {
                titleW = frame.width / CGFloat(count)
                titleX = titleW * CGFloat(index)
            }
            
            label.frame = CGRect(x: titleX, y: titleY, width: titleW, height: titleH)
        }
        
        if style.isScrollEnable {
            titleScrollView.contentSize = CGSize(width: titleLabels.last!.frame.maxX + style.titleMargin * 0.5, height: 0)
        }
        
    }
    
    private func setupIndicatorView() {
        guard let firstLabel = titleLabels.first as? HQTitleLabel else { return }
        indicatorView.backgroundColor = UIColor(red: style.selectedColor.0 / 255.0, green: style.selectedColor.1 / 255.0, blue: style.selectedColor.2 / 255.0, alpha: 1.0)
        let rect = (firstLabel.text! as NSString).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: 0.0), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: style.font], context: nil)
        if style.isNeedScale {
            indicatorView.frame.size.width = rect.width * style.scaleRange
        } else {
            indicatorView.frame.size.width = rect.width
        }
        indicatorView.frame.size.height = style.indicatorViewH
        indicatorView.center.x = firstLabel.center.x
        indicatorView.center.y = bounds.height - style.indicatorViewH
        titleScrollView.addSubview(indicatorView)
    }
    
    private func setupCoverView() {
        titleScrollView.insertSubview(coverView, at: 0)
        let firstLabel = titleLabels.first as! HQTitleLabel
        let rect = (firstLabel.text! as NSString).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: 0.0), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: style.font], context: nil)
        var coverW: CGFloat = 0.0
        var coverH: CGFloat = 0.0
        if style.isNeedScale {
            coverW = rect.width * style.scaleRange + style.coverLeftRightMargin
            coverH = rect.height * style.scaleRange + style.coverTopBottomMargin
        } else {
            coverW = rect.width + style.coverLeftRightMargin
            coverH = rect.height + style.coverTopBottomMargin
        }
        coverView.frame.size.width = coverW
        coverView.frame.size.height = coverH
        coverView.center.x = firstLabel.center.x
        coverView.center.y = firstLabel.center.y
        coverView.layer.cornerRadius = style.coverRadius
        coverView.layer.masksToBounds = true
    }
}

// MARK:- 事件处理
extension HQTitleView {
    @objc fileprivate func titleLabelClick(_ tap : UITapGestureRecognizer) {
        // 取出被点击label的索引
        guard let index = tap.view?.tag else { return }
        delegate?.titleView(self, selectedIndex: index)
    }
}

// MARK: - 对外暴露的方法
extension HQTitleView {
    func getSelectedIndex(_ selectedIndex: Int) {

        // 如果是不需要滚动,则不需要调整中间位置
        guard style.isScrollEnable else {
            for otherLabel in titleLabels {
                let label = titleLabels[selectedIndex] as! HQTitleLabel
                guard let otherLabel = otherLabel as? HQTitleLabel else { return }
                if (otherLabel != label) { otherLabel.scale = 0.0 }
                label.scale = 1.0
            }
            return
        }
        
        // 让对应的顶部标题居中显示
        let width = bounds.width
        let label = titleLabels[selectedIndex] as! HQTitleLabel
        var titleOffset = self.titleScrollView.contentOffset
        titleOffset.x = label.center.x - width * 0.5
        
        // 左边超出处理
        if (titleOffset.x < 0) { titleOffset.x = 0 }
        // 右边超出处理
        let maxTitleOffsetX = titleScrollView.contentSize.width - width
        if (titleOffset.x > maxTitleOffsetX) { titleOffset.x = maxTitleOffsetX }
        
        titleScrollView.setContentOffset(titleOffset, animated: true)
        
        // 让其他label回到最初的状态
        for otherLabel in titleLabels {
            guard let otherLabel = otherLabel as? HQTitleLabel else { return }
            if (otherLabel != label) { otherLabel.scale = 0.0 }
            label.scale = 1.0
        }
    }
    
    func setScale(_ scale: CGFloat) {
        
        // 获得需要操作的左边label
        let leftIndex = Int(scale)
        
        let leftLabel = titleLabels[leftIndex] as! HQTitleLabel
        
        // 获得需要操作的右边label
        let rightIndex = leftIndex + 1
        
        guard let rightLabel = (rightIndex == self.titleLabels.count) ? leftLabel : titleLabels[rightIndex] as? HQTitleLabel else { return }
        
        // 右边比例
        let rightScale = scale - CGFloat(leftIndex)
        
        // 左边比例
        let leftScale = 1 - rightScale
        // 设置label的比例
        if style.isGradualChangeEnabel {
            
            rightLabel.scale = rightScale
            leftLabel.scale = leftScale
        }
    
        let leftRect = (leftLabel.text! as NSString).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: 0.0), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: self.style.font], context: nil)
        let rightRect = (rightLabel.text! as NSString).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: 0.0), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: self.style.font], context: nil)
        
        // 改变指示器的位置
        if style.isShowIndicatorView {
            UIView.animate(withDuration: 0.15, animations: {
                self.indicatorView.center.x = leftLabel.center.x + (rightLabel.center.x - leftLabel.center.x) * rightScale
                if self.style.isNeedScale {
                    self.indicatorView.frame.size.width = self.style.scaleRange * (leftRect.width + (rightRect.width - leftRect.width) * rightScale)
                } else {
                    self.indicatorView.frame.size.width = leftRect.width + (rightRect.width - leftRect.width) * rightScale
                }
            })
        }
        
        // 遮盖移动
        if style.isShowCover {
            self.coverView.center.x = leftLabel.center.x + (rightLabel.center.x - leftLabel.center.x) * rightScale
            UIView.animate(withDuration: 0.15, animations: {
                 if self.style.isNeedScale {
                    self.coverView.frame.size.width = self.style.scaleRange * (leftRect.width + self.style.coverLeftRightMargin + (rightRect.width - leftRect.width) * rightScale)
                 } else {
                    self.coverView.frame.size.width = leftRect.width + self.style.coverLeftRightMargin + (rightRect.width - leftRect.width) * rightScale
                }
            })
        }
        
    }
}
