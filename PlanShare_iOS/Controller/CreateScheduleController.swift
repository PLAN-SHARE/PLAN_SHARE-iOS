//
//  SetScheduleController.swift
//  PlanShare_iOS
//
//  Created by doyun on 2022/02/23.
//

import UIKit
import RxCocoa
import RxSwift

class CreateScheduleController: UIViewController {
    
    //MARK: - Properties
    private var viewModel: CreateViewModel!
    private var disposeBag = DisposeBag()
    
    private var pickerView = UIPickerView()
    private var datePicker = UIDatePicker()
    private var isAlarm = false
    
    private var categories = ["프로젝트","장보기","과제","운동"]
    private var categoryRelay = BehaviorRelay<[Category]>(value: [])
    private var selectedCateogry : Category!
    
    private let categoryLabel = UILabel().then{
        $0.text = "목표"
        $0.textColor = .black
        $0.font = .boldSystemFont(ofSize: 18)
    }
    
    private lazy var categoryTextField = UITextField().then {
        $0.textColor = .black
        $0.backgroundColor = .red
        $0.inputView = pickerView
        $0.font = .systemFont(ofSize: 20)
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: view.frame.width, height: 44.0))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let cancel = UIBarButtonItem(title: "취소", style: .plain, target: nil, action: #selector(didTapCancel))
        let barButton = UIBarButtonItem(title: "확인", style: .done, target: target, action: #selector(didTapDone))
        
        toolBar.setItems([cancel, flexible, barButton], animated: false)
        $0.inputAccessoryView = toolBar
    }
    
    private let scheudleLabel = UILabel().then{
        $0.text = "해야할 일"
        $0.textColor = .black
        $0.font = .boldSystemFont(ofSize: 18)
    }
    
    private lazy var scheduleTextField = UITextField().then {
        $0.font = .systemFont(ofSize: 20)
        $0.textColor = .black
        $0.clearButtonMode = .whileEditing
        $0.textAlignment = .left
        $0.placeholder = "계획을 입력해주세요"
        
    }
    
    private let startDateLabel = UILabel().then{
        $0.text = "시작 시간"
        $0.textColor = .black
        $0.font = .boldSystemFont(ofSize: 18)
    }
    
    private lazy var startDateTextField = UITextField().then {
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
        
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: view.frame.width, height: 44.0))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let cancel = UIBarButtonItem(title: "취소", style: .plain, target: nil, action: #selector(didTapCancel))
        let barButton = UIBarButtonItem(title: "확인", style: .done, target: target, action: #selector(didTapDone))
        
        toolBar.setItems([cancel, flexible, barButton], animated: false)
        toolBar.tintColor = .black
        $0.inputAccessoryView = toolBar
    }
    
    private let endDateLabel = UILabel().then{
        $0.text = "종료 시간"
        $0.textColor = .black
        $0.font = .boldSystemFont(ofSize: 18)
    }
    
    private lazy var endDateTextField = UITextField().then {
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
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: view.frame.width, height: 44.0))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let cancel = UIBarButtonItem(title: "취소", style: .plain, target: nil, action: #selector(didTapCancel))
        let barButton = UIBarButtonItem(title: "확인", style: .done, target: target, action: #selector(didTapDone))
        
        toolBar.setItems([cancel, flexible, barButton], animated: false)
        toolBar.tintColor = .black
        $0.inputAccessoryView = toolBar
    }
    
    private let alarmLabel = UILabel().then{
        $0.text = "알람 설정"
        $0.textColor = .black
        $0.font = .boldSystemFont(ofSize: 22)
    }
    
    private lazy var alarmSwitch = UISwitch().then {
        $0.isOn = false
        $0.addTarget(self, action: #selector(alarmOnoff), for: .valueChanged)
    }
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configurePicker()
        configureUI()
        configureNavigationbar()
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
    func fetchCategories(){
        viewModel.fetchCategories()
            .subscribe(onNext: {
                self.categoryRelay.accept($0)
            }).disposed(by: disposeBag)
        
        pickerView.rx.itemSelected
            .subscribe { event in
                self.selectedCateogry = self.categoryRelay.value[event.element!.row]
                self.categoryTextField.text = self.categoryRelay.value[event.element!.row].title
            }.disposed(by: disposeBag)
    }
    
    func bind() {
        categoryRelay.bind(to: pickerView.rx.itemTitles) { $1.title }
            .disposed(by: disposeBag)
    }
    //MARK: - Configure
    func configureUI(){
        view.backgroundColor = .white
        
        view.addSubview(categoryLabel)
        categoryLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(35)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.width.equalTo(45)
        }
        
        view.addSubview(categoryTextField)
        categoryTextField.snp.makeConstraints { make in
            make.left.equalTo(categoryLabel.snp.right).offset(10)
            make.right.equalToSuperview().offset(-32)
            make.centerY.equalTo(categoryLabel.snp.centerY)
            make.height.equalTo(35)
        }
        
        let ul1 = UIView()
        ul1.backgroundColor = .lightGray
        
        view.addSubview(ul1)
        ul1.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.height.equalTo(1)
            make.top.equalTo(categoryLabel.snp.bottom).offset(5)
        }
        
        view.addSubview(scheudleLabel)
        scheudleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(30)
            make.top.equalTo(ul1.snp.bottom).offset(20)
        }
        
        view.addSubview(scheduleTextField)
        scheduleTextField.snp.makeConstraints { make in
            make.left.equalTo(scheudleLabel.snp.right).offset(32)
            make.right.equalToSuperview().offset(-32)
            make.centerY.equalTo(scheudleLabel.snp.centerY)
            make.height.equalTo(35)
        }
        
        let ul2 = UIView()
        ul2.backgroundColor = .lightGray
        
        view.addSubview(ul2)
        ul2.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(35)
            make.right.equalToSuperview().offset(-35)
            make.height.equalTo(1)
            make.top.equalTo(scheduleTextField.snp.bottom)
        }
        
        view.addSubview(startDateLabel)
        startDateLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(32)
            make.top.equalTo(ul2.snp.bottom).offset(20)
        }
        
        view.addSubview(startDateTextField)
        startDateTextField.snp.makeConstraints { make in
            make.left.equalTo(startDateLabel.snp.right).offset(35)
            make.right.equalToSuperview().offset(-35)
            make.centerY.equalTo(startDateLabel.snp.centerY)
            make.height.equalTo(35)
        }
        
        
        view.addSubview(endDateLabel)
        endDateLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(30)
            make.top.equalTo(startDateTextField.snp.bottom).offset(20)
        }
        
        view.addSubview(endDateTextField)
        endDateTextField.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.top.equalTo(endDateLabel.snp.bottom).offset(20)
            make.height.equalTo(50)
        }
        
        view.addSubview(alarmLabel)
        alarmLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(30)
            make.top.equalTo(endDateTextField.snp.bottom).offset(30)
        }
        
        view.addSubview(alarmSwitch)
        alarmSwitch.snp.makeConstraints { make in
            make.centerY.equalTo(alarmLabel.snp.centerY)
            make.right.equalToSuperview().offset(-30)
        }
    }
    
    func configurePicker(){
        datePicker.preferredDatePickerStyle = .inline
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ko-KR")
        datePicker.timeZone = .autoupdatingCurrent
        scheduleTextField.delegate = self
    }
    
    func configureNavigationbar() {
        navigationItem.title = "목표 설정"
        navigationItem.titleView?.tintColor = .black
        navigationController?.navigationBar.tintColor = .black
        let cancelButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .done, target: self, action: #selector(handleDismissal))
        
        let doneButton = UIBarButtonItem(image: UIImage(systemName: "checkmark"), style: .done, target: self, action: #selector(handleDone))
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = doneButton
    }
    
    //MARK: - selector
    @objc func didTapCancel(){
        if categoryTextField.isFirstResponder {
            categoryTextField.resignFirstResponder()
        }
        
        if startDateTextField.isFirstResponder {
            startDateTextField.resignFirstResponder()
        }
        
        if endDateTextField.isFirstResponder {
            endDateTextField.resignFirstResponder()
        }
    }
    
    @objc func didTapDone() {
        if categoryTextField.isFirstResponder {
            categoryTextField.text = categories[pickerView.selectedRow(inComponent: 0)]
            categoryTextField.resignFirstResponder()
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        
        if startDateTextField.isFirstResponder {
            startDateTextField.text = dateFormatter.string(from: datePicker.date)
            startDateTextField.resignFirstResponder()
        }
        
        if endDateTextField.isFirstResponder {
            endDateTextField.text = dateFormatter.string(from: datePicker.date)
            endDateTextField.resignFirstResponder()
        }
        
    }
    @objc func didTapGoal(){
        let alert = UIAlertController(title: "목표롤 설정해주세요", message: nil, preferredStyle: .actionSheet)
        alert.isModalInPopover = true
        alert.view.addSubview(pickerView)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
            
//            print("You selected " + self.typeValue )
            
        }))
        
    }
    @objc func handleDone() {
        navigationController?.popViewController(animated: false)
    }
    
    @objc func handleDismissal() {
        navigationController?.popViewController(animated: false)
    }
    @objc func alarmOnoff(){
        isAlarm.toggle()
        alarmSwitch.setOn(isAlarm, animated: true)
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

