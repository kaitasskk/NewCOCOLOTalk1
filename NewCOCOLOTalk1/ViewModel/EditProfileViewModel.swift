//
//  EditProfileViewModel.swift
//  NewCOCOLOTalk1
//
//  Created by 志村　啓太 on 2020/11/11.
//

import Foundation

enum EditProfileOptions: Int, CaseIterable {
    case fullname
    case username
    case sick
    case bio
    
    var description: String {
        switch self {
        case .fullname: return "名前"
        case .username: return "ユーザーネーム"
        case .sick: return "病名"
        case .bio: return "プロフィール文"
        }
    }
}

struct EditProfileViewModel {
    
    private let user: User
    let option: EditProfileOptions
    
    var titleText: String {
        return option.description
    }
    
    var shouldHideTextField: Bool {
        return option == .bio
    }
    
    var optionValue: String {
        switch option {
        case .fullname: return user.fullname
        case .username: return user.username
        case .sick: return user.sick
        case .bio: return user.bio
        }
    }
    
    var shouldHideTextView: Bool {
        return option != .bio
    }
    
    var shouldHidePlaceholderLabel: Bool {
        return user.bio != nil
    }
    
    init(user: User, option: EditProfileOptions) {
        self.user = user
        self.option = option
    }
}
