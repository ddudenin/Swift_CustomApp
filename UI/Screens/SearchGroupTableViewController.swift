//
//  SearchGroupTableViewController.swift
//  Swift_CustomApp
//
//  Created by Дмитрий Дуденин on 30.01.2021.
//

import UIKit
import RealmSwift

final class SearchGroupTableViewController: UITableViewController {
    
    @IBOutlet private var searchBar: UISearchBar!
    
    private var searchGroups = [RLMGroup]()
    private var groupDisplayItems = [GroupDisplayItem]()
    
    private let networkManager = NetworkManager.instance
    private let realmManager = RealmManager.instance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "GroupsTableViewCell", bundle: .none), forCellReuseIdentifier: "GroupCell")
        
        self.searchBar.delegate = self
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchGroups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as! GroupsTableViewCell
        
        // Configure the cell...
        let group = self.groupDisplayItems[indexPath.row]
        cell.configure(withGroup: group)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        do {
            try realmManager?.add(object: self.searchGroups[indexPath.row])
        } catch {
            print(error.localizedDescription)
        }
        self.navigationController?.popViewController(animated: true)
    }
}

extension SearchGroupTableViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            return
        }
        
        self.networkManager.loadGroups(searchText: searchText) { [weak self] (items) in
            self?.searchGroups = items
            self?.groupDisplayItems = items.map { GroupDisplayItemFactory.make(for: $0) }
            
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
}
