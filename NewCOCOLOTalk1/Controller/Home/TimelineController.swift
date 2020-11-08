//
//  TimelineController.swift
//  NewCOCOLOTalk1
//
//  Created by 志村　啓太 on 2020/11/01.
//

import UIKit
import Firebase

private let reuserIdentifier = "UserCell"

class TimelineController: UITableViewController {
    
    //MARK: Properties
    
    private var users = [User]()
    private var filteredUsers = [User]()
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var inSearchMode: Bool {
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
    }
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        confitureSearchController()
        fatchUsers()
    }
    
    //MARK: API
    
    func fatchUsers() {
        UserService.fatchUsers { users in
            self.users = users
            self.tableView.reloadData()
        }
    }
    
    //MARK: Helper
    
    func configureUI() {
        configureNavigationBar(withTitle: "検索")
        navigationController?.navigationBar.barStyle = .black
        view.backgroundColor = .white
    
        tableView.tableFooterView = UIView()
        tableView.register(UserCell.self, forCellReuseIdentifier: reuserIdentifier)
        tableView.rowHeight = 200
        tableView.keyboardDismissMode = .interactive
    }
    
    func confitureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.showsCancelButton = false
        navigationItem.searchController = searchController
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "ユーザーを検索"
        
        if let textField = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            textField.textColor = .black
            textField.backgroundColor = .white
        }
    }
}

//MARK: UITableViewDataSource

extension TimelineController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inSearchMode ? filteredUsers.count : users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuserIdentifier, for: indexPath) as! UserCell
        cell.user = inSearchMode ? filteredUsers[indexPath.row] : users[indexPath.row]
        cell.selectionStyle = .none
        cell.contentView.isUserInteractionEnabled = false
        return cell
    }
}

//MARK: UISearchResultsUpdating

extension TimelineController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else { return }
        
        filteredUsers = users.filter({ user -> Bool in
            return user.fullname.contains(searchText) || user.username.contains(searchText)
        })
        
        self.tableView.reloadData()
    }
}
