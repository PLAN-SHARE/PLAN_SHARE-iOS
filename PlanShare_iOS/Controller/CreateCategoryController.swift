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
    
    private var selectButtons = [UIButton]()
    private var colorPickerView : ColorPickerView!
    private var selectedColor : UIColor?
    private var selectedIcon: String?
    
    private var selectedIndex : Int? {
        didSet {
            if oldValue == nil && selectedIndex != nil{
                selectButtons[selectedIndex!-1].backgroundColor = .lightGray
            } else if oldValue != nil && selectedIndex == nil {
                selectButtons[oldValue!-1].backgroundColor = .white
            } else {
                selectButtons[oldValue!-1].backgroundColor = .white
                selectButtons[selectedIndex!-1].backgroundColor = .lightGray
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
    
    private var iconCollectionView : UICollectionView!
    
    private lazy var moreButton = UIButton().then {
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
    
    private let privateDisclosureLabel = UILabel().then{
        $0.text = "나만 보기"
        $0.textColor = .lightGray
        $0.font = .boldSystemFont(ofSize: 16)
    }
    
    private lazy var fullDisclosureButton = UIButton().then{
        $0.layer.cornerRadius = 20/2
        $0.layer.borderColor = UIColor.lightGray.cgColor
        $0.layer.borderWidth = 1
        $0.backgroundColor = .white
        $0.tag = 1
        $0.addTarget(self, action: #selector(didTapDisclosure), for: .touchUpInside)
    }
    
    private lazy var privateDisclosureButton = UIButton().then{
        $0.layer.cornerRadius = 20/2
        $0.layer.borderColor = UIColor.lightGray.cgColor
        $0.layer.borderWidth = 1
        $0.backgroundColor = .white
        $0.tag = 2
        $0.addTarget(self, action: #selector(didTapDisclosure), for: .touchUpInside)
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
        configureCollectionView()
        configureUI()
        configureTextField()
        fetchIcons()
        bind()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.post(name: NSNotification.Name("dismissCreateView"), object: nil, userInfo: nil)
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
        view.backgroundColor = .white
        navigationController?.navigationBar.backgroundColor = .white
        
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
        
        view.addSubview(iconCollectionView)
        iconCollectionView.snp.makeConstraints { make in
            make.top.equalTo(iconLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(25)
            make.right.equalToSuperview().offset(-25)
            make.height.equalTo(60)
        }
        
//        let underline2 = UIView()
//        underline2.backgroundColor = .lightGray
//
//        view.addSubview(underline2)
//        underline2.snp.makeConstraints { make in
//            make.left.equalToSuperview().offset(20)
//            make.right.equalToSuperview().offset(-20)
//            make.height.equalTo(1)
//            make.top.equalTo(iconCollectionView.snp.bottom).offset(10)
//        }
//
//        view.addSubview(moreButton)
//        moreButton.snp.makeConstraints { make in
//            make.right.equalToSuperview().offset(-15)
//            make.centerY.equalTo(iconCollectionView.snp.centerY)
//        }
        
        view.addSubview(scopeRangeLabel)
        scopeRangeLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.top.equalTo(iconCollectionView.snp.bottom).offset(20)
        }
        
        view.addSubview(fullDisclosureLabel)
        fullDisclosureLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(30)
            make.top.equalTo(scopeRangeLabel.snp.bottom).offset(24)
        }
        
        view.addSubview(privateDisclosureLabel)
        privateDisclosureLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(30)
            make.top.equalTo(fullDisclosureLabel.snp.bottom).offset(20)
        }
        
        view.addSubview(fullDisclosureButton)
        fullDisclosureButton.snp.makeConstraints { make in
            make.centerY.equalTo(fullDisclosureLabel.snp.centerY)
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
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configureNavigation() {
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
        
        colorPickerView.colors = [#colorLiteral(red: 1, green: 0.5411764706, blue: 0.5019607843, alpha: 1), #colorLiteral(red: 1, green: 0.09019607843, blue: 0.2666666667, alpha: 1), #colorLiteral(red: 0.8352941176, green: 0, blue: 0, alpha: 1), #colorLiteral(red: 0.7254901961, green: 0.9647058824, blue: 0.7921568627, alpha: 1), #colorLiteral(red: 0, green: 0.9019607843, blue: 0.462745098, alpha: 1), #colorLiteral(red: 0, green: 0.7843137255, blue: 0.3254901961, alpha: 1), #colorLiteral(red: 0.9176470588, green: 0.5019607843, blue: 0.9882352941, alpha: 1), #colorLiteral(red: 0.8352941176, green: 0, blue: 0.9764705882, alpha: 1), #colorLiteral(red: 0.6666666667, green: 0, blue: 1, alpha: 1), #colorLiteral(red: 1, green: 1, blue: 0.5529411765, alpha: 1), #colorLiteral(red: 1, green: 0.9176470588, blue: 0, alpha: 1), #colorLiteral(red: 1, green: 0.8392156863, blue: 0, alpha: 1), #colorLiteral(red: 0.7019607843, green: 0.5333333333, blue: 1, alpha: 1), #colorLiteral(red: 0.3960784314, green: 0.1215686275, blue: 1, alpha: 1), #colorLiteral(red: 0.3843137255, green: 0, blue: 0.9176470588, alpha: 1), #colorLiteral(red: 1, green: 0.8196078431, blue: 0.5019607843, alpha: 1), #colorLiteral(red: 1, green: 0.568627451, blue: 0, alpha: 1), #colorLiteral(red: 1, green: 0.4274509804, blue: 0, alpha: 1),                       #colorLiteral(red: 0.5490196078, green: 0.6196078431, blue: 1, alpha: 1), #colorLiteral(red: 0, green: 0.6901960784, blue: 1, alpha: 1), #colorLiteral(red: 0, green: 0.568627451, blue: 0.9176470588, alpha: 1), #colorLiteral(red: 1, green: 0.6196078431, blue: 0.5019607843, alpha: 1), #colorLiteral(red: 1, green: 0.2392156863, blue: 0, alpha: 1), #colorLiteral(red: 0.8666666667, green: 0.1725490196, blue: 0, alpha: 1), #colorLiteral(red: 0.5019607843, green: 0.8470588235, blue: 1, alpha: 1), #colorLiteral(red: 0, green: 0.6901960784, blue: 1, alpha: 1), #colorLiteral(red: 0, green: 0.568627451, blue: 0.9176470588, alpha: 1), #colorLiteral(red: 0.737254902, green: 0.6666666667, blue: 0.6431372549, alpha: 1), #colorLiteral(red: 0.4745098039, green: 0.3333333333, blue: 0.2823529412, alpha: 1), #colorLiteral(red: 0.3058823529, green: 0.2039215686, blue: 0.1803921569, alpha: 1), #colorLiteral(red: 0.5176470588, green: 1, blue: 1, alpha: 1), #colorLiteral(red: 0, green: 0.8980392157, blue: 1, alpha: 1), #colorLiteral(red: 0, green: 0.7215686275, blue: 0.831372549, alpha: 1), #colorLiteral(red: 0.7411764706, green: 0.7411764706, blue: 0.7411764706, alpha: 1), #colorLiteral(red: 0.3803921569, green: 0.3803921569, blue: 0.3803921569, alpha: 1), #colorLiteral(red: 0.1294117647, green: 0.1294117647, blue: 0.1294117647, alpha: 1) ]
        
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
        layout.minimumInteritemSpacing = 6
        layout.itemSize = CGSize(width: 45, height: 45)
        layout.scrollDirection = .horizontal
        
        iconCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        iconCollectionView.backgroundColor = .systemBackground
        iconCollectionView.register(IconCell.self, forCellWithReuseIdentifier: IconCell.reuseIdentifier)
        iconCollectionView.showsHorizontalScrollIndicator = false
        iconCollectionView.showsVerticalScrollIndicator = false
        iconCollectionView.allowsMultipleSelection = false
    }
    
    //MARK: - Bind
    func fetchIcons() {
        viewModel.fetchIcons()
            .subscribe(onNext: {
                self.iconSubject.accept($0)
            }).disposed(by: disposBag)
    }
    
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
        guard let selectedIndex = selectedIndex,
              let visibility = selectedIndex == 1 ? true : false,
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
        navigationController?.popViewController(animated: false)
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
        
        if selectedIndex == nil {
            selectedIndex = tag
        } else {
            if selectedIndex == tag {
                selectedIndex = nil
            } else {
                selectedIndex = tag
            }
        }
        
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
        return CGSize(width: 50, height: 50)
    }
    
    func colorPickerView(_ colorPickerView: ColorPickerView, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    func colorPickerView(_ colorPickerView: ColorPickerView, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
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

