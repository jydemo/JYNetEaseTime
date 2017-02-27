//
//  ViewController.swift
//  JYNetEaseTime
//
//  Created by atom on 2017/2/21.
//  Copyright © 2017年 atom. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    fileprivate var headerView: HeaderView!
    fileprivate var contentCollectionView: ContentCollectionView!
    
    
    lazy var categories: [String] = {
        return ["头条", "独家", "NBA", "社会", "历史", "军事", "航空", "要闻", "娱乐", "财经", "趣闻","头条", "独家", "NBA", "社会", "历史"]
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = UIColor.white
        setupView()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return .lightContent
    }
    
    private func setupView() {
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        do {
        
            headerView = HeaderView()
            headerView.delegate = self
            view.addSubview(headerView)
            headerView.categories = categories
            headerView.snp.makeConstraints({ (make) in
                make.left.right.equalToSuperview()
                make.height.equalTo(40)
                make.top.equalTo(self.topLayoutGuide.snp.bottom)
            })
        }
        
        do {
        
            contentCollectionView = ContentCollectionView()
            contentCollectionView.dataSource = self
            contentCollectionView.delegate = self
            contentCollectionView.register(cellClass: NewsContentCell.self, forCellWithReuseIdentifier: "cell")
            view.addSubview(contentCollectionView)
            contentCollectionView.snp.makeConstraints({ (make) in
                make.top.equalTo(headerView.snp.bottom)
                make.left.right.bottom.equalToSuperview()
            })
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
extension ViewController: HeaderViewDelegate {
    
    func categoryHeaderView(headerView: HeaderView, selectedIndex: Int) {
        let indexPath = IndexPath(item: selectedIndex, section: 0)
        contentCollectionView.scrollAffectToOnce()
        contentCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)

    }
}

extension ViewController: ContentCollectionViewDelegate{
    
    func contentCollectionView(_ contentView: ContentCollectionView, didShowViewWith index: Int) {
        
        headerView.selectTitle(of: index)
        
    }
    func contentCollectionView(_ contentView: ContentCollectionView, didScrollForm fromIndex: Int, to toIndex: Int, scale: Float) {
        
        headerView.adjustTitle(from: fromIndex, to: toIndex, scale: scale)
        
    }
}
extension ViewController: ContentCollectionViewDataSource{
    
    func numberOfItems(in collection: UICollectionView) -> Int {
        return categories.count
    }
    func collectionView(_ collectionview: UICollectionView, cellForItemAt indexpath: IndexPath) -> UICollectionViewCell {
        
        var cell = collectionview.dequeueReusableCell(withReuseIdentifier: "cell", for: indexpath) as? NewsContentCell
        
        if let cell = cell {
            
            cell.title = categories[indexpath.item]
            
            return cell
            
        }
        
        cell = NewsContentCell()
        
        cell!.title = categories[indexpath.item]
        
        return cell!
    }
}












