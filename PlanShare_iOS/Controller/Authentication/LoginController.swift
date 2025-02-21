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
    
    private var titleLabel = UILabel().then{
        $0.text = "PlanShare"
        $0.font = .noto(size: 34, family: .Bold)
        $0.textColor = .black
    }
    private lazy var loginButton = UIButton().then {
        $0.setImage(UIImage(named: "kakao_login_large_narrow"), for: .normal)
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
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
                let accessToken = oauthToken?.accessToken
                AuthService.shared.login(request: accessToken!) { [weak self] result in
                    switch result {
                    case .success(let data) :
                        self?.checkUser(jsonData: data)
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
                print("loginWithKakaoTalk() success.")
                let accessToken = oauthToken?.accessToken
                AuthService.shared.login(request: accessToken!) { [weak self] result in
                    switch result {
                    case .success(let data) :
                        self?.checkUser(jsonData: data)
                    case .failure(let error) :
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    private func checkUser(jsonData:[String:Any]) {

        if let jwt = jsonData["jwt"] as? String {
            print("DEBUG : 이미 등록된 회원입니다.")
            guard let email = jsonData["email"] as? String, let id = jsonData["userId"] as? Int else {
                return
            }
            
            KeychainWrapper.standard.set(jwt, forKey: "AccessToken")
            KeychainWrapper.standard.set(String(id), forKey: "id")
            KeychainWrapper.standard.set(email, forKey: "email")
            
            let vc = MainTapViewController()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc,animated:true)
        } else {
            guard let email = jsonData["email"] as? String, let id = jsonData["id"] as? Int else {
                return
            }
            
            KeychainWrapper.standard.set(String(id), forKey: "id")
            KeychainWrapper.standard.set(email, forKey: "email")
            print("DEBUG : 회원가입이 필요한 회원입니다.")
            
            // 닉네임 필요
            let vc = RegisterController()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc,animated:true)
        }
    }
}
