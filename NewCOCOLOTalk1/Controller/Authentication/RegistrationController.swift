//
//  RegistrationController.swift
//  NewCOCOLOTalk1
//
//  Created by 志村　啓太 on 2020/11/01.
//

import UIKit
import Firebase

class RegistrationController: UIViewController {
    
    //MARK: Properties
    
    private var viewModel = RegistrationViewModel()
    private var profileImage: UIImage?
    
    private let selectPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "plus_photo"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleSelectPhoto), for: .touchUpInside)
        return button
    }()
    
    private let emailTextField: UITextField = CustomTextField(placeholder: "Eメール")
    
    private let passwordTextField: UITextField = {
        let tf = CustomTextField(placeholder: "パスワード", isSecureField: true)
        tf.isSecureTextEntry = true
        return tf
    }()
    
    private let fullnameTextField: UITextField = CustomTextField(placeholder: "名前")
    
    private let usernameTextField: UITextField = CustomTextField(placeholder: "ユーザーネーム")
    
    private let signupButton: TemplateButton = {
        let button = TemplateButton(title: "登録", type: .system)
        button.addTarget(self, action: #selector(handleRegistration), for: .touchUpInside)
        button.backgroundColor = .lightGray
        button.isEnabled = false
        return button
    }()
    
    private let testLoginButton: TemplateButton = {
        let button = TemplateButton(title: "テストログイン", type: .system)
        button.addTarget(self, action: #selector(handleTestLogin), for: .touchUpInside)
        return button
    }()
    
    private let showLoginButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSAttributedString(string: "アカウントをお持ちの方はこちら", attributes: [.foregroundColor: UIColor.white, .font: UIFont.boldSystemFont(ofSize: 20)])
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleshowLoginButton), for: .touchUpInside)
        return button
    }()
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNotificationObserver()
    }
    
    //MARK: Selector
    
    @objc func handleSelectPhoto() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    @objc func handleRegistration() {
        guard let profileImage = profileImage else {
            self.showError("No profile image selected.")
            return }
        
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let fullname = fullnameTextField.text else { return }
        guard let username = usernameTextField.text else { return }
        
        let credentials = RegistrationCredentials(email: email, password: password, fullname: fullname, username: username, profileImage: profileImage)
        
        showLoader(true, withText: "アカウント作成中")

        AuthService.shared.SignIn(credentials: credentials) { error in
            if let error = error {
                self.showLoader(false)
                self.showError(error.localizedDescription)
                return
            }
            guard let window = UIApplication.shared.windows.first(where: {$0.isKeyWindow}) else { return }
            guard let conversation = window.rootViewController as? ConversationController else { return }
            
            conversation.authenticationUser()
            self.showLoader(false)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func handleTestLogin() {
        guard let window = UIApplication.shared.windows.first(where: {$0.isKeyWindow}) else { return }
        guard let conversation = window.rootViewController as? ConversationController else { return }
        conversation.authenticationUser()
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleshowLoginButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func textDidChange(sender: UITextField) {
        if sender == emailTextField {
            viewModel.email = sender.text
        } else if sender == passwordTextField {
            viewModel.password = sender.text
        } else if sender == fullnameTextField {
            viewModel.fullname = sender.text
        } else if sender == usernameTextField {
            viewModel.username = sender.text
        }
        
        chackFormStatus()
    }
    
    @objc func keybordWillShow() {
        if view.frame.origin.y == 0 {
            self.view.frame.origin.y -= 130
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
    
    //MARK: Helpers
    
    func chackFormStatus() {
        if viewModel.formIsValid {
            signupButton.isEnabled = true
            signupButton.backgroundColor = .white
        } else {
            signupButton.isEnabled = false
            signupButton.backgroundColor = .lightGray
        }
    }
    
    func configureUI() {
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
        
        view.backgroundColor = .systemPink
        
        view.addSubview(selectPhotoButton)
        selectPhotoButton.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor,
                                  paddingTop: 10)
        selectPhotoButton.setDimensions(width:  150, height: 150)
        selectPhotoButton.layer.cornerRadius =  150 / 2
        
        let stack = UIStackView(arrangedSubviews: [emailTextField, passwordTextField,
                                                   fullnameTextField, usernameTextField,
                                                   signupButton, testLoginButton])
        stack.axis = .vertical
        stack.spacing = 16
        
        view.addSubview(stack)
        stack.anchor(top: selectPhotoButton.bottomAnchor, left: view.leftAnchor,
                     right: view.rightAnchor,
                     paddingTop: 50, paddingLeft: 30, paddingRight: 30)
        
        view.addSubview(showLoginButton)
        showLoginButton.anchor(left: view.leftAnchor,
                                      bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                      right: view.rightAnchor, paddingLeft: 30, paddingRight: 30)
    }
    
    func configureNotificationObserver() {
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        fullnameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        usernameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keybordWillShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keybordWillHide), name: UIResponder.keyboardDidHideNotification, object: nil)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
    }
}

//MARK: UINavigationControllerDelegate

extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        profileImage = image
        
        selectPhotoButton.layer.cornerRadius = 150 / 2
        selectPhotoButton.layer.masksToBounds = true
        selectPhotoButton.imageView?.clipsToBounds = true
        selectPhotoButton.imageView?.contentMode = .scaleAspectFill
        selectPhotoButton.layer.borderColor = UIColor.white.cgColor
        selectPhotoButton.layer.borderWidth = 3
        
        selectPhotoButton.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        
        dismiss(animated: true, completion: nil)
    }
}
