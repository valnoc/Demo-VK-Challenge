//
//  FeedViewController.swift
//  VKMC_valeriy_bezuglyy
//
//  Created by Valeriy Bezuglyy on 09/11/2018.
//  Copyright © 2018 Valeriy Bezuglyy. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {

    var interactor: FeedInteractorInput
    
    var tableViewCtrl: UITableViewController
    var tableAdapter: FeedTableAdapter
    
    init(interactor: FeedInteractorInput,
         imageLoader: ImageLoader) {
        self.interactor = interactor

        tableViewCtrl = UITableViewController(style: .plain)
        tableAdapter = FeedTableAdapterImpl(tableViewController: tableViewCtrl,
                                            imageLoader: imageLoader)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor.loadInitialData()
        
        tableAdapter.onRefresh = { [weak self] in
            guard let __self = self else { return }
            __self.interactor.refresh()
        }
        
        tableAdapter.onScrolledToNextPage = { [weak self] in
            guard let __self = self else { return }
            __self.interactor.loadNextPage()
        }
    }
    
    override func loadView() {
        super.loadView()
        
        view.backgroundColor = .white
        
        //-- из фигмы
        let layer0 = CAGradientLayer()
        layer0.colors = [
            UIColor(red: 0.97, green: 0.97, blue: 0.98, alpha: 1).cgColor,
            UIColor(red: 0.92, green: 0.93, blue: 0.94, alpha: 1).cgColor
        ]
        layer0.locations = [0, 1]
        layer0.startPoint = CGPoint(x: 0.25, y: 0.5)
        layer0.endPoint = CGPoint(x: 0.75, y: 0.5)
        layer0.transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: 0, b: 1, c: -1, d: 0, tx: 0.5, ty: 0))
        layer0.bounds = view.bounds.insetBy(dx: -0.5*view.bounds.size.width, dy: -0.5*view.bounds.size.height)
        layer0.position = view.center        
        view.layer.addSublayer(layer0)
        //--
        
        let tableView = tableViewCtrl.tableView!
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableAdapter.layoutViews()
    }
}

extension FeedViewController: FeedInteractorOutput {
    func didUpdate(feedItems: [FeedItem]) {
        tableAdapter.update(feedItems: feedItems)
    }
    
    func didLoadAllItems(_ count: Int) {
        tableAdapter.update(totalItems: count)
    }
    
    func didLoad(user: User) {
        if let photo100 = user.photo100 {
            tableAdapter.update(avatar: photo100)
        }
    }    
}
