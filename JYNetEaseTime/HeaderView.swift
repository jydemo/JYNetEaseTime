//
//  HeaderView.swift
//  JYNetEaseTime
//
//  Created by atom on 2017/2/21.
//  Copyright © 2017年 atom. All rights reserved.
//

import UIKit
import SnapKit

let JScreenWidth = UIScreen.main.bounds.width
let JScreenHeight = UIScreen.main.bounds.height

protocol HeaderViewDelegate: NSObjectProtocol {
    func categoryHeaderView(headerView: HeaderView, selectedIndex: Int)
}

class HeaderView: UIView {
    fileprivate var categoryScrollView: CategoryScrollView!
    weak var delegate: HeaderViewDelegate?
    var categories: [String]?{
    
        didSet{
            
            categoryScrollView.categories = categories
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        categoryScrollView = CategoryScrollView()
        self.addSubview(categoryScrollView)
        self.backgroundColor = UIColor.gray
        categoryScrollView.categoryDelegate = self
        categoryScrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
    
    func adjustTitle(from frromIndex: Int, to toIndex: Int, scale: Float){
        categoryScrollView.adjustTitle(from: frromIndex, to: toIndex, scale: scale)
        
    }
    func selectTitle(of index: Int){
        
        categoryScrollView.selectButton(withFrom: categoryScrollView.currentIndex, to: index)
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  

}

extension HeaderView: CategoryScrollViewDelegate {

    fileprivate func categoryScrollView(scrollView: CategoryScrollView, selectedButtonIndex: Int){
        delegate?.categoryHeaderView(headerView: self, selectedIndex: selectedButtonIndex)
    }
}

private protocol CategoryScrollViewDelegate: NSObjectProtocol {
    
    func categoryScrollView(scrollView: CategoryScrollView, selectedButtonIndex: Int)
}

private class CategoryScrollView: UIScrollView {
    
    weak var categoryDelegate: CategoryScrollViewDelegate?
    var currentIndex: Int = 0
    private var colorDigit: Float = 209.0

    var categories: [String]? {
        
        didSet{
            
            if let categories = categories {
                
                if categories.count > 0 {
                    
                    setupButtonView(with: categories)
                    selectButton(withFrom: currentIndex, to: 0)
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
    }
    
    func setupButtonView(with categories: [String]){
    
        for (index, category) in categories.enumerated() {
        
            let button = UIButton()
            button.setTitle(category, for: .normal)
            button.addTarget(self, action: #selector(buttonClicked(sender:)), for: .touchUpInside)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            button.setTitleColor(.black, for: .normal)
            button.tag = index
            self.addSubview(button)
            
            button.snp.makeConstraints({ (make) in
                make.centerY.equalTo(self)
                if self.subviews.count == 1 {
                    make.left.equalTo(self.snp.left).offset(15)
                } else if self.subviews.count == self.categories?.count {
                    
                    make.left.equalTo(self.subviews[self.subviews.count - 2].snp.right).offset(15)
                    make.right.equalTo(self).offset(-15)
                } else {
                
                    make.left.equalTo(self.subviews[self.subviews.count - 2].snp.right).offset(15)
                }
            })
        }
    }
    
   @objc private func buttonClicked(sender: UIButton){
        selectButton(withFrom: currentIndex, to: sender.tag)
        categoryDelegate?.categoryScrollView(scrollView: self, selectedButtonIndex: sender.tag)
        
    }
    
    fileprivate func selectButton(withFrom currentIndex: Int, to toIndex: Int){
        
        let redColor = UIColor(red: CGFloat(colorDigit / 255.0), green: 0.0, blue: 0.0, alpha: 1)
        
        if currentIndex == 0 && toIndex == 0 {
            
            let currentButton = subviews[currentIndex] as! UIButton
            currentButton.setTitleColor(redColor, for: .normal)
            currentButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            return
        
        }
        //再次点击选中的标题
        if currentIndex == toIndex {
            
            return
        }
        
        let currentButton = subviews[currentIndex] as! UIButton
        let desButton = subviews[toIndex] as! UIButton
        
        currentButton.setTitleColor(.black, for: .normal)
        desButton.setTitleColor(redColor, for: .normal)
        currentButton.transform = CGAffineTransform(scaleX: 1, y: 1)
        desButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        
        let screenMidX = JScreenWidth / 2
        let desButtonMidX = desButton.frame.minX + desButton.frame.width / 2
        let buttonScrollViewDiff = self.contentSize.width - desButtonMidX
        
        print("contentSize\(self.contentSize.width) +screenMidX+ \(screenMidX) +desButtonMidX+ \(desButtonMidX) ++=buttonScrollViewDiff= \(buttonScrollViewDiff)")
        
        if buttonScrollViewDiff <= screenMidX {
            
            let scrollOffset = CGPoint(x: self.contentSize.width - JScreenWidth, y: 0)
            print("scrollOffset\(scrollOffset)")
            self.setContentOffset(scrollOffset, animated: true)
        } else if desButtonMidX > screenMidX {
            
            let scrollOffset = CGPoint(x: desButtonMidX - screenMidX, y: 0)
            print("scrollOffset\(scrollOffset)")
            self.setContentOffset(scrollOffset, animated: true)
            
        } else if desButtonMidX <= screenMidX {
        
            let scrollOffset = CGPoint(x: 0, y: 0)
            print("scrollOffset\(scrollOffset)")
            self.setContentOffset(scrollOffset, animated: true)
        }
        
        self.currentIndex = toIndex
    }
    
    //过渡效果
    func adjustTitle(from fromIndex: Int, to toIndex: Int, scale: Float){
        
        print("scale\(scale)")
        //当前按钮
        let currentButton = subviews[fromIndex] as! UIButton
        //下一个按钮
        let desButton = subviews[toIndex] as! UIButton
        let crrenColor = UIColor(red: CGFloat((1 - scale) * colorDigit / 255.0), green: 0.0, blue: 0.0, alpha: 1)
        let desColor = UIColor(red: CGFloat(scale * colorDigit / 255.0), green: 0.0, blue: 0.0, alpha: 1)
        //点击后面按钮
        if toIndex > fromIndex {
            //设置颜色
            currentButton.setTitleColor(crrenColor, for: .normal)
            //放大按钮
            currentButton.transform = CGAffineTransform(scaleX: CGFloat(1.2 - 0.2 * scale), y: CGFloat(1.2 - 0.2 * scale))
            //设置颜色
            desButton.setTitleColor(desColor, for: .normal)
            //放大按钮
            desButton.transform = CGAffineTransform(scaleX: CGFloat(1.0 + 0.2 * scale), y: CGFloat(1.0 + 0.2 * scale))
        } else {
            //点击前面按钮
            currentButton.setTitleColor(desColor, for: .normal)
            desButton.setTitleColor(crrenColor, for: .normal)
            currentButton.transform = CGAffineTransform(scaleX: CGFloat(1.0 + 0.2 * scale), y: CGFloat(1.0 + 0.2 * scale))
            desButton.transform = CGAffineTransform(scaleX: CGFloat(1.2 - 0.2 * scale), y: CGFloat(1.2 - 0.2 * scale))
        
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
























