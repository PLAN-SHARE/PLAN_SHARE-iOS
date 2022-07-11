//
//  SetScheduleController.swift
//  PlanShare_iOS
//
//  Created by doyun on 2022/02/23.
//

import UIKit
import RxCocoa
import RxSwift

final class CreateScheduleController: UIViewController {
    
    //MARK: - Properties
    private var viewModel: CreateViewModel!
    private var disposeBag = DisposeBag()
    
    private var pickerView = UIPickerView()
    private var datePicker = UIDatePicker()
   
    private lazy var containerView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 15
        $0.layer.borderWidth = 0.5
        $0.layer.shadowColor = UIColor.gray.cgColor
        $0.layer.shadowOpacity = 0.4
        $0.layer.shadowOffset = CGSize.zero
        $0.layer.shadowRadius = 2
        
        $0.layer.borderColor = UIColor.lightGray.cgColor
        /// 팝업이 등장할 때(viewWillAppear)에서 containerView.transform = .identity로 하여 애니메이션 효과 주는 용도
        $0.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        
        $0.addSubview(categoryLabel)
        categoryLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview().offset(35)
        }
 
        $0.addSubview(categoryTextField)
        categoryTextField.snp.makeConstraints { make in
            make.top.equalTo(categoryLabel.snp.bottom).offset(15)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(40)
        }
        
        $0.addSubview(scheduleTextField)
        scheduleTextField.snp.makeConstraints { make in
            make.top.equalTo(categoryTextField.snp.bottom).offset(15)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(40)
        }
        
        $0.addSubview(dateTextField)
        dateTextField.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.top.equalTo(scheduleTextField.snp.bottom).offset(15)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(40)
        }
        $0.addSubview(buttonStackView)
        buttonStackView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(60)
        }
    }
    
    private let categoryLabel = UILabel().then{
        $0.text = "나의 일정 추가하기"
        $0.textColor = .black
        $0.font = .boldSystemFont(ofSize: 18)
    }
    
    private lazy var categoryTextField = UITextField().then {
        $0.textColor = .black
        $0.backgroundColor = .white
        $0.inputView = pickerView
        $0.placeholder = "목표 설정하기"
        $0.font = .systemFont(ofSize: 16)
        
        let view = UIView().then {
            $0.backgroundColor = .init(hex:"f2f2f2")
        }
        
        $0.addSubview(view)
        view.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(1.5)
        }
        
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: view.frame.width, height: 44.0))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let cancel = UIBarButtonItem(title: "취소", style: .plain, target: nil, action: #selector(didTapCancel))
        let barButton = UIBarButtonItem(title: "확인", style: .done, target: target, action: #selector(didTapDone))
        
        toolBar.setItems([cancel, flexible, barButton], animated: false)
        toolBar.tintColor = .black
        $0.inputAccessoryView = toolBar
    }
    
    private lazy var scheduleTextField = UITextField().then {
        $0.font = .systemFont(ofSize: 16)
        $0.textColor = .black
        $0.clearButtonMode = .whileEditing
        $0.textAlignment = .left
        $0.placeholder = "일정을 입력해주세요"
        $0.allowsEditingTextAttributes = false
        
        let view = UIView().then {
            $0.backgroundColor = .init(hex:"f2f2f2")
        }
        
        $0.addSubview(view)
        view.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(1.5)
        }
    }
    
    private lazy var buttonStackView = UIStackView().then{
        $0.backgroundColor = .init(hex: "f2f2f2")
        $0.spacing = 14.0
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 15
        $0.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMinXMaxYCorner]
        
        $0.addSubview(doneButton)
        doneButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-30)
            make.width.equalTo(60)
            make.height.equalTo(28)
        }
        
        $0.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { make in
            make.trailing.equalTo(doneButton.snp.leading).offset(-10)
            make.centerY.equalToSuperview()
            make.width.equalTo(60)
            make.height.equalTo(28)
        }
    }
    
    private lazy var cancelButton = UIButton().then {
        $0.backgroundColor = .white
        $0.setTitle("취소", for: .normal)
        $0.titleLabel?.font = .boldSystemFont(ofSize: 12)
        $0.setTitleColor(.darkGray, for: .normal)
        $0.layer.cornerRadius = 6
        
        $0.layer.shadowColor = UIColor.gray.cgColor
        $0.layer.shadowOpacity = 0.1
        $0.layer.shadowOffset = CGSize.zero
        $0.layer.shadowRadius = 1
        
        $0.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
    }
    
    private lazy var doneButton = UIButton().then {
        $0.backgroundColor = .mainColor
        $0.setTitle("등록하기", for: .normal)
        $0.titleLabel?.font = .boldSystemFont(ofSize: 12)
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 6
        
        $0.layer.shadowColor = UIColor.gray.cgColor
        $0.layer.shadowOpacity = 0.1
        $0.layer.shadowOffset = CGSize.zero
        $0.layer.shadowRadius = 1
        $0.addTarget(self, action: #selector(handleDone), for: .touchUpInside)
    }

    private lazy var dateTextField = UITextField().then {
        $0.layer.cornerRadius = 8
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.lightGray.cgColor
        $0.textColor = .darkGray
        
        let leftImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        leftImageView.contentMode = .scaleToFill
        leftImageView.image = UIImage(named: "event")
        $0.leftView = leftImageView
        $0.tintColor = .lightGray
        $0.inputView = datePicker
        $0.font = .systemFont(ofSize: 20)
        $0.setLeftPaddingPoints(15)
        $0.text = Date.converToString(from: Date(), type: .full)

        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: view.frame.width, height: 44.0))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let cancel = UIBarButtonItem(title: "취소", style: .plain, target: nil, action: #selector(didTapCancel))
        let barButton = UIBarButtonItem(title: "확인", style: .done, target: target, action: #selector(didTapDone))
        
        toolBar.setItems([cancel, flexible, barButton], animated: false)
        toolBar.tintColor = .black
        $0.inputAccessoryView = toolBar
    }
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configurePicker()
        configureUI()
        bind()
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(view.endEditing))
        view.addGestureRecognizer(tapGesture)
    }
    
    init(viewModel:CreateViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - API
    
    func bind() {
        viewModel.goalSubject.bind(to: pickerView.rx.itemTitles) { $1.name }.disposed(by: disposeBag)
        
        pickerView.rx.modelSelected(CategoryModel.self)
            .subscribe(onNext: { [weak self] goal in
                self?.viewModel.selectedCateogry = goal[0]
                self?.categoryTextField.text = goal[0].name
            }).disposed(by: disposeBag)
    }
    
    //MARK: - Configure
    func configureUI(){
        view.backgroundColor = .black.withAlphaComponent(0.3)
        view.alpha = 0.2
        view.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(300)
            make.height.equalTo(420)
        }
        
    }
    
    func configurePicker(){
        datePicker.preferredDatePickerStyle = .inline
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ko-KR")
        datePicker.timeZone = .autoupdatingCurrent
        scheduleTextField.delegate = self
    }
    //MARK: - selector
    @objc func didTapCancel(){
        if categoryTextField.isFirstResponder {
            categoryTextField.resignFirstResponder()
        }
        
        if dateTextField.isFirstResponder {
            dateTextField.resignFirstResponder()
        }
    }
    
    @objc func didTapDone() {
        
        if dateTextField.isFirstResponder {
            dateTextField.text = Date.converToString(from: datePicker.date, type: .full)
            viewModel.dateString = datePicker.date
            dateTextField.resignFirstResponder()
        }
        
        if categoryTextField.isFirstResponder {
            categoryTextField.resignFirstResponder()
        }
    }
    
    @objc func handleDone() {
        guard let category = viewModel.selectedCateogry,
              let date = viewModel.dateString,
              let name = scheduleTextField.text else {
            return
        }
        
        viewModel.createSchedule(goalId: Int64(category.id), date: date, name: name)
        
        NotificationCenter.default.post(name: NSNotification.Name("dismissCreateView"), object: Date.converToString(from: date, type: .full), userInfo: nil)
        
        dismiss(animated: true)
    }
    
    @objc func handleDismissal() {
        dismiss(animated: true)
    }
    
}

extension CreateScheduleController : UITextFieldDelegate {
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
}

