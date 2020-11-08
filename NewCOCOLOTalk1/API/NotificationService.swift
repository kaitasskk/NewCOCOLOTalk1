//
//  NotificationService.swift
//  NewCOCOLOTalk1
//
//  Created by 志村　啓太 on 2020/11/05.
//

import Firebase

struct NotificationService {
    
    static func fatchNotifications(completion: @escaping([Notification]) -> Void ) {
        var notifications = [Notification]()
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let query = COLLECTION_MESSAGES.document(uid).collection("recent-notifications").order(by: "timestamp")
        
        query.addSnapshotListener { (snapshot, error) in
            snapshot?.documentChanges.forEach({ change in
                let dictionary = change.document.data()
                let notification = Notification(dictionary: dictionary)
                
                UserService.fatchUser(withUid: notification.toId) { user in
                    notifications.append(notification)
                    completion(notifications)
                }
            })
        }
    }
    
    
    static func uploadNotifications(for user: User, completion: ((Error?) -> Void)?) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        let data = ["fromId": currentUid,
                    "toId": user.uid,
                    "timestamp": Timestamp(date: Date())] as [String: Any]
        
        COLLECTION_NOTIFICATIONS.document(currentUid).collection(user.uid).addDocument(data: data) { _ in
            COLLECTION_NOTIFICATIONS.document(user.uid).collection(currentUid).addDocument(data: data, completion: completion)
            
            COLLECTION_NOTIFICATIONS.document(currentUid).collection("recent-notifications").document(user.uid).setData(data)
            
            COLLECTION_NOTIFICATIONS.document(user.uid).collection("recent-notifications").document(currentUid).setData(data)
        }
    }
}
