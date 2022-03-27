
import UIKit
import RxCocoa

class DetailCell: UITableViewCell {
    
    //MARK: - Properties
    static let reuseIdentifier = "DetailCell"
    
    var schedule: Schedule? {
        didSet{
            guard let schedule = schedule else {
                return
            }
            configure(schedule: schedule)
        }
    }
    
    private var scheduleLabel = UILabel().then {
        $0.text = "프로젝트 기획서 마감"
        $0.font = .systemFont(ofSize: 18)
        $0.textColor = .black
        $0.textAlignment = .left
    }
    
    private var dateLabel = UILabel().then {
        $0.text = "2022년 03월 12일"
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .lightGray
        $0.textAlignment = .left
    }
    
    //MARK: - LifeCycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        
        contentView.addSubview(scheduleLabel)
        scheduleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.left.equalToSuperview().offset(15)
        }
        
        contentView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.left.equalTo(scheduleLabel.snp.left)
            make.top.equalTo(scheduleLabel.snp.bottom).offset(3)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Configure
    func configure(schedule:Schedule) {

        scheduleLabel.attributedText = schedule.isDone ? schedule.text.strikeThrough() : NSAttributedString(string: schedule.text)

    }
}

