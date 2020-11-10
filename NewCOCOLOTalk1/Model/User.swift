//
//  User.swift
//  NewCOCOLOTalk1
//
//  Created by 志村　啓太 on 2020/11/01.
//

import Foundation
import Firebase

struct User {
    let uid: String
    var profileImageUrl: String
    var fullname: String
    var username: String
    let email: String
    var bio: String
    var sick: String
    
    init(dictionary: [String: Any]) {
        self.uid = dictionary["uid"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.bio = dictionary["bio"] as? String ?? ""
        self.sick = dictionary["sick"] as? String ?? ""
    }
}
