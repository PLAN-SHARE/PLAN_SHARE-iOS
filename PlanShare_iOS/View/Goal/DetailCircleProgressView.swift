import UIKit

class DetailCircleProgressView: UIView {
    
    //MARK: - Properties
    private var circleLayer = CAShapeLayer()
    private var progressLayer = CAShapeLayer()
    private var startPoint = CGFloat(-Double.pi / 2)
    private var endPoint = CGFloat(3 * Double.pi / 2)
    
    var goal: Goal? {
        didSet{
            guard let goal = goal else {
                return
            }
            guard let schedule = goal.schedules else { return }
            
            progressLayer.strokeEnd = Double(Double(goal.doneSchedule) / Double(schedule.count))
            circleLayer.strokeColor = UIColor(hex:goal.color).cgColor
            progressLayer.strokeColor = UIColor(hex:goal.color).cgColor
            percentLabel.text = schedule.count == 0 ? "0%" :  String(round(Double(Double(goal.doneSchedule) / Double(schedule.count)) * 100)) + "%"
        }
    }
    
    var percentLabel = UILabel().then{
        $0.font = .noto(size: 20, family: .Regular)
        $0.text = "100%"
        $0.textColor = .black
    }
    
    //MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
        addSubview(percentLabel)
        percentLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        createCircularPath()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func createCircularPath() {
        // created circularPath for circleLayer and progressLayer
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: 0, y: 0), radius: frame.height/2, startAngle: startPoint, endAngle: endPoint, clockwise: true)
        // circleLayer path defined to circularPath
        circleLayer.path = circularPath.cgPath
        // ui edits
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineCap = .round
        circleLayer.lineWidth = 12
        circleLayer.strokeEnd = 1.0
        circleLayer.strokeColor = UIColor.gray.cgColor
        circleLayer.opacity = 0.4
        // added circleLayer to layer
        layer.addSublayer(circleLayer)
        // progressLayer path defined to circularPath
        progressLayer.path = circularPath.cgPath
        // ui edits
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineCap = .round
        progressLayer.lineWidth = 12
        progressLayer.strokeEnd = 0
        progressLayer.strokeColor = UIColor.white.cgColor
        // added progressLayer to layer
        layer.addSublayer(progressLayer)
        
    }
}
