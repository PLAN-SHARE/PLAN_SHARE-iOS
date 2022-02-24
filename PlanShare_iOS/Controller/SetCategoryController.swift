//
//  SetGoalController.swift
//  PlanShare_iOS
//
//  Created by doyun on 2022/02/22.
//

import UIKit
import IGColorPicker

class SetCategoryController: UIViewController {
    
    //MARK: - Properties
    private var selectButtons = [UIButton]()
    
    private var colorPickerView : ColorPickerView!
    private var selectedColor : UIColor?
    
    private var selectIndex : Int? {
        didSet {
            if oldValue == nil && selectIndex != nil{
                selectButtons[selectIndex!-1].backgroundColor = .lightGray
            } else if oldValue != nil && selectIndex == nil {
                selectButtons[oldValue!-1].backgroundColor = .white
            } else {
                selectButtons[oldValue!-1].backgroundColor = .white
                selectButtons[selectIndex!-1].backgroundColor = .lightGray
            }
        }
    }
    
    private let goalLabel = UILabel().then{
        $0.text = "목표"
        $0.textColor = .black
        $0.font = .boldSystemFont(ofSize: 22)
    }
    
    private let goalTextField = UITextField().then{
        $0.backgroundColor = .white
        $0.font = .systemFont(ofSize: 18)
        $0.clearButtonMode = .whileEditing
        $0.textColor = .black
        $0.tintColor = .black
        
    }
    
    private let iconLabel = UILabel().then{
        $0.text = "아이콘"
        $0.textColor = .black
        $0.font = .boldSystemFont(ofSize: 22)
    }
    
