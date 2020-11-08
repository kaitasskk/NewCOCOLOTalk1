//
//  EditProfileHeader.swift
//  NewCOCOLOTalk1
//
//  Created by 志村　啓太 on 2020/11/08.
//

import UIKit
import SDWebImage

protocol EditProfileHeaderDelegate: class {
    func didTapChangeProfilePhoto()
}

class EditProfileHeader: UIView {
    
    //MARK: Properties
    
    var user: User? {
        didSet { configure() }
    }
    
    weak var delegate: EditProfileHeaderDelegate?
    
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
    
    //MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Helpers
    
    func configureUI() {
        backgroundColor = .systemPink
        
        addSubview(profileImageView)
        profileImageView.centerY(inView: self)
        profileImageView.centerX(inView: self)
        
        profileImageView.setDimensions(width: 200, height: 200)
        profileImageView.layer.cornerRadius = 200 / 2
    }
    
    func configure() {
        guard let user = user else { return }
        
        guard let url = URL(string: user.profileImageUrl) else { return }
        profileImageView.sd_setImage(with: url)
    }
    
    //MARK: Selector
    
    @objc func handleProfileImageChange() {
        delegate?.didTapChangeProfilePhoto()
    }
}
