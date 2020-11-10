//
//  EditProfileHeader.swift
//  NewCOCOLOTalk1
//
//  Created by 志村　啓太 on 2020/11/11.
//

import UIKit
import SDWebImage

protocol EditProfileHeaderDelegate: class {
    func didTapChangePhoto()
}

class EditProfileHeader: UIView {
    
    //MARK: Properties
    
    private let user: User
    weak var delegate: EditProfileHeaderDelegate?
    
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        iv.layer.borderColor = UIColor.white.cgColor
        iv.layer.borderWidth = 3
        
        return iv
    }()
    
    private let changePhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("プロフィール画像を編集", for: .normal)
        button.addTarget(self, action: #selector(handleChangePhoto), for: .touchUpInside)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    //MARK: Lifecycle
    
    init(user: User) {
        self.user = user
        super.init(frame: .zero)
        backgroundColor = .systemPink
        
        addSubview(profileImageView)
        profileImageView.center(inView: self, yConstant: -15)
        profileImageView.setDimensions(width: 150, height: 150)
        profileImageView.layer.cornerRadius = 150 / 2
        
        addSubview(changePhotoButton)
        changePhotoButton.centerX(inView: self, topAnchor: profileImageView.bottomAnchor, paddingTop: 10)
        
        guard let url = URL(string: user.profileImageUrl) else { return }
        profileImageView.sd_setImage(with: url)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Selector
    
    @objc func handleChangePhoto() {
        delegate?.didTapChangePhoto()
    }
    
}
