//
//  DetailViewController.swift
//  PlanShare_iOS
//
//  Created by Doyun Park on 2022/03/24.
//

import UIKit
import RxRelay
import RxCocoa
import RxSwift
import RxDataSources
import Differentiator

class GaolViewController: UIViewController {
    
    //MARK: - Properties
        
    private var titleLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .noto(size: 20, family: .Bold)
        $0.textAlignment = .center
    }
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        view.backgroundColor = .red
    }
    
    //MARK: - Configure
    func configureNavigation() {
        navigationItem.title = "목표"
    }
}
