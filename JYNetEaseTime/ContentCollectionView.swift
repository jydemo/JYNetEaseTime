//
//  ContentCollectionView.swift
//  JYNetEaseTime
//
//  Created by atom on 2017/2/22.
//  Copyright © 2017年 atom. All rights reserved.
//

import UIKit

protocol ContentCollectionViewDelegate: NSObjectProtocol {
    func contentCollectionView(_ contentView: ContentCollectionView, didScrollForm fromIndex: Int, to toIndex: Int, scale: Float)
    func contentCollectionView(_ contentView: ContentCollectionView, didShowViewWith index: Int)
}

protocol ContentCollectionViewDataSource: NSObjectProtocol {
    func numberOfItems(in collection: UICollectionView) -> Int
    func collectionView(_ collectionview: UICollectionView, cellForItemAt indexpath: IndexPath) -> UICollectionViewCell
}

class ContentCollectionView: UIView {

    weak var delegate: ContentCollectionViewDelegate?
    weak var dataSource: ContentCollectionViewDataSource?
     
    fileprivate var collectionView: UICollectionView!
    fileprivate var currentOffsetX: Float = 0.0
    fileprivate var toIndex = 0
    fileprivate var oldIndex = 0
    fileprivate var isTapSelected = false
     
    fileprivate var contentCount: Int {
        
        get {
            
            guard let dataSource = dataSource else {
                fatalError("")
            }
            
            return dataSource.numberOfItems(in: collectionView)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    private func setupViews(){
    
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.scrollDirection = .horizontal
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.collectionViewLayout = flowLayout
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func register(cellClass: AnyClass?, forCellWithReuseIdentifier: String){
        
        collectionView.register(cellClass, forCellWithReuseIdentifier: forCellWithReuseIdentifier)
    }
    
    func register(nib: UINib?, forCellWithReuseIndentifer: String){
        
        collectionView.register(nib, forCellWithReuseIdentifier: forCellWithReuseIndentifer)
    }
    
    func scrollToItem(at indexPath: IndexPath, at scrollPosition: UICollectionViewScrollPosition, animated: Bool){
        
        collectionView.scrollToItem(at: indexPath, at: scrollPosition, animated: animated)
    }
    
    
    func scrollAffectToOnce(){
        
        isTapSelected = true
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
    

}

extension ContentCollectionView: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let dataSource = dataSource else {
            fatalError("---")
        }
        return dataSource.numberOfItems(in: collectionView)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let dataSource = dataSource else {
            fatalError("__")
        }
        return dataSource.collectionView(collectionView, cellForItemAt: indexPath)
    }
}

extension ContentCollectionView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return collectionView.bounds.size
    
    }
}

extension ContentCollectionView: UIScrollViewDelegate {

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        currentOffsetX = Float(scrollView.contentOffset.x)
        isTapSelected = false
        currentOffsetX = Float(scrollView.contentOffset.x)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isTapSelected{
            return
        }
        
        let scale = Float(scrollView.contentOffset.x).truncatingRemainder(dividingBy: Float(JScreenWidth)) / Float(JScreenWidth)
        if scale == 0.0 {
            return
        }
        let index = Int(scrollView.contentOffset.x / UIScreen.main.bounds.size.width)
        let diff = Float(scrollView.contentOffset.x) - currentOffsetX
        if diff > 0.0 {
            
            toIndex = index + 1
            oldIndex = index
        }
        if toIndex > contentCount - 1 || toIndex < 0 || oldIndex > contentCount - 1 {
        
            return
        }
        
        delegate?.contentCollectionView(self, didScrollForm: oldIndex, to: toIndex, scale: scale)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if isTapSelected {
            return
        }
        currentOffsetX = Float(scrollView.contentOffset.x)
        toIndex = Int(currentOffsetX / Float(JScreenWidth))
        if toIndex > contentCount - 1 || toIndex < 0 {
            
            return
        }
        delegate?.contentCollectionView(self, didShowViewWith: toIndex)
    }
}

extension ContentCollectionView: UICollectionViewDelegate {


}












































































