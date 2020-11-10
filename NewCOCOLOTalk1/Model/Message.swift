//
//  Message.swift
//  NewCOCOLOTalk1
//
//  Created by 志村　啓太 on 2020/11/02.
//

import Firebase

struct Message {
    let text: String
    let toId: String
    let fromId: String
    var timestamp: Timestamp!
    var user: User?
    
    let isFromCurrentUser: Bool
    
    var chatPartnerId: String {
        return isFromCurrentUser ? toId :fromId
    }
    
    init(dictionary: [String: Any]) {
        self.text = dictionary["text"] as? String ?? ""
        self.toId = dictionary["toId"] as? String ?? ""
        self.fromId = dictionary["fromId"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())

        self.isFromCurrentUser = fromId == Auth.auth().currentUser?.uid
    }
}

struct Conversation {
    var user: User
    let message: Message
}
