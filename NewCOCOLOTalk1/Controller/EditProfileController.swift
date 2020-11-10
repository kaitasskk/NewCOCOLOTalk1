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

protocol EditProfileControllerUpdateDelegate: class {
    func controller(_ controller: EditProfileController, wantsToUpdate user: User)
}

class EditProfileController: UIViewController {
    
    //MARK: Properties
    
    private var user: User {
        didSet { configure() }
    }
    
    private var viewModel = RegistrationViewModel()
    private var selectedImage: UIImage? {
        didSet { profileImageView.image = selectedImage }
    }
    
    weak var delegate: EditProfileControllerDelegate?
    weak var updateDelegate: EditProfileControllerUpdateDelegate?
    
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
    private let sickTextField: UITextField = CustomTextField(placeholder: "病名(社交不安障害)")
    private let bioTextView: UITextView = LargeCustomTextView()
    
    private let logoutButton: TemplateButton = {
        let button = TemplateButton(title: "ログアウト", type: .system)
        button.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        button.backgroundColor = .lightGray
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    //MARK: Lifecycle
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureBarButton()
        fatchUser()
        configureNotificationObserver()
    }
    
    //MARK: Selectors
    
    @objc func handleDissmissal() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleSave() {
        UserService.saveUserData(user: user) { error in
            self.dismiss(animated: true, completion: nil)
            self.updateDelegate?.controller(self, wantsToUpdate: self.user)
        }
    }
    
    @objc func handleProfileImageChange() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    //MARK: Selectors
    
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
    
    @objc func keybordWillShow() {
        if view.frame.origin.y == 0 {
            self.view.frame.origin.y -= 150
        }
    }
    
    @objc func keybordWillHide() {
        if view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
        
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
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
                                                   sickTextField, bioTextView, logoutButton])
        stack.axis = .vertical
        stack.spacing = 10
        
        view.addSubview(stack)
        stack.anchor(top: profileImageView.bottomAnchor, left: view.leftAnchor,
                     right: view.rightAnchor,
                     paddingTop: 10, paddingLeft: 30, paddingRight: 30)
    }
    
    func configureBarButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "キャンセル", style: .plain, target: self, action: #selector(handleDissmissal))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: saveButton)
    }
    
    func configureNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keybordWillShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keybordWillHide), name: UIResponder.keyboardDidHideNotification, object: nil)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    func configure() {
        fullnameTextField.text = user.fullname
        usernameTextField.text = user.username
        sickTextField.text = user.sick
        bioTextView.text = user.bio
        
        guard let url = URL(string: user.profileImageUrl) else { return }
        profileImageView.sd_setImage(with: url)
    }
}

//MARK: UINavigationControllerDelegate

extension EditProfileController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        self.selectedImage = image
        
        dismiss(animated: true, completion: nil)
    }
}
