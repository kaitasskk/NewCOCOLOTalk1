//
//  EditProfileFooter.swift
//  NewCOCOLOTalk1
//
//  Created by 志村　啓太 on 2020/11/11.
//

import UIKit

protocol EditProfileFooterDelegate: class {
    func handleLogout()
}

class EditProfileFooter: UIView {
    
    //MARK: Properties
    
    weak var delegate: EditProfileFooterDelegate?
    
    private let logoutButton: TemplateButton = {
        let button = TemplateButton(title: "ログアウト", type: .system)
        button.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        button.backgroundColor = .lightGray
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    //MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(logoutButton)
        logoutButton.centerY(inView: self)
        logoutButton.anchor(left: leftAnchor, right: rightAnchor,
                            paddingLeft: 30, paddingRight: 30)
        logoutButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Selector
    
    @objc func handleLogout() {
        delegate?.handleLogout()
    }
}
