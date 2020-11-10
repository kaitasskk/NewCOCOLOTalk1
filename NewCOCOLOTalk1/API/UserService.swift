//
//  UserService.swift
//  NewCOCOLOTalk1
//
//  Created by 志村　啓太 on 2020/11/01.
//

import Firebase

struct UserService {
    
    static func fatchUsers(completion: @escaping([User]) -> Void) {
        COLLECTION_USERS.getDocuments { snapshot, error in
            guard var users = snapshot?.documents.map({ User(dictionary: $0.data())}) else { return }
            
            if let i = users.firstIndex(where: { $0.uid == Auth.auth().currentUser?.uid}) {
                users.remove(at: i)
            }
                completion(users)
        }
    }
    
    static func fatchUser(withUid uid: String, completion: @escaping(User) -> Void) {
        COLLECTION_USERS.document(uid).getDocument { (snapshot, error) in
            guard let dictionary = snapshot?.data() else { return }
            let user = User(dictionary: dictionary)
            completion(user)
        }
    }
    
    static func updateProfileaImage(image: UIImage, completion: @escaping(String) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.3) else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let filename = NSUUID().uuidString
        let ref = Storage.storage().reference(withPath: "/profile_image/\(filename)")
        
        ref.putData(imageData, metadata: nil) { (meta, error) in
            ref.downloadURL { (url, error) in
                guard let profileaImageUrl = url?.absoluteString else { return }
                let data = ["profileImageUrl": profileaImageUrl]
                
                COLLECTION_USERS.document(uid).updateData(data) { error in
                    completion(profileaImageUrl)
                }
            }
        }
    }
    
    static func saveUserData(user: User, completion: ((Error?) -> Void)?) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let data = ["fullname": user.fullname,
                    "username": user.username,
                    "sick": user.sick,
                    "bio": user.bio]
        
        COLLECTION_USERS.document(uid).updateData(data, completion: completion)
    }
}
