//
//  EditProfileController.swift
//  NewCOCOLOTalk1
//
//  Created by 志村　啓太 on 2020/11/08.
//

import UIKit
import Firebase

private let reuseIdentifier = "ProfileCell"

class EditProfileController: UITableViewController {
    
    //MARK: Properties
    
    private var user: User? {
        didSet { headerView.user = user }
    }
    
    private lazy var headerView = EditProfileHeader(frame: .init(x: 0, y: 0,
                                                             width: view.frame.width, height: 550))
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureBarButton()
        fatchUser()
    }
    
    //MARK: Selectors
    
    @objc func handleDissmissal() {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: API
    
    func fatchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        UserService.fatchUser(withUid: uid) { user in
            self.user = user
        }
    }
    
    //MARK: Helpers
    
    func configureUI() {
        configureNavigationBar(withTitle: "プロフィール")
        view.backgroundColor = .white
        
        tableView.tableHeaderView = headerView
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.tableFooterView = UIView()
    }
    
    func configureBarButton() {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        button.tintColor = .white
        button.imageView?.setDimensions(width: 25, height: 25)
        button.addTarget(self, action: #selector(handleDissmissal), for: .touchUpInside)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
    }
}

extension EditProfileController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        return cell
    }
}
