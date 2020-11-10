//
//  EditProfileController.swift
//  NewCOCOLOTalk1
//
//  Created by 志村　啓太 on 2020/11/11.
//

import UIKit

private let reuseIdentifier = "EditProfileCell"

protocol EditProfileControllerDelegate: class {
    func controller(_ controller: EditProfileController, wantsToUpdate user: User)
}

class EditProfileController: UITableViewController {
    
    //MARK: Properties
    
    private var user: User
    
    private lazy var headerView = EditProfileHeader(user: user)
    private let imagePicker = UIImagePickerController()
    
    private var selectedImage: UIImage? {
        didSet { headerView.profileImageView.image = selectedImage }
    }
    
    private var imageChanged: Bool {
        return selectedImage != nil
    }
    
    private var userInfoChanged = false
    weak var delegate: EditProfileControllerDelegate?
    
    private lazy var saveButton: UIButton = {
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
    
    init(user: User) {
        self.user = user
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureTableView()
        configureImagePicker()
    }
    
    //MARK: Selectors
    
    @objc func handleDissmissal() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleSave() {
        view.endEditing(true)
        self.showLoader(true)
        self.showLoader(false)
        updateUserData()
    }
    
    //MARK: API
    
    func updateUserData() {
        if imageChanged && !userInfoChanged {
            updateProfileImage()
        } else if userInfoChanged && !imageChanged {
            UserService.saveUserData(user: user) { error in
                self.delegate?.controller(self, wantsToUpdate: self.user)
            }
        } else if userInfoChanged && imageChanged {
            UserService.saveUserData(user: user) { error in
                self.updateProfileImage()
            }
        } else {
            self.showError("プロフィールが編集されていません。")
        }
    }
    
    func updateProfileImage() {
        guard let image = selectedImage else { return }
        
        UserService.updateProfileaImage(image: image) { profileImageUrl in
            self.user.profileImageUrl = profileImageUrl
            self.delegate?.controller(self, wantsToUpdate: self.user)
        }
    }
    
    //MARK: Helpers
    
    func configureNavigationBar() {
        configureNavigationBar(withTitle: "プロフィール編集")
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "キャンセル", style: .plain, target: self, action: #selector(handleDissmissal))
        navigationController?.navigationBar.tintColor = .white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: saveButton)
    }
    
    func configureTableView() {
        tableView.tableHeaderView = headerView
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 230)
        headerView.delegate = self
        tableView.tableFooterView = UIView()
        
        tableView.register(EditProfileCell.self, forCellReuseIdentifier: reuseIdentifier)
        
    }
    
    func configureImagePicker() {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
    }
}

//MARK: UITableViewDataSource

extension EditProfileController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EditProfileOptions.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! EditProfileCell
        
        cell.delegate = self
        
        guard let option = EditProfileOptions(rawValue: indexPath.row) else { return cell }
        cell.viewModel = EditProfileViewModel(user: user, option: option)
        cell.contentView.isUserInteractionEnabled = false
        return cell
    }
}

//MARK: UITableViewDelegate

extension EditProfileController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let option = EditProfileOptions(rawValue: indexPath.row) else { return 0}
        
        return option == .bio ? 200 : 50
    }
}

//MARK: EditProfileHeaderDelegate

extension EditProfileController: EditProfileHeaderDelegate {
    func didTapChangePhoto() {
        present(imagePicker, animated: true, completion: nil)
    }
}

//MARK: UIImagePickerControllerDelegate

extension EditProfileController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.editedImage] as? UIImage else { return }
        self.selectedImage = image
        dismiss(animated: true, completion: nil)
    }
}

//MARK: EditProfileCellDelegate

extension EditProfileController: EditProfileCellDelegate {
    func updateUserInfo(_ cell: EditProfileCell) {
        guard let viewModel = cell.viewModel else { return }
        userInfoChanged = true
        
        switch viewModel.option {
        case .fullname:
            guard let fullname = cell.infoTextField.text else { return }
            user.fullname = fullname
        case .username:
            guard let username = cell.infoTextField.text else { return }
            user.username = username
        case .sick:
            guard let sick = cell.infoTextField.text else { return }
            user.sick = sick
        case .bio:
            user.bio = cell.bioTextView.text
        }
    }
}
