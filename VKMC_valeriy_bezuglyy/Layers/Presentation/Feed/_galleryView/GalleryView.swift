//
//  GalleryView.swift
//  VKMC_valeriy_bezuglyy
//
//  Created by Valeriy Bezuglyy on 11/11/2018.
//  Copyright © 2018 Valeriy Bezuglyy. All rights reserved.
//

import UIKit

class GalleryView: UIView {
    
    var collectionView: UICollectionView
    var pageCtrl: UIPageControl
    var vLine: UIView
    
    var imageLoader: ImageLoader!
    var photoSize: CGSize? {
        didSet {
            updateSectionInset()
        }
    }
    
    var photos: [PhotoSize] {
        didSet {
            pageCtrl.currentPage = 0
            pageCtrl.numberOfPages = photos.count
            collectionView.reloadData()
        }
    }
    
    override init(frame: CGRect) {
        let layout = GalleryCollectionFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 4
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        pageCtrl = UIPageControl(frame: .zero)
        pageCtrl.currentPageIndicatorTintColor = UIColor(red: 0.32, green: 0.51, blue: 0.72, alpha: 1)
        pageCtrl.pageIndicatorTintColor = UIColor(red: 0.32, green: 0.51, blue: 0.72, alpha: 0.32)
        pageCtrl.isUserInteractionEnabled = false
        pageCtrl.backgroundColor = .white

        vLine = UIView(frame: .zero)
        vLine.backgroundColor = UIColor(red: 0.84, green: 0.85, blue: 0.85, alpha: 1)
        
        photos = []
        
        super.init(frame: frame)
        
        addSubview(collectionView)
        addSubview(pageCtrl)
        addSubview(vLine)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(GalleryCell.self, forCellWithReuseIdentifier: "GalleryCell")
        
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let lineWidth = bounds.width * 336.0 / 359.0
        vLine.frame = CGRect(x: (bounds.width - lineWidth) / 2,
                             y: bounds.height - 1,
                             width: lineWidth,
                             height: 1)
        
        let pageHeight: CGFloat = 39
        pageCtrl.frame = CGRect(x: 0,
                                y: vLine.frame.minY - pageHeight,
                                width: bounds.width,
                                height: pageHeight)
        
        collectionView.frame = CGRect(x: 0,
                                      y: 0,
                                      width: bounds.width,
                                      height: pageCtrl.frame.minY)
        updateSectionInset()
    }
    
    func updateSectionInset() {
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout,
            let photoSize = photoSize else { return }
        layout.itemSize = photoSize
        layout.sectionInset = UIEdgeInsets(top: 0,
                                           left: (collectionView.bounds.width - photoSize.width) / 2,
                                           bottom: 0,
                                           right: 0)
    }
}

extension GalleryView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GalleryCell", for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let row = indexPath.row
        
        guard row < photos.count,
            let cell = cell as? GalleryCell else { return }
        
        cell.imageLoader = imageLoader
        cell.update(photos[row])
    }
}

extension GalleryView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let photoSize = photoSize {
            // из-за пересчета высоты использовал высоту коллекции, иначе ошибка в логе "to avoid @the item height must be less than the height of the UICollectionView ..."
            return CGSize(width: photoSize.width, height: collectionView.bounds.height)
        } else {
            return .zero
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        
        let pageWidth = layout.itemSize.width + layout.minimumLineSpacing
        let page = collectionView.contentOffset.x / pageWidth
        
        let currentPage = Int(page.rounded())
        if currentPage < pageCtrl.numberOfPages {
            pageCtrl.currentPage = currentPage
        }
    }
}
