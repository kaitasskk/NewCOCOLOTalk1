//
//  LoginController.swift
//  NewCOCOLOTalk1
//
//  Created by 志村　啓太 on 2020/11/01.
//

import UIKit
import Firebase

class LoginController: UIViewController {
    
    //MARK: Properties
    
    private var viewModel = LoginViewModel()
    
    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "message")
        iv.tintColor = .white
        return iv
    }()
    
    private let emailTextField: UITextField = CustomTextField(placeholder: "Eメール")
    
    private let passwordTextField: UITextField = {
        let tf = CustomTextField(placeholder: "パスワード", isSecureField: true)
        tf.isSecureTextEntry = true
        return tf
    }()
    
    private let loginButton: TemplateButton = {
        let button = TemplateButton(title: "ログイン", type: .system)
        button.backgroundColor = .lightGray
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    private let testLoginButton: TemplateButton = {
        let button = TemplateButton(title: "テストログイン", type: .system)
        button.addTarget(self, action: #selector(handleTestLogin), for: .touchUpInside)
        return button
    }()
    
    private let showRegistrationButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSAttributedString(string: "新規登録はこちら", attributes: [.foregroundColor: UIColor.white, .font: UIFont.boldSystemFont(ofSize: 20)])
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleShowRegistration), for: .touchUpInside)
        return button
    }()
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNotificationObserver()
    }
    
    //MARK: Selector
    
    @objc func handleLogin() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        showLoader(true)
        
        AuthService.shared.logIn(withEmail: email, password: password) { (result, error) in
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
    
    @objc func handleShowRegistration() {
        let controller = RegistrationController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func textDidChange(sender: UITextField) {
        if sender == emailTextField {
            viewModel.email = sender.text
        } else {
            viewModel.password = sender.text
        }
        
        chackFormStatus()
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    //MARK: Helpers
    
    func chackFormStatus() {
        if viewModel.formIsValid {
            loginButton.isEnabled = true
            loginButton.backgroundColor = .white
        } else {
            loginButton.isEnabled = false
            loginButton.backgroundColor = .lightGray
        }
    }
    
    func configureUI() {
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
        
        view.backgroundColor = .systemPink
        
        view.addSubview(iconImageView)
        iconImageView.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor,
                              paddingTop: 10)
        iconImageView.setDimensions(width: 200, height: 200)
        
        let stack = UIStackView(arrangedSubviews: [emailTextField, passwordTextField,
                                                   loginButton, testLoginButton])
        stack.axis = .vertical
        stack.spacing = 16
        
        view.addSubview(stack)
        stack.anchor(top: iconImageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,
                     paddingTop: 50, paddingLeft: 30, paddingRight: 30)
        
        view.addSubview(showRegistrationButton)
        showRegistrationButton.anchor(left: view.leftAnchor,
                                      bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                      right: view.rightAnchor, paddingLeft: 30, paddingRight: 30)
        
        
    }
    
    func configureNotificationObserver() {
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
    }
}
