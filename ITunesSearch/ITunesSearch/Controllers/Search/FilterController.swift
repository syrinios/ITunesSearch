//
//  FilterController.swift
//  ITunesSearch
//
//  Created by Syrine Ferjani on 8/1/19.
//  Copyright © 2019 Syrine Ferjani. All rights reserved.
//

import UIKit

protocol ItunesSearchDelegate: class {
    func updateSearch()
}

class FilterController: UIViewController {
    weak var delegate: ItunesSearchDelegate?
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func didTapApplyButton(_ sender: UIButton) {
        if let f = filter {
            MediaCache.save(f)
            delegate?.updateSearch()
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapCloseButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    var filter: Media?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        filter = MediaCache.get()
    }
}

extension FilterController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Media.allValues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterCell", for: indexPath)
        let currentFilter = Media.allValues[indexPath.row]
        cell.selectionStyle = .none
        cell.textLabel?.text = currentFilter.mediaName.firstUppercased
        cell.accessoryType = filter?.mediaName.elementsEqual(currentFilter.mediaName) ?? false ? .checkmark : .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.visibleCells.forEach({ $0.accessoryType = .none })
        let isSelected = filter?.mediaName.elementsEqual(Media.allValues[indexPath.row].mediaName) ?? false
        filter = isSelected ? nil : Media.allValues[indexPath.row]
        tableView.cellForRow(at: indexPath)?.accessoryType = isSelected ? .none : .checkmark
    }
}
