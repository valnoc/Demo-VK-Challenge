//
//  FeedTableAdapter.swift
//  VKMC_valeriy_bezuglyy
//
//  Created by Valeriy Bezuglyy on 09/11/2018.
//  Copyright © 2018 Valeriy Bezuglyy. All rights reserved.
//

import UIKit

protocol FeedTableAdapter {
    var onScrolledToNextPage: (() -> Void)? {get set}    
    var onRefresh: (() -> Void)? {get set}
    
    func layoutViews()
    
    func update(avatar: String)
    func update(totalItems: Int)
    func update(feedItems: [FeedItem])
}

class FeedTableAdapterImpl: NSObject, FeedTableAdapter {
    
    unowned var tableViewCtrl: UITableViewController
    unowned var tableView: UITableView
    
    var imageLoader: ImageLoader
    
    var cellVMs: [FeedItemCellVM]
    var isPaginating: Bool {
        didSet {
            updatePaginatingFooter()
        }
    }
    
    var vHeader: HeaderView
    var vFooterActivity: ActivityFooterView
    var vFooterTotal: TotalFooterView
    
    var updWorkItem: DispatchWorkItem?
    var updQueue: DispatchQueue
    
    var kvoContext: UInt8 = 1
    
    var onScrolledToNextPage: (() -> Void)?
    var onRefresh: (() -> Void)?
    
    init(tableViewController: UITableViewController,
         imageLoader: ImageLoader) {
        tableViewCtrl = tableViewController
        tableView = tableViewCtrl.tableView
        
        self.imageLoader = imageLoader
        
        cellVMs = []
        isPaginating = true
        
        vHeader = HeaderView()
        vHeader.imageLoader = imageLoader
        vFooterActivity = ActivityFooterView()
        vFooterTotal = TotalFooterView()
        
        updQueue = DispatchQueue(label: "FeedTableAdapter")
        
        super.init()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.register(FeedItemCell.self, forCellReuseIdentifier: "FeedItemCell")
        
        tableView.estimatedRowHeight = 0
        tableView.addObserver(self, forKeyPath: "contentOffset", options: .new, context: &kvoContext)
        
        let p2RControl = UIRefreshControl(frame: .zero)
        p2RControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableViewController.refreshControl = p2RControl
        
        tableView.tableHeaderView = vHeader
        tableView.keyboardDismissMode = .onDrag
        
        updatePaginatingFooter()
    }
    
    deinit {
        tableView.removeObserver(self, forKeyPath: "contentOffset")
    }
    
    func update(totalItems: Int) {
        vFooterTotal.update(total: totalItems)
        isPaginating = false
    }
    
    func update(avatar: String) {
        vHeader.update(photo: avatar)
    }
    
    func update(feedItems: [FeedItem]) {
        updQueue.async {[weak self] in
            guard let __self = self else { return }
            
            __self.cancelCurrentTableUpdate()
            
            let workItem = DispatchWorkItem { [weak self] in
                guard let __self = self else { return }
                
                let vms = __self.makeCellVMs(from: feedItems)
                
                DispatchQueue.main.async(execute: { [weak self] in
                    guard let __self = self else { return }
                    __self.cellVMs = vms
                    __self.isPaginating = true
                    __self.tableView.reloadData()
                    __self.endRefreshing()
                })
            }
            __self.updWorkItem = workItem
            
            DispatchQueue.global(qos: .userInitiated).async(execute: workItem)
        }
    }
    
    func cancelCurrentTableUpdate() {
        if updWorkItem != nil {
            updWorkItem?.cancel()
            updWorkItem = nil
        }
    }
    
    func makeCellVMs(from feedItems: [FeedItem]) -> [FeedItemCellVM] {
        let calculator = FeedItemCellCalculator()
        
        var width: CGFloat = 320
        DispatchQueue.main.sync { [weak self] in
            guard let __self = self else { return }
            width = __self.tableView.bounds.width
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM в HH:mm"
        
        let maxSinglePhotoWidth = calculator.maxSinglePhotoWidth(cellWidth: width)
        let maxGalleryPhotoWidth = calculator.maxGalleryPhotoSize(cellWidth: width).width
        
        var result: [FeedItemCellVM] = []
        for item in feedItems {
            let vm = FeedItemCellVM()
            
            vm.author = item.author?.fullname()
            vm.avatarPath = item.author?.avatarPath()
            if let date = item.date {
                vm.dateString = dateFormatter.string(from: Date(timeIntervalSince1970: date)).lowercased()
            }
            vm.text = item.text
            
            let photos = item.photos
            if photos.count == 1,
                let photo = photos.first {
                vm.photo = photo.size(forWidth: maxSinglePhotoWidth)
            
            } else if photos.count > 1 {
                vm.galleryPhotos = photos.compactMap({ $0.size(forWidth: maxGalleryPhotoWidth) })
            }
            
            if let likes = item.likes, let count = likes.count { vm.likesCount = count }
            if let comments = item.comments, let count = comments.count { vm.commentsCount = count }
            if let reposts = item.reposts, let count = reposts.count { vm.repostsCount = count }
            if let views = item.views, let count = views.count { vm.viewsCount = count }
            
            (vm.fullLayout, vm.shortLayout) = calculator.makeLayout(vm, width: width)
            vm.isExpanded = !vm.isExpandable
            
            vm.expandAction = { [weak self] (viewModel) in
                guard let __self = self else { return }
                viewModel.isExpanded.toggle()
                __self.tableView.beginUpdates()
                __self.tableView.endUpdates()
            }
            
            result.append(vm)
        }
        return result
    }
    
    func updatePaginatingFooter() {
        if isPaginating {
            tableView.tableFooterView = vFooterActivity
            vFooterActivity.update()
        } else {
            tableView.tableFooterView = vFooterTotal
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        guard isPaginating,
            let onScrolledToNextPage = onScrolledToNextPage else { return }
        if context == &kvoContext,
            let change = change,
            let newOffset = change[NSKeyValueChangeKey.newKey] as? CGPoint {
            
            if (tableView.contentSize.height - newOffset.y) < tableView.bounds.height {
                onScrolledToNextPage()
            }
        }
    }
    
    @objc
    func refresh() {
        if let onRefresh = onRefresh {
            onRefresh()
        }
    }
    
    func endRefreshing() {
        if let refreshControl = tableViewCtrl.refreshControl,
            refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        }
    }
    
    func layoutViews() {
        vHeader.frame = CGRect(x: 0, y: 0,
                               width: tableView.bounds.width, height: 122)        
        vFooterActivity.frame = CGRect(x: 0, y: 0,
                                       width: tableView.bounds.width, height: 44)
        vFooterTotal.frame = CGRect(x: 0, y: 0,
                                    width: tableView.bounds.width, height: 64)
    }
}

extension FeedTableAdapterImpl: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellVMs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedItemCell", for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let row = indexPath.row
        
        guard row < cellVMs.count,
            let cell = cell as? FeedItemCell else { return }
        
        cell.imageLoader = imageLoader
        let vm = cellVMs[row]
        cell.update(vm)
    }
}

extension FeedTableAdapterImpl: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let row = indexPath.row
        
        guard row < cellVMs.count else { return CGFloat.leastNonzeroMagnitude }
        
        let vm = cellVMs[row]
        return vm.layout.height
    }
}
