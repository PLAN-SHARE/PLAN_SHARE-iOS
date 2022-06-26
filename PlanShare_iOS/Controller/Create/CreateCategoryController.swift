//
//  SetGoalController.swift
//  PlanShare_iOS
//
//  Created by doyun on 2022/02/22.
//

import UIKit
import IGColorPicker
import RxSwift
import RxRelay
import RxCocoa

class CreateCategoryController: UIViewController {
    
    //MARK: - Properties
    private var viewModel : CreateViewModel!
    private var iconSubject = BehaviorRelay<[String]>(value: [])
    private var disposBag = DisposeBag()
    private var selectedColor : UIColor?
    private var selectedIcon: String?
    
    private var segment: UISegmentedControl = UISegmentedControl(items: ["공개안함","전체공개"])
    
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
        
        $0.addSubview(infoLabel)
        infoLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview().offset(35)
        }
        
        $0.addSubview(goalTextField)
        goalTextField.snp.makeConstraints { make in
            make.top.equalTo(infoLabel.snp.bottom).offset(15)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(40)
        }
        
        $0.addSubview(iconLabel)
        iconLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.top.equalTo(goalTextField.snp.bottom).offset(20)
        }
        
        $0.addSubview(iconCollectionView)
        iconCollectionView.snp.makeConstraints { make in
            make.centerY.equalTo(iconLabel.snp.centerY)
            make.left.equalTo(iconLabel.snp.right).offset(15)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(30)
        }
        
        $0.addSubview(colorLabel)
        colorLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.top.equalTo(iconLabel.snp.bottom).offset(20)
        }
        
        $0.addSubview(colorPickerView)
        colorPickerView.snp.makeConstraints { make in
            make.centerY.equalTo(colorLabel.snp.centerY)
            make.left.equalTo(iconCollectionView.snp.left)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(40)
        }
        
        $0.addSubview(segment)
        segment.snp.makeConstraints { make in
            make.left.equalTo(colorLabel.snp.left)
            make.height.equalTo(40)
            make.width.equalTo(140)
            make.top.equalTo(colorLabel.snp.bottom).offset(20)
        }
        
        $0.addSubview(buttonStackView)
        buttonStackView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(60)
        }
        
        
    }
    
    private lazy var goalTextField = UITextField().then{
        $0.backgroundColor = .white
        $0.font = .systemFont(ofSize: 16)
        $0.clearButtonMode = .whileEditing
        $0.textColor = .black
        $0.tintColor = .black
        $0.placeholder = "목표를 입력해주세요"

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
    
    private let infoLabel = UILabel().then{
        $0.text = "나의 목표 설정하기"
        $0.textColor = .black
        $0.font = .boldSystemFont(ofSize: 16)
    }
    
    private let iconLabel = UILabel().then{
        $0.text = "아이콘"
        $0.textColor = .darkGray
        $0.font = .boldSystemFont(ofSize: 12)
    }
    
    private var iconCollectionView : UICollectionView!
    
    private let colorLabel = UILabel().then{
        $0.text = "색상"
        $0.textColor = .darkGray
        $0.font = .boldSystemFont(ofSize: 12)
    }
    
    private var colorPickerView : ColorPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureColorPicker()
        configureCollectionView()
        configureUI()
        configureTextField()
        fetchIcons()
        bind()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    init(viewModel:CreateViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - configure
    func configureUI(){
        view.backgroundColor = .black.withAlphaComponent(0.3)
        view.alpha = 0.2
        
        view.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(300)
            make.height.equalTo(420)
        }
        segment.selectedSegmentIndex = 0
    }
    
    func configureColorPicker(){
        colorPickerView = ColorPickerView(frame: .zero)
        colorPickerView.backgroundColor = .white
        colorPickerView.colors = [.red,.blue, #colorLiteral(red: 0.5019607843, green: 0.8470588235, blue: 1, alpha: 1), #colorLiteral(red: 1, green: 0.4274509804, blue: 0, alpha: 1), #colorLiteral(red: 0.5490196078, green: 0.6196078431, blue: 1, alpha: 1), #colorLiteral(red: 0.9176470588, green: 0.5019607843, blue: 0.9882352941, alpha: 1)]
        colorPickerView.delegate = self
        colorPickerView.layoutDelegate = self
        colorPickerView.style = .circle
        colorPickerView.selectColor(at: 1, animated: true)
        colorPickerView.selectionStyle = .check
    }
    
    func configureTextField() {
        goalTextField.delegate = self
        goalTextField.becomeFirstResponder()
    }
    
    func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 5
        layout.itemSize = CGSize(width: 25, height: 25)
        layout.scrollDirection = .horizontal
        
        iconCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        iconCollectionView.backgroundColor = .white
        iconCollectionView.register(IconCell.self, forCellWithReuseIdentifier: IconCell.reuseIdentifier)
        iconCollectionView.showsHorizontalScrollIndicator = false
        iconCollectionView.showsVerticalScrollIndicator = false
        iconCollectionView.allowsMultipleSelection = false
    }
    
    //MARK: - Bind
    func fetchIcons() {

        viewModel.fetchIcon()
            .subscribe(onNext: {
                self.iconSubject.accept($0)
            }).disposed(by: disposBag)
    }
    //
    func bind() {
        iconSubject.bind(to: iconCollectionView.rx.items(cellIdentifier: IconCell.reuseIdentifier, cellType: IconCell.self)) { (row,element,cell) in
            cell.icon = element
        }.disposed(by: disposBag)
        
        iconCollectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                let cell = self?.iconCollectionView.cellForItem(at: indexPath) as! IconCell
                cell.isSelected.toggle()
                let iconURL = self?.iconSubject.value[indexPath.row]
                self?.selectedIcon = iconURL
            })
            .disposed(by: disposBag)
    }
    
    //MARK: - selector
    @objc func handleDone(){
        guard let visibility = segment.selectedSegmentIndex == 1 ? true : false,
              let selectedColor = selectedColor,
              let title = goalTextField.text,
              let iconURL = selectedIcon else {

            let alert = UIAlertController(title: "모든 입력창을 채워주세요", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            self.present(alert,animated: true)
            return
        }

        let selectedColorString = selectedColor.toHexString()
        viewModel.createCategory(color: selectedColorString, icon: iconURL, name: title, visibility: visibility) {
            print($0)
        }
        
        NotificationCenter.default.post(name: NSNotification.Name("dismissCreateView"), object: nil, userInfo: nil)
        
        dismiss(animated: true)
    }
    
    @objc func handleDismissal(){
        dismiss(animated: true)
    }
    
}
//MARK: - ColorPickerViewDelegate
extension CreateCategoryController : ColorPickerViewDelegate {
    func colorPickerView(_ colorPickerView: ColorPickerView, didSelectItemAt indexPath: IndexPath) {
        selectedColor = colorPickerView.colors[indexPath.row]
    }
}

//MARK: - ColorPickerViewDelegateFlowLayout
extension CreateCategoryController: ColorPickerViewDelegateFlowLayout {
    func colorPickerView(_ colorPickerView: ColorPickerView, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 25, height: 25)
    }
    
    func colorPickerView(_ colorPickerView: ColorPickerView, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}

//MARK: - UITextFieldDelegate
extension CreateCategoryController : UITextFieldDelegate {
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
}

