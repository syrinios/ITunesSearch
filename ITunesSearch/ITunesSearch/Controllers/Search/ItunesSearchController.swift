//
//  ViewController.swift
//  ITunesSearch
//
//  Created by Syrine Ferjani on 7/31/19.
//  Copyright © 2019 Syrine Ferjani. All rights reserved.
//

import UIKit
import SnapKit
import Reusable

class ItunesSearchController: UIViewController {
    @IBOutlet weak var contentView: UIView!
    
    private let tableView = UITableView()
    var dataSource = ItemListDataSource(searchResult: SearchResult(resultCount: 0, results: []))

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        setupTableView()
        
        let emptyView = EmptyView.fromNib() as EmptyView
        emptyView.mode = .search
        updateContentView(with: emptyView)
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.register(cellType: SearchItemCell.self)
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .clear
    }

    private func updateContentView(with view: UIView) {
        contentView.subviews.forEach({ $0.removeFromSuperview() })
        contentView.addSubview(view)
        view.snp.makeConstraints({ $0.edges.equalToSuperview() })
    }
}

extension ItunesSearchController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        guard let term = searchBar.text else { return }
        SearchManager(item: term, options: nil).searchItems { (res) in
            switch res {
            case .success(let items):
                print("\(items)")
                self.dataSource = ItemListDataSource(searchResult: items)
                self.tableView.reloadData()
                self.updateContentView(with: self.tableView)
            case .failure(let error):
                print("\(error.localizedDescription)")
                let emptyView = EmptyView.fromNib() as EmptyView

                if let error = error as? ItunesSearchError {
                    if error.errorDescription == ItunesSearchError.noData.errorDescription {
                        emptyView.mode = .noData
                    }
                } else {
                    emptyView.mode = .error(error)
                }                
                self.updateContentView(with: emptyView)
            }
        }
    }
}

extension ItunesSearchController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataSource.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.numberOfRows(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: SearchItemCell.self)
        cell.item = dataSource.item(indexPath: indexPath)
        return cell
    }
}
