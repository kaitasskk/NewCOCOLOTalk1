//
//  ProfileHeader.swift
//  NewCOCOLOTalk1
//
//  Created by 志村　啓太 on 2020/11/08.
//

import UIKit
import SDWebImage

class ProfileHeader: UIView {
    
    //MARK: Properties
    
    var user: User? {
        didSet { configure() }
    }
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .lightGray
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    private let fullnameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 25)
        return label
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 25)
        label.textColor = .lightGray
        return label
    }()
    
    private let genderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .darkGray
        return label
    }()
    
    private let ageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .darkGray
        return label
    }()
    
    private let sickLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .darkGray
        return label
    }()
    
    private let bioLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .darkGray
        label.numberOfLines = 5
        return label
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
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: leftAnchor, paddingTop: 10, paddingLeft: 10)
        profileImageView.setDimensions(width: 55, height: 55)
        profileImageView.layer.cornerRadius = 55 / 2
        
        let nameStack = UIStackView(arrangedSubviews: [fullnameLabel, usernameLabel])
        nameStack.axis = .horizontal
        nameStack.spacing = 5
        addSubview(nameStack)
        nameStack.anchor(top: topAnchor, left: profileImageView.rightAnchor,
                         paddingTop: 5, paddingLeft: 10)
        
        let detailsStack = UIStackView(arrangedSubviews: [ageLabel, genderLabel, sickLabel])
        detailsStack.axis = .horizontal
        detailsStack.spacing = 5
        addSubview(detailsStack)
        detailsStack.anchor(top: nameStack.bottomAnchor, left: profileImageView.rightAnchor,
                            paddingTop: 5, paddingLeft: 10)
        
        addSubview(bioLabel)
        bioLabel.anchor(top: detailsStack.bottomAnchor,
                        left: profileImageView.rightAnchor, right: rightAnchor,
                        paddingTop: 5, paddingLeft: 10, paddingRight: 10)
        
        let dividerView = UIView()
        dividerView.backgroundColor = .lightGray
        addSubview(dividerView)
        dividerView.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, height: 0.75)
    }
    
    func configure() {
        guard let user = user else { return }
        fullnameLabel.text = user.fullname
        usernameLabel.text = "@" + user.username
        genderLabel.text = user.gender
        ageLabel.text = user.age
        sickLabel.text = user.sick
        bioLabel.text = user.bio
        
        guard let url = URL(string: user.profileImageUrl) else { return }
        profileImageView.sd_setImage(with: url)
    }
}

