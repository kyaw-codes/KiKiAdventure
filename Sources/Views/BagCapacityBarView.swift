import UIKit

public class BagCapacityBarView: UIView {

    var value: CGFloat = 0 {
        didSet {
            updateView()
        }
    }
    
    private var barHeightAnchor: NSLayoutConstraint?
    
    private let barValueView: UIView = {
        let view = UIView()
        view.backgroundColor = .gameBluePrimary
        return view
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.gameBluePrimary.withAlphaComponent(0.3)
        clipsToBounds = true
        
        addSubview(barValueView)
        barValueView.translatesAutoresizingMaskIntoConstraints = false
        barValueView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        barValueView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        barValueView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        barHeightAnchor = barValueView.heightAnchor.constraint(equalToConstant: 0)
        barHeightAnchor?.isActive = true
    }
    
    public override func layoutSubviews() {
        updateView()
    }
    
    private func updateView() {
        let height: CGFloat = (frame.height / 6) * value
        barHeightAnchor?.constant = height
        self.layoutIfNeeded()
    }

    public required init?(coder: NSCoder) {
        fatalError()
    }
}

