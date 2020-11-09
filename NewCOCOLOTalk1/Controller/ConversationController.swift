//
//  ConversationController.swift
//  NewCOCOLOTalk1
//
//  Created by 志村　啓太 on 2020/11/01.
//

import UIKit
import Firebase

private let reuserIdentifier = "ConversationCell"

class ConversationController: UIViewController {
    
    //MARK: Properties
    
    private let tableView = UITableView()
    
    private var user: User? {
        didSet { headerView.user = user }
    }
    
    private lazy var headerView = ProfileHeader(frame: .init(x: 0, y: 0,
                                                             width: view.frame.width, height: 200))
    
    private var users = [User]()
    private var convarsations = [Conversation]()
    private var filteredConversations = [Conversation]()
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var inSearchMode: Bool {
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
    }
    
    private let newMessageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.backgroundColor = .systemPink
        button.tintColor = .white
        button.imageView?.setDimensions(width: 25, height: 25)
        button.addTarget(self, action: #selector(showNewMessage), for: .touchUpInside)
        return button
    }()
    
    private let searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "lightbulb.fill"), for: .normal)
        button.backgroundColor = .systemPink
        button.tintColor = .white
        button.imageView?.setDimensions(width: 25, height: 25)
        button.addTarget(self, action: #selector(showSearch), for: .touchUpInside)
        return button
    }()
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureBarbutton()
        authenticationUser()
        confitureSearchController()
        fatchUser()
        fatchConversations()
    }
    
    //MARK: Selector
    
    @objc func showProfile() {
        let controller = EditProfileController()
        controller.delegate = self
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    @objc func showNewMessage() {
        let controller = NewMessageController()
        controller.delegate = self
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    @objc func showSearch() {
        let controller = SearchController()
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    //MARK: API
    
    func authenticationUser() {
        if Auth.auth().currentUser?.uid == nil {
                presentLoginScreen()
            }
        }
        
        func logUserout() {
            do {
                try Auth.auth().signOut()
                presentLoginScreen()
            } catch {
                print("DEBUG: Error sign out..")
            }
        }

    
    func fatchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        UserService.fatchUser(withUid: uid) { user in
            self.user = user
        }
    }
    
    func fatchConversations() {
        UserService.fatchConversation { convarsations in
            self.convarsations = convarsations
            self.tableView.reloadData()
        }
    }
    
    //MARK: Helper
    
    func presentLoginScreen() {
        DispatchQueue.main.async {
            let controller = LoginController()
            controller.delegete = self
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        }
    }
    
    func configureUI() {
        view.backgroundColor = .white
        
        configureTableView()
        
        configureNavigationBar(withTitle: "トーク")
        navigationController?.navigationBar.barStyle = .black
        
        let stack = UIStackView(arrangedSubviews: [newMessageButton, searchButton])
        stack.axis = .horizontal
        stack.spacing = 15
        
        newMessageButton.setDimensions(width: 55, height: 55)
        newMessageButton.layer.cornerRadius = 55 / 2
        searchButton.setDimensions(width: 55, height: 55)
        searchButton.layer.cornerRadius = 55 / 2
        
        view.addSubview(stack)
        stack.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor,
                     paddingBottom: 15, paddingRight: 25)
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        tableView.backgroundColor = .white
        tableView.frame = view.frame
        tableView.tableHeaderView = headerView
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 80
        tableView.register(ConversationCell.self, forCellReuseIdentifier: reuserIdentifier)
        tableView.keyboardDismissMode = .interactive
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func configureBarbutton() {
        let leftButton = UIButton(type: .system)
        leftButton.setImage(UIImage(systemName: "person.circle.fill"), for: .normal)
        leftButton.tintColor = .white
        leftButton.addTarget(self, action: #selector(showProfile), for: .touchUpInside)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftButton)
    }

    func showChatController(forUser user: User) {
        let controller = ChatController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func confitureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.showsCancelButton = false
        navigationItem.searchController = searchController
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "トークを検索"
        definesPresentationContext = false
        
        if let textField = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            textField.textColor = .black
            textField.backgroundColor = .white
        }
    }
}

extension ConversationController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inSearchMode ? filteredConversations.count : convarsations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuserIdentifier, for: indexPath) as! ConversationCell
        cell.conversation = inSearchMode ? filteredConversations[indexPath.row] : convarsations[indexPath.row]
        return cell
    }
}

extension ConversationController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = inSearchMode
            ? filteredConversations[indexPath.row].user : convarsations[indexPath.row].user
        showChatController(forUser: user)
    }
}

//MARK: NewMessageControllerDelegate

extension ConversationController: NewMessageControllerDelegate {
    func controller(_ controller: NewMessageController, wantsToStartChatwith user: User) {
        dismiss(animated: true, completion: nil)
        showChatController(forUser: user)
    }
}

extension ConversationController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else { return }
        
        filteredConversations = convarsations.filter({ convarsation -> Bool in
            return convarsation.user.fullname.contains(searchText)
                || convarsation.user.username.contains(searchText)
        })
        
        self.tableView.reloadData()
    }
}

//MARK: EditProfileControllerDelegate

extension ConversationController: EditProfileControllerDelegate {
    func handleLogout() {
        logUserout()
    }
}

extension ConversationController: AuthenticationDelegate {
    func authenticationComplete() {
        dismiss(animated: true, completion: nil)
        configureUI()
        configureBarbutton()
        confitureSearchController()
        fatchUser()
        fatchConversations()
    }
}
