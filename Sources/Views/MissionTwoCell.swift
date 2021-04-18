import UIKit

class MissionTwoCell: UICollectionViewCell {
    
    var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    var overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        view.isHidden = true
        return view
    }()
    
    override var isSelected: Bool {
        didSet {
            overlayView.isHidden = !isSelected
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 4
        layer.borderWidth = 1
        layer.borderColor = UIColor.gameYellow.cgColor
        
        addSubview(imageView)
        addSubview(overlayView)
        
        imageView.frame = bounds
        overlayView.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}


