//
//  ConversationCell.swift
//  NewCOCOLOTalk1
//
//  Created by 志村　啓太 on 2020/11/02.
//

import UIKit
import SDWebImage

class ConversationCell: UITableViewCell {
    
    //MARK: Properties
    
    var conversation: Conversation? {
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
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .lightGray
        return label
    }()
    
    private let messageTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    private let timestampLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .darkGray
        label.numberOfLines = 2
        return label
    }()
    
    //MARK: Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        profileImageView.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 10)
        profileImageView.setDimensions(width: 50, height: 50)
        profileImageView.layer.cornerRadius = 50 / 2
        
        let nameStack = UIStackView(arrangedSubviews: [fullnameLabel, usernameLabel])
        nameStack.axis = .horizontal
        nameStack.spacing = 5
        addSubview(nameStack)
        nameStack.anchor(top: topAnchor, left: profileImageView.rightAnchor,
                     paddingTop: 10, paddingLeft: 10)
        
        
        addSubview(messageTextLabel)
        messageTextLabel.anchor(top: nameStack.bottomAnchor ,left: profileImageView.rightAnchor,
                                right: rightAnchor,
                                paddingTop: 5, paddingLeft: 10, paddingRight: 15)
        
        addSubview(timestampLabel)
        timestampLabel.anchor(top: topAnchor, right: rightAnchor,
                              paddingTop: 20, paddingRight: 10)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Helpers
    
    func configure() {
        guard let conversation = conversation else { return }
        let viewModel = ConversationViewModel(conversation: conversation)
        
        fullnameLabel.text = conversation.user.fullname
        usernameLabel.text = "@" + conversation.user.username
        messageTextLabel.text = conversation.message.text
        
        timestampLabel.text = viewModel.timestamp
        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
    }
}
