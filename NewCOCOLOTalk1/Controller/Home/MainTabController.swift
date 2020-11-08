//
//  MainTabController.swift
//  NewCOCOLOTalk1
//
//  Created by 志村　啓太 on 2020/11/01.
//

import UIKit
import Firebase

class MainTabController: UITabBarController {
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        logUserout()
        authenticationUser()
    }
    
    //MARK: API
    
    func authenticationUser() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let controller = LoginController()
                let nav = UINavigationController(rootViewController: controller)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }
        } else {
            configureViewControllers()
        }
    }
    
    func logUserout() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("DEBUG: Error")
        }
    }
    
    //MARK: Helpers
    
    func configureViewControllers() {
        
        let conversation = ConversationController()
        let nav1 = templateNavigationController(image: UIImage(systemName: "message.fill"), rootViewController: conversation)
        
        let timeline = TimelineController()
        let nav2 = templateNavigationController(image: UIImage(systemName: "clock.fill"), rootViewController: timeline)
        
        let notification = NotificationController()
        let nav3 = templateNavigationController(image: UIImage(systemName: "lightbulb.fill"), rootViewController: notification)
        
        viewControllers = [nav1, nav2, nav3]
        
    }
    
    func templateNavigationController(image: UIImage?, rootViewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = image
        UITabBar.appearance().tintColor = .systemPink
        return nav
    }
}
