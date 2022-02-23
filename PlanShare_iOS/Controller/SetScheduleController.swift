//
//  SetScheduleController.swift
//  PlanShare_iOS
//
//  Created by doyun on 2022/02/23.
//

import UIKit

class SetScheduleController: UIViewController {
    
    private var pickerView = UIPickerView()
    private var datePicker = UIDatePicker()
    private var isAlarm = false
    private var categories = ["프로젝트","장보기","과제","운동"]
    
    private let categoryLabel = UILabel().then{
        $0.text = "목표"
        $0.textColor = .black
        $0.font = .boldSystemFont(ofSize: 22)
    }
    
    private lazy var categoryTextField = UITextField().then {
        $0.textColor = .black
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
        $0.font = .boldSystemFont(ofSize: 22)
    }
    
    private lazy var scheduleTextField = UITextField().then {
        $0.font = .systemFont(ofSize: 20)
        $0.textColor = .black
        $0.clearButtonMode = .whileEditing
        $0.textAlignment = .left
        
    }
    
    private let startDateLabel = UILabel().then{
        $0.text = "시작 시간"
        $0.textColor = .black
        $0.font = .boldSystemFont(ofSize: 22)
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
        toolBar.tintColor = .white
        $0.inputAccessoryView = toolBar
    }
    
    private let endDateLabel = UILabel().then{
        $0.text = "종료 시간"
        $0.textColor = .black
        $0.font = .boldSystemFont(ofSize: 22)
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
        toolBar.tintColor = .white
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurePicker()
        configureUI()
        configureNavigationbar()
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(view.endEditing))
        view.addGestureRecognizer(tapGesture)

    }
    //MARK: - Configure
    func configureUI(){
        view.backgroundColor = .white
        view.addSubview(categoryLabel)
        categoryLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(24)
        }
        view.addSubview(categoryTextField)
        categoryTextField.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.top.equalTo(categoryLabel.snp.bottom).offset(25)
            make.height.equalTo(40)
        }
        
        let ul1 = UIView()
        ul1.backgroundColor = .lightGray
        
        view.addSubview(ul1)
        ul1.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(1)
            make.top.equalTo(categoryTextField.snp.bottom)
        }
        
        view.addSubview(scheudleLabel)
        scheudleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.top.equalTo(ul1.snp.bottom).offset(20)
        }
        
        view.addSubview(scheduleTextField)
        scheduleTextField.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.top.equalTo(scheudleLabel.snp.bottom).offset(25)
            make.height.equalTo(45)
        }
        
        let ul2 = UIView()
        ul2.backgroundColor = .lightGray
        
        view.addSubview(ul2)
        ul2.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(1)
            make.top.equalTo(scheduleTextField.snp.bottom)
        }
        
        view.addSubview(startDateLabel)
        startDateLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.top.equalTo(ul2.snp.bottom).offset(20)
        }
        
        view.addSubview(startDateTextField)
        startDateTextField.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.top.equalTo(startDateLabel.snp.bottom).offset(25)
            make.height.equalTo(50)
        }
        
        
        view.addSubview(endDateLabel)
        endDateLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.top.equalTo(startDateTextField.snp.bottom).offset(20)
        }
        
        view.addSubview(endDateTextField)
        endDateTextField.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.top.equalTo(endDateLabel.snp.bottom).offset(25)
            make.height.equalTo(50)
        }
        
        view.addSubview(alarmLabel)
        alarmLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.top.equalTo(endDateTextField.snp.bottom).offset(30)
        }
        
        view.addSubview(alarmSwitch)
        alarmSwitch.snp.makeConstraints { make in
            make.centerY.equalTo(alarmLabel.snp.centerY)
            make.right.equalToSuperview().offset(-30)
            
        }
        
    }
    
    func configurePicker(){
        pickerView.delegate = self
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .dateAndTime
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
        dateFormatter.dateFormat = "yyyy년 MM월 dd일 a hh:mm"
        
        if startDateTextField.isFirstResponder {
            startDateTextField.text = dateFormatter.string(from: datePicker.date)
            startDateTextField.resignFirstResponder()
        }
        
        if endDateTextField.isFirstResponder {
            endDateTextField.text = dateFormatter.string(from: datePicker.date)
            endDateTextField.resignFirstResponder()
        }
        
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

extension SetScheduleController : UITextFieldDelegate {
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
}
extension SetScheduleController : UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
    }
    
}


