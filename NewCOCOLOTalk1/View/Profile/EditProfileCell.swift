//
//  EditProfileCell.swift
//  NewCOCOLOTalk1
//
//  Created by 志村　啓太 on 2020/11/11.
//

import UIKit

protocol EditProfileCellDelegate: class {
    func updateUserInfo(_ cell: EditProfileCell)
}

class EditProfileCell: UITableViewCell {
    
    //MARK: Properties
    
    var viewModel: EditProfileViewModel? {
        didSet { configure() }
    }
    
    weak var delegate: EditProfileCellDelegate?
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    
    lazy var infoTextField: UITextField = {
        let tv = UITextField()
        tv.borderStyle = .none
        tv.font = UIFont.systemFont(ofSize: 15)
        tv.textAlignment = .left
        tv.textColor = .systemPink
        tv.addTarget(self, action: #selector(handleUpdataUserInfo), for: .editingDidEnd)
        return tv
    }()
    
    let bioTextView: InputTextView = {
        let tv = InputTextView()
        tv.font = UIFont.systemFont(ofSize: 15)
        tv.textColor = .systemPink
        tv.placeholderLabel.text = "プロフィール文"
        tv.placeholderLabel.textColor = .systemPink
        return tv
    }()
    
    //MARK: Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        
        addSubview(titleLabel)
        titleLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        titleLabel.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, paddingLeft: 15)
        
        addSubview(infoTextField)
        infoTextField.anchor(top: topAnchor, left: titleLabel.rightAnchor,
                             bottom: bottomAnchor, right: rightAnchor,
                             paddingTop: 5, paddingLeft: 15, paddingRight: 10)
        
        addSubview(bioTextView)
        bioTextView.anchor(top: topAnchor, left: titleLabel.rightAnchor,
                             bottom: bottomAnchor, right: rightAnchor,
                             paddingTop: 5, paddingLeft: 15, paddingRight: 10)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdataUserInfo),
                                               name: UITextView.textDidEndEditingNotification, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Selectors
    
    @objc func handleUpdataUserInfo() {
        delegate?.updateUserInfo(self)
    }
    
    //MARK: Helpers
    
    func configure() {
        guard let viewModel = viewModel else { return }
        infoTextField.isHidden = viewModel.shouldHideTextField
        bioTextView.isHidden = viewModel.shouldHideTextView
        
        bioTextView.placeholderLabel.isHidden = viewModel.shouldHidePlaceholderLabel
        
        titleLabel.text = viewModel.titleText
        
        infoTextField.text = viewModel.optionValue
        bioTextView.text = viewModel.optionValue
    }
}
