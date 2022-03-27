
import UIKit
import RxSwift
import RxCocoa

class ScheduleCell: UICollectionViewCell {
    
    //MARK: - Properties
    static let reuseIdentifier = "ScheduleCell"
    
    private var disposBag = DisposeBag()
    
    var schedule: Schedule? {
        didSet{
            guard let schedule = schedule else {
                return
            }
            configure(schedule: schedule)
        }
    }
    
    private var isChecked : Bool? {
        didSet {
            
        }
    }
    private var scheduleLabel = UILabel().then {
        $0.text = "프로젝트 기획서 마감"
        $0.font = .systemFont(ofSize: 16)
        $0.textColor = .darkGray
        $0.textAlignment = .left
    }
    
    private lazy var checkButton = UIButton().then {
        $0.setImage(UIImage(systemName: "checkmark"), for: .normal)
        $0.contentMode = .scaleAspectFit
        $0.layer.masksToBounds = false
        $0.layer.borderColor = UIColor.init(named: "a1b5f5")?.cgColor
        $0.layer.borderWidth = 0.7
        $0.tintColor = .white
        $0.layer.cornerRadius = 23/2
    }
    
    //MARK: - LifeCycle
    override init(frame:CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemGroupedBackground
        
        contentView.addSubview(scheduleLabel)
        scheduleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(10)
        }
        
        contentView.addSubview(checkButton)
        checkButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(23)
        }
        
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 10
        contentView.layer.borderWidth = 1.0

        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = true
        
        checkButton.rx.tap.bind {
            self.schedule?.isDone.toggle()
            self.isChecked = self.schedule?.isDone
        }.disposed(by: disposBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Configure
    func configure(schedule:Schedule) {

        checkButton.backgroundColor = schedule.isDone ? .init(hex: "a1b5f5") : .white
        scheduleLabel.attributedText = schedule.isDone ? schedule.text.strikeThrough() : NSAttributedString(string: schedule.text)
    }
}
