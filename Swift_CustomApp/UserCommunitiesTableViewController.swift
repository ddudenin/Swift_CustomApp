//
//  UserCommunitiesTableViewController.swift
//  Swift_CustomApp
//
//  Created by Дмитрий on 30.01.2021.
//

import UIKit

var groups: [Group] = [
    Group(name: "Быстрые займы за 5 минут", avatar: UIImage(systemName: "bitcoinsign.circle.fill")),
    Group(name: "Дворец Путина", avatar: UIImage(systemName: "crown.fill")),
    Group(name: "Психология успешных людей", avatar: UIImage(systemName: "star.fill")),
    Group(name: "Барахолка", avatar: UIImage(systemName: "giftcard.fill")),
]

class UserCommunitiesTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "CommunitiesTableViewCell", bundle: .none), forCellReuseIdentifier: "CommunityCell")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommunityCell", for: indexPath) as! CommunitiesTableViewCell
        
        // Configure the cell...
        
        cell.fullNameLabel.text = groups[indexPath.row].name
        cell.photoImageView.image = groups[indexPath.row].avatar
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            groupsGlobal.append(groups[indexPath.row])
            groups.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}