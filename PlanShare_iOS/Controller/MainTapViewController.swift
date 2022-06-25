//
//  ViewController.swift
//  withpet_iOS
//
//  Created by doyun on 2022/02/01.
//

import UIKit
import SnapKit
import Then

class MainTapViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .init(named: "edebf5")
        configureTapbar()
        // Do any additional setup after loading the view.
    }

    //MARK: - Configure
    func configureTapbar() {
        
        let calendarVC = CalendarViewController(viewModel: MainViewModel(categoryService: CategoryService(), userService: UserService(),scheduleService: ScheduleService()))
        let nav1 = templateNavigationController(image: UIImage(systemName: "calendar"), rootViewController: calendarVC)
        
        let goalVC = GoalViewController()
        let nav2 = templateNavigationController(image: UIImage(systemName: "target"), rootViewController: goalVC)
        setViewControllers([nav1,nav2], animated: false)
        tabBar.tintColor = .darkGray
    }
    
    func templateNavigationController(image: UIImage?,rootViewController: UIViewController) -> UINavigationController{
        let navigation = UINavigationController(rootViewController: rootViewController)
        navigation.tabBarItem.image = image
        return navigation
    }
}