    private let moreButton = UIButton().then {
        $0.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        $0.tintColor = .darkGray
        $0.addTarget(self, action: #selector(handleMoreIcons), for: .touchUpInside)
        $0.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        $0.contentMode = .scaleToFill
    }
    
    private let scopeRangeLabel = UILabel().then{
        $0.text = "공개 범위"
        $0.textColor = .black
        $0.font = .boldSystemFont(ofSize: 22)
    }
    
    private let fullDisclosureLabel = UILabel().then{
        $0.text = "전체 공개"
        $0.textColor = .lightGray
        $0.font = .boldSystemFont(ofSize: 16)
    }
    
    private let someDisclosureLabel = UILabel().then{
        $0.text = "일부 공개"
        $0.textColor = .lightGray
        $0.font = .boldSystemFont(ofSize: 16)
    }
    
    private let privateDisclosureLabel = UILabel().then{
        $0.text = "나만 보기"
        $0.textColor = .lightGray
        $0.font = .boldSystemFont(ofSize: 16)
    }
    
    private let fullDisclosureButton = UIButton().then{
        $0.layer.cornerRadius = 20/2
        $0.layer.borderColor = UIColor.lightGray.cgColor
        $0.layer.borderWidth = 3
        
        $0.backgroundColor = .white
        $0.tag = 1
        $0.addTarget(self, action: #selector(didTapDisclosure(_:)), for: .touchUpInside)
        
    }
    private let someDisclosureButton = UIButton().then{
        $0.layer.cornerRadius = 20/2
        $0.layer.borderColor = UIColor.lightGray.cgColor
        $0.layer.borderWidth = 3
        
        $0.backgroundColor = .white
        $0.tag = 2
        $0.addTarget(self, action: #selector(didTapDisclosure(_:)), for: .touchUpInside)
    }
    private let privateDisclosureButton = UIButton().then{
        $0.layer.cornerRadius = 20/2
        $0.layer.borderColor = UIColor.lightGray.cgColor
        $0.layer.borderWidth = 3
        
        $0.backgroundColor = .white
        $0.tag = 3
        $0.addTarget(self, action: #selector(didTapDisclosure(_:)), for: .touchUpInside)
    }
    
    private let colorLabel = UILabel().then{
        $0.text = "색상"
        $0.textColor = .black
        $0.font = .boldSystemFont(ofSize: 22)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        configureColorPicker()
        configureUI()
        
        // Do any additional setup after loading the view.
    }
    
    //MARK: - configure
    func configureUI(){
        view.backgroundColor = .white
        view.addSubview(goalLabel)
        goalLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        
        view.addSubview(goalTextField)
        goalTextField.snp.makeConstraints { make in
            make.top.equalTo(goalLabel.snp.bottom).offset(15)
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(-30)
            make.height.equalTo(40)
        }
        
        let underline1 = UIView()
        underline1.backgroundColor = .lightGray
        
        view.addSubview(underline1)
        underline1.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(1)
            make.top.equalTo(goalTextField.snp.bottom)
        }
        
        view.addSubview(iconLabel)
        iconLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.top.equalTo(underline1.snp.bottom).offset(20)
        }
        
        let underline2 = UIView()
        underline2.backgroundColor = .lightGray
        
        view.addSubview(underline2)
        underline2.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(1)
            make.top.equalTo(iconLabel.snp.bottom).offset(70)
        }
        
        view.addSubview(moreButton)
        moreButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-15)
            make.bottom.equalTo(underline2.snp.top).offset(-13)
        }
        view.addSubview(scopeRangeLabel)
        scopeRangeLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.top.equalTo(underline2.snp.bottom).offset(20)
        }
        
        view.addSubview(fullDisclosureLabel)
        fullDisclosureLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(30)
            make.top.equalTo(scopeRangeLabel.snp.bottom).offset(24)
        }
        
        view.addSubview(someDisclosureLabel)
        someDisclosureLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(30)
            make.top.equalTo(fullDisclosureLabel.snp.bottom).offset(20)
        }
        
        view.addSubview(privateDisclosureLabel)
        privateDisclosureLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(30)
            make.top.equalTo(someDisclosureLabel.snp.bottom).offset(20)
        }
        view.addSubview(fullDisclosureButton)
        fullDisclosureButton.snp.makeConstraints { make in
            make.centerY.equalTo(fullDisclosureLabel.snp.centerY)
            make.right.equalToSuperview().offset(-25)
            make.width.height.equalTo(20)
        }
        view.addSubview(someDisclosureButton)
        someDisclosureButton.snp.makeConstraints { make in
            make.centerY.equalTo(someDisclosureLabel.snp.centerY)
            make.right.equalToSuperview().offset(-25)
            make.width.height.equalTo(20)
        }
        
        view.addSubview(privateDisclosureButton)
        privateDisclosureButton.snp.makeConstraints { make in
            make.centerY.equalTo(privateDisclosureLabel.snp.centerY)
            make.right.equalToSuperview().offset(-25)
            make.width.height.equalTo(20)
        }
        selectButtons.append(fullDisclosureButton)
        selectButtons.append(someDisclosureButton)
        selectButtons.append(privateDisclosureButton)
        
        let underline3 = UIView()
        underline3.backgroundColor = .lightGray
        
        view.addSubview(underline3)
        underline3.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(1)
            make.top.equalTo(privateDisclosureLabel.snp.bottom).offset(20)
        }
        
        view.addSubview(colorLabel)
        colorLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.top.equalTo(underline3.snp.bottom).offset(20)
        }
        
        view.addSubview(colorPickerView)
        colorPickerView.snp.makeConstraints { make in
            make.top.equalTo(colorLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
            make.height.equalTo(120)
        }
    }
    func configureNavigation() {
        navigationController?.title = "목표 설정"
        navigationItem.title = "목표 설정"
        navigationItem.titleView?.tintColor = .black
        navigationController?.navigationBar.tintColor = .black
        let cancelButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .done, target: self, action: #selector(handleDismissal))
        
        let doneButton = UIBarButtonItem(image: UIImage(systemName: "checkmark"), style: .done, target: self, action: #selector(handleDone))
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = doneButton
    }
    
    func configureColorPicker(){
        colorPickerView = ColorPickerView(frame: .zero)
        colorPickerView.backgroundColor = .white
        
        colorPickerView.colors = [.red,.blue,.lightGray,.black,.brown,.cyan,.orange,.yellow,.green,.magenta,.purple,.systemTeal]
        colorPickerView.delegate = self
        colorPickerView.layoutDelegate = self
        colorPickerView.style = .circle
        colorPickerView.selectionStyle = .check
    }
    //MARK: - selector
    @objc func handleDone(){
        
    }
    @objc func handleDismissal(){
        navigationController?.popViewController(animated: false)
    }
    @objc func handleMoreIcons(){
        
    }
    @objc func didTapDisclosure(_ sender:Any){
        
        guard let tag = (sender as? UIButton)?.tag else {
            return
        }
        if selectIndex == nil {
            selectIndex = tag
        } else {
            if selectIndex == tag {
                selectIndex = nil
            } else {
                selectIndex = tag
            }
        }
        
    }
}
extension SetCategoryController : ColorPickerViewDelegate {
    func colorPickerView(_ colorPickerView: ColorPickerView, didSelectItemAt indexPath: IndexPath) {
        selectedColor = colorPickerView.colors[indexPath.row]
    }
    
    
}
extension SetCategoryController: ColorPickerViewDelegateFlowLayout {
    
    func colorPickerView(_ colorPickerView: ColorPickerView, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 50)
    }
    
    func colorPickerView(_ colorPickerView: ColorPickerView, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func colorPickerView(_ colorPickerView: ColorPickerView, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    
}
