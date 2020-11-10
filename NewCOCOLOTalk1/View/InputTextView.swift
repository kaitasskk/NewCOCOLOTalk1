//
//  InputTextView.swift
//  NewCOCOLOTalk1
//
//  Created by 志村　啓太 on 2020/11/11.
//

import UIKit

class InputTextView: UITextView {
    
    // MARK* - プロトコル
    
    var placeholderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .darkGray
        label.text = "What's happening?"
        return label
    }()
    
    // MARK* - ライフサイクル
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        backgroundColor = .white
        font = UIFont.systemFont(ofSize: 15)
        isScrollEnabled = false
        heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        addSubview(placeholderLabel)
        placeholderLabel.anchor(top: topAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 4)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextInputChange),
                                               name: UITextView.textDidChangeNotification, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selector
    
    @objc func handleTextInputChange() {
        placeholderLabel.isHidden = !text.isEmpty
    }
}
