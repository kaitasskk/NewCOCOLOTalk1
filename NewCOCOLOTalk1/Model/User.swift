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
    let profileImageUrl: String
    let fullname: String
    let username: String
    let email: String
    let bio: String
    let gender: String
    let age: String
    let sick: String
    
    init(dictionary: [String: Any]) {
        self.uid = dictionary["uid"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.bio = dictionary["bio"] as? String ?? ""
        self.gender = dictionary["gender"] as? String ?? ""
        self.age = dictionary["age"] as? String ?? ""
        self.sick = dictionary["sick"] as? String ?? ""
    }
}
