//
//  Notification.swift
//  NewCOCOLOTalk1
//
//  Created by 志村　啓太 on 2020/11/05.
//

import Firebase

struct Notification {
    let toId: String
    let fromId: String
    var timeStamp: Timestamp!
    var user: User?
    
    let isFromCurrentUser: Bool
    
    init(dictionary: [String: Any]) {
        self.toId = dictionary["toId"] as? String ?? ""
        self.fromId = dictionary["fromId"] as? String ?? ""
        self.timeStamp = dictionary["timeStamp"] as? Timestamp ?? Timestamp(date: Date())

        self.isFromCurrentUser = fromId == Auth.auth().currentUser?.uid
    }
}

