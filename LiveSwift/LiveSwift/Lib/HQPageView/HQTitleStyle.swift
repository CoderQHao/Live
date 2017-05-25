//
//  HQTitleStyle.swift
//  HQPageView
//
//  Created by 郝庆 on 2017/5/8.
//  Copyright © 2017年 Enroute. All rights reserved.
//

import UIKit

class HQTitleStyle {
    
    /// 是否是滚动的Title
    var isScrollEnable: Bool = false
    /// 滚动Title的字体间距
    var titleMargin: CGFloat = 20
    /// Title字体大小
    var font: UIFont = UIFont.systemFont(ofSize: 14.0)
    /// 设置titleView的高度
    var titleHeight: CGFloat = 44
    /// 设置titileView的背景颜色
    var backgroundColor: UIColor = UIColor.white
    
    /// 是否显示底部分割线
    var isShowSplitLine: Bool = true
    /// 底部分割线颜色
    var splitLineColor: UIColor = UIColor.lightGray
    /// 底部分割线的高度
    var splitLineH: CGFloat = 0.5
    
    /// 是否显示底部指示器
    var isShowIndicatorView: Bool = true
    /// 底部滚动条的高度
    var indicatorViewH: CGFloat = 2
    
    /// 是否需要渐变效果
    var isGradualChangeEnabel = true
    /// 普通Title颜色
    var normalColor: (r: CGFloat, g: CGFloat, b: CGFloat) = (0, 0, 0)
    /// 选中Title颜色
    var selectedColor: (r: CGFloat, g: CGFloat, b: CGFloat) = (255, 127, 0)
    
    /// 是否进行缩放
    var isNeedScale: Bool = false
    /// 进行缩放的大小
    var scaleRange: CGFloat = 1.2
    
    /// 是否显示遮盖
    var isShowCover: Bool = false
    /// 遮盖背景颜色
    var coverBgColor: UIColor = UIColor.lightGray
    /// 遮盖左右间隙
    var coverLeftRightMargin: CGFloat = 10
    /// 遮盖上下间隙
    var coverTopBottomMargin: CGFloat = 8
    /// 设置圆角大小
    var coverRadius: CGFloat = 11

    
}
