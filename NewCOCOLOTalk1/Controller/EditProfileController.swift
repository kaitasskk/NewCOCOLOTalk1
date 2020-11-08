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
                                                             width: view.frame.width, height: 300))
    
    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.setTitle("保存", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.setTitleColor(.systemPink, for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 64, height: 32)
        button.layer.cornerRadius = 32 / 2
        button.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
        return button
    }()
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
    
    @objc func handleSave() {
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
        configureNavigationBar(withTitle: "プロフィール編集")
        view.backgroundColor = .white
        
        tableView.tableHeaderView = headerView
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.tableFooterView = UIView()
        
        headerView.delegate = self
    }
    
    func configureBarButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "キャンセル", style: .plain, target: self, action: #selector(handleDissmissal))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: saveButton)
        navigationItem.rightBarButtonItem?.isEnabled = false
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

extension EditProfileController: EditProfileHeaderDelegate {
    func didTapChangeProfilePhoto() {
        print(1111111111)
    }
    
    
}
