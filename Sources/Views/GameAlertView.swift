import UIKit

public class GameAlertView: UIView {
    
    private let header: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "alert_header"))
        return iv
    }()
    
    internal let headerLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Mission Complete"
        lbl.font = UIFont(name: "Calistoga-Regular", size: 18)
        lbl.textColor = .gameBlueSecondary
        return lbl
    }()
    
    internal let bodyTextLabel: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        lbl.font = UIFont(name: "Calistoga-Regular", size: 14)
        lbl.textColor = .gameAccent
        return lbl
    }()
    
    internal let nextButton: UIButton = {
        let btn = UIButton()
        btn.setBackgroundImage(UIImage(named: "alert_next_button"), for: .normal)
        btn.setTitle("Next", for: .normal)
        btn.titleLabel?.font = UIFont(name: "Calistoga-Regular", size: 14)
        btn.setTitleColor(.gameBlueSecondary, for: .normal)
        return btn
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .gameBlueSecondary
        
        let sv = UIStackView(arrangedSubviews: [header, bodyTextLabel, nextButton])
        sv.axis = .vertical
        sv.alignment = .center
        sv.distribution = .equalSpacing
        
        addSubview(sv)
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 48).isActive = true
        sv.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -48).isActive = true
        sv.topAnchor.constraint(equalTo: self.topAnchor, constant: 24).isActive = true
        sv.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -24).isActive = true
        
        addSubview(headerLabel)
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.centerXAnchor.constraint(equalTo: header.centerXAnchor).isActive = true
        headerLabel.centerYAnchor.constraint(equalTo: header.centerYAnchor, constant: -4).isActive = true
    }
    
    public required init?(coder: NSCoder) {
        fatalError()
    }
}
