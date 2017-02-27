//
//  NewsContentCellCollectionViewCell.swift
//  JYNetEaseTime
//
//  Created by atom on 2017/2/22.
//  Copyright © 2017年 atom. All rights reserved.
//

import UIKit

class NewsContentCell: UICollectionViewCell {
    
    var title: String? {
        
        didSet {
        
            guard let title = title else {
                return
            }
            
            titleLabel.text = title
        }
    }
    
    var titleLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let random = CGFloat(Float.random())
        self.backgroundColor = UIColor(red: random, green: random, blue: random, alpha: 1)
        
        titleLabel = UILabel()
        contentView.addSubview(titleLabel)
        titleLabel.text = "JYKit"
        titleLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
