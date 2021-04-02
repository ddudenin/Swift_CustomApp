//
//  GlobalCommunitiesTableViewController.swift
//  Swift_CustomApp
//
//  Created by Дмитрий on 30.01.2021.
//

import UIKit
import RealmSwift

class GlobalCommunitiesTableViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet var searchBar: UISearchBar!
    
    var searchGroups = [GroupItem]()
    
    private let networkManager = NetworkManager.instance
    private let realmManager = RealmManager.instance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "CommunitiesTableViewCell", bundle: .none), forCellReuseIdentifier: "CommunityCell")
        
        self.searchBar.delegate = self
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchGroups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "CommunityCell", for: indexPath) as! CommunitiesTableViewCell
        
        // Configure the cell...
        cell.configure(withGroup: self.searchGroups[indexPath.row])
        
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
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            return
        } else {
            networkManager.loadGroups(searchText: searchText) { [weak self] items in
                self?.searchGroups = items
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
        }
    }
}
