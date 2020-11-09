//
//  EditProfileController.swift
//  NewCOCOLOTalk1
//
//  Created by 志村　啓太 on 2020/11/08.
//

import UIKit
import Firebase
import SDWebImage

private let reuseIdentifier = "EditProfileCell"

protocol EditProfileControllerDelegate: class{
    func handleLogout()
}

class EditProfileController: UIViewController {
    
    //MARK: Properties
    
    var user: User? {
        didSet { configure() }
    }
    
    weak var delegate: EditProfileControllerDelegate?
    
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
    
    private lazy var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .lightGray
        iv.contentMode = .scaleAspectFill
        iv.layer.borderColor = UIColor.white.cgColor
        iv.layer.borderWidth = 4
        iv.clipsToBounds = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfileImageChange))
        iv.addGestureRecognizer(tap)
        iv.isUserInteractionEnabled = true
        
        return iv
    }()
    
    private let fullnameTextField: UITextField = CustomTextField(placeholder: "名前")
    private let usernameTextField: UITextField = CustomTextField(placeholder: "ユーザーネーム")
    private let ageTextField: UITextField = CustomTextField(placeholder: "生年月日（1996/10/8）")
    private let genderTextField: UITextField = CustomTextField(placeholder: "性別(男性)")
    private let sickTextField: UITextField = CustomTextField(placeholder: "病名(社交不安障害)")
    private let bioTextField: UITextField = CustomTextField(placeholder: "プロフィール文")
    
    private let logoutButton: TemplateButton = {
        let button = TemplateButton(title: "ログアウト", type: .system)
        button.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        button.backgroundColor = .lightGray
        button.setTitleColor(.white, for: .normal)
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
    
    @objc func handleProfileImageChange() {
        print(123)
    }
    
    @objc func handleLogout() {
        let aleat = UIAlertController(title: nil, message: "ログアウトしてよろしいですか？", preferredStyle: .actionSheet)
        
        aleat.addAction((UIAlertAction(title: "ログアウト", style: .destructive, handler: { _ in
            self.dismiss(animated: true) {
                self.delegate?.handleLogout()
            }
        })))
        
        aleat.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
        
        present(aleat, animated: true, completion: nil)
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
        
        view.backgroundColor = .systemPink
        
        view.addSubview(profileImageView)
        profileImageView.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor, paddingTop: 10)
        profileImageView.setDimensions(width: 150, height: 150)
        profileImageView.layer.cornerRadius = 150 / 2
        
        let stack = UIStackView(arrangedSubviews: [fullnameTextField, usernameTextField,
                                                   ageTextField, genderTextField, sickTextField,
                                                   bioTextField, logoutButton])
        stack.axis = .vertical
        stack.spacing = 16
        
        view.addSubview(stack)
        stack.anchor(top: profileImageView.bottomAnchor, left: view.leftAnchor,
                     right: view.rightAnchor,
                     paddingTop: 50, paddingLeft: 30, paddingRight: 30)
    }
    
    func configureBarButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "キャンセル", style: .plain, target: self, action: #selector(handleDissmissal))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: saveButton)
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    func configure() {
        guard let user = user else { return }
        
        fullnameTextField.text = user.fullname
        usernameTextField.text = user.username
        genderTextField.text = user.gender
        ageTextField.text = user.age
        sickTextField.text = user.sick
        bioTextField.text = user.bio
        
        guard let url = URL(string: user.profileImageUrl) else { return }
        profileImageView.sd_setImage(with: url)
    }
}

