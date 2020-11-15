//
//  DescriptionController.swift
//  NewCOCOLOTalk1
//
//  Created by 志村　啓太 on 2020/11/13.
//

import UIKit
import paper_onboarding

class DescriptionController: UIViewController {
    
    //MARK: Properties
    
    private var onboardingItem = [OnboardingItemInfo]()
    private var onboardingView = PaperOnboarding()
    
    private let startButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("OK", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemPink
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        button.setDimensions(width: 150, height: 75)
        button.addTarget(self, action: #selector(handleReturn), for: .touchUpInside)
        return button
    }()
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureOnboardingDataSource()
    }
    
    //MARK: Selectors
    
    @objc func handleReturn() {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Helper
    
    func animateStartButton(_ buttonShow: Bool) {
        let alpha: CGFloat = buttonShow ? 1 : 0
        UIView.animate(withDuration: 0.5) {
            self.startButton.alpha = alpha
        }
    }
    
    func configureUI() {
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isHidden = true
        
        view.addSubview(onboardingView)
        onboardingView.fillSuperview()
        onboardingView.delegate = self
        
        view.addSubview(startButton)
        startButton.alpha = 0
        startButton.centerX(inView: view, topAnchor: view.topAnchor, paddingTop: 650)
    }
    
    func configureOnboardingDataSource() {
        let item1 = OnboardingItemInfo(informationImage: UIImage(systemName: "message")!, title: "ようこそ CoCoLoTALKへ", description: "", pageIcon: UIImage(), color: .white, titleColor: .systemPink, descriptionColor: .black, titleFont: UIFont.boldSystemFont(ofSize: 55), descriptionFont: UIFont.systemFont(ofSize: 30))
        
        let item2 = OnboardingItemInfo(informationImage: UIImage(systemName: "message")!, title: "Title1", description: "sssssssssss", pageIcon: UIImage(), color: .white, titleColor: .systemPink, descriptionColor: .black, titleFont: UIFont.boldSystemFont(ofSize: 60), descriptionFont: UIFont.systemFont(ofSize: 30))
        
        let item3 = OnboardingItemInfo(informationImage: UIImage(systemName: "message")!, title: "Title1", description: "sssssssssss", pageIcon: UIImage(), color: .white, titleColor: .systemPink, descriptionColor: .black, titleFont: UIFont.boldSystemFont(ofSize: 60), descriptionFont: UIFont.systemFont(ofSize: 30))
        
        let item4 = OnboardingItemInfo(informationImage: UIImage(systemName: "message")!, title: "Title1", description: "sssssssssss", pageIcon: UIImage(), color: .white, titleColor: .systemPink, descriptionColor: .black, titleFont: UIFont.boldSystemFont(ofSize: 60), descriptionFont: UIFont.systemFont(ofSize: 30))
        
        onboardingItem.append(item1)
        onboardingItem.append(item2)
        onboardingItem.append(item3)
        onboardingItem.append(item4)
        
        onboardingView.dataSource = self
        onboardingView.reloadInputViews()
    }
}

extension DescriptionController: PaperOnboardingDataSource {
    func onboardingItemsCount() -> Int {
        return onboardingItem.count
    }
    
    func onboardingItem(at index: Int) -> OnboardingItemInfo {
        return onboardingItem[index]
    }
}

extension DescriptionController: PaperOnboardingDelegate {
    func onboardingWillTransitonToIndex(_ index: Int) {
        let buttonShow = index == onboardingItem.count - 1 ? true : false
        animateStartButton(buttonShow)
    }
}

extension DescriptionController {
    func onboardingConfigurationItem(_ item: OnboardingContentViewItem, index: Int) {
        item.imageView?.tintColor = .systemPink
    }
    
    func onboardingPageItemColor(at index: Int) -> UIColor {
        return .systemPink
    }
}
