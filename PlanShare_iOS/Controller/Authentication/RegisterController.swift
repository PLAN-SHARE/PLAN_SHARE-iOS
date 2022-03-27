//
//  RegisterController.swift
//  PlanShare_iOS
//
//  Created by Doyun Park on 2022/03/07.
//

import UIKit
import SwiftKeychainWrapper

class RegisterController: UIViewController {
    
    //MARK: - properties
    private var nickNameTextField = UITextField().then {
        $0.textColor = .black
        $0.textAlignment = .left
        $0.font = .systemFont(ofSize: 20)
        $0.backgroundColor = .white
        let view = UIView().then {
            $0.backgroundColor = .lightGray
        }
        $0.placeholder = "사용하실 닉네임을 입력해주세요"
        $0.setLeftPaddingPoints(10)
        $0.addSubview(view)
        view.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
        }
    }
    
    private lazy var registerButton = UIButton().then {
        $0.backgroundColor = .white
        $0.setTitle("등록하기", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.layer.cornerRadius = 8
        $0.layer.borderColor = UIColor.black.cgColor
        $0.layer.borderWidth = 2
        $0.addTarget(self, action: #selector(didTapRegister), for: .touchUpInside)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        nickNameTextField.delegate = self
    }
    
    func configureUI() {
        
        view.backgroundColor = .white
        
        view.addSubview(nickNameTextField)
        nickNameTextField.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
            make.height.equalTo(35)
        }
        
        view.addSubview(registerButton)
        registerButton.snp.makeConstraints { make in
            make.top.equalTo(nickNameTextField.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.width.equalTo(250)
            make.height.equalTo(50)
        }
        nickNameTextField.becomeFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func didTapRegister() {
        print("DEBUG : did tap reigster button")
        
        guard let nickname = nickNameTextField.text, !nickname.isEmpty else {
            return
        }

        AuthService.shared.register(nickName: nickname) { result in
            switch result {
            case .success(let token) :
                KeychainWrapper.standard.set(token, forKey: "AccessToken")
                self.nextVC()
            case .failure(let error) :
                print(error.localizedDescription)
            }
        }
    }
    
    func nextVC(){
        let vc = UINavigationController(rootViewController: MainController(viewModel: MainViewModel(categoryService: CategoryService()                                                            ,userService: UserService())))
        vc.modalPresentationStyle = .fullScreen
        present(vc,animated: true)
    }
}

extension RegisterController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let nickname = textField.text, !nickname.isEmpty else {
            return false
        }
        
        AuthService.shared.register(nickName: nickname) { result in
            switch result {
            case .success(let token) :
                KeychainWrapper.standard.set(token, forKey: "AccessToken")
                self.nextVC()
            case .failure(let error) :
                print(error.localizedDescription)
            }
        }
        return true
    }
}
