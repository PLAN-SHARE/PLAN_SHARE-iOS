//
//  LoginController.swift
//  PlanShare_iOS
//
//  Created by doyun on 2022/02/27.
//

import UIKit
import KakaoSDKAuth
import KakaoSDKUser
import KakaoSDKCommon
import SwiftKeychainWrapper

class LoginController: UIViewController {
    
    private lazy var loginButton = UIButton().then {
        $0.setImage(UIImage(named: "kakao_login_large_narrow"), for: .normal)
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        print("DEBUG : login view loaded")
        view.addSubview(loginButton)
        loginButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(240)
            make.height.equalTo(50)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
    }
    
    @objc func didTapLogin(){

        if UserApi.isKakaoTalkLoginAvailable() {
            loginWithApp()
        } else {
            loginWithWeb()
        }
        
    }
    
}

extension LoginController {
    func loginWithApp(){
        UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
            if let error = error {
                print(error)
            }
            else {
                print("loginWithKakaoTalk() success.")
                
                //do something
                let accessToken = oauthToken?.accessToken
                
                AuthService.shared.login(request: accessToken!) { [weak self] result in
                    switch result {
                    case .success(let token) :
                        let saveSuccessful: Bool = KeychainWrapper.standard.set(token, forKey: "AccessToken")
                        if saveSuccessful {
                            let vc = UINavigationController(rootViewController: MainController())
                            vc.modalPresentationStyle = .fullScreen
                            self?.present(vc,animated: false)
                        }
                    case .failure(let error) :
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    func loginWithWeb() {
        UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
            if let error = error {
                print(error)
            }
            else {
                print("loginWithKakaoAccount() success.")
                
                let accessToken = oauthToken?.accessToken
                
                AuthService.shared.login(request: accessToken!) { [weak self] result in
                    switch result {
                    case .success(let token) :
                        let saveSuccessful: Bool = KeychainWrapper.standard.set(token, forKey: "AccessToken")
                        if saveSuccessful {
                            let vc = UINavigationController(rootViewController: MainController())
                            vc.modalPresentationStyle = .fullScreen
                            self?.present(vc,animated: false)
                        }
                    case .failure(let error) :
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
}
