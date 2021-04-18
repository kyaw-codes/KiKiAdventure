import UIKit

public protocol Chapter {
    
    func setupViewData()
}

public class BaseChapter: UIViewController, Chapter {
        
    internal var navigateToNextVC: (() -> Void)?
    
    internal var titleText: String!
    internal var firstParagraphText: String!
    internal var middleParagraphText: String!
    internal var lastParagraphText: String!
    
    private var bodyText: NSAttributedString!
    
    // A flag indicating whether the view is appeared for the first time or not
    internal var animateForTheFirstTime = true

    // MARK: - Views
    
    private var backgroundView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "page_background"))
        iv.frame = CGRect(x: 40, y: 30, width: 670, height: 438)
        iv.layer.cornerRadius = 60
        return iv
    }()
    
    private lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "Calistoga-Regular", size:  40)
        lbl.textColor = .gameYellow
        return lbl
    }()
    
    private lazy var bodyTextView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont(name: "Calistoga-Regular", size:  16)
        tv.isEditable = false
        tv.isUserInteractionEnabled = false
        tv.textColor = .gameAccent
        tv.backgroundColor = .clear
        return tv
    }()

    private lazy var nextButton: UIButton = {
        let btn = UIButton(frame: CGRect(x: 613, y: 360, width: 107, height: 44))
        btn.setBackgroundImage(UIImage(named: "next_button"), for: .normal)
        btn.addTarget(self, action: #selector(handleNextTap), for: .touchUpInside)
        return btn
    }()
    
    private lazy var backButton: UIButton = {
        let btn = UIButton(frame: CGRect(x: 30, y: 360, width: 107, height: 44))
        btn.setBackgroundImage(UIImage(named: "back_button"), for: .normal)
        btn.addTarget(self, action: #selector(handleBackTap), for: .touchUpInside)
        return btn
    }()
    
    // MARK: - Lifecycles
    
    public override func loadView() {
        let view = UIView()
        view.backgroundColor = .gameBluePrimary
        view.addSubview(backgroundView)
        
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 54).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        view.addSubview(bodyTextView)
        bodyTextView.translatesAutoresizingMaskIntoConstraints = false
        bodyTextView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 118).isActive = true
        bodyTextView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -118).isActive = true
        bodyTextView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        bodyTextView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -20).isActive = true

        view.addSubview(nextButton)
        view.addSubview(backButton)
        
        setupViewData()

        self.view = view
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        
        if !SongManager.shared.introSong.isPlaying {
            // Play the song
            SongManager.shared.introSong.play()
        }
        
        if animateForTheFirstTime {
            let bodyText = "\(firstParagraphText!)\n\n\(middleParagraphText!)\n\n\(lastParagraphText!)"
            
            AnimationManager.shared
                .typeWritingAnimation(for: titleLabel, with: titleText, duration: 1)
                .typeWritingAnimation(for: bodyTextView, with: bodyText, duration: 1)
            animateForTheFirstTime = false
        }
    }
    
    // MARK: - Chapter Protocol Method
    
    public func setupViewData() {
        // Must be overrided by sub classes
    }
    
    // MARK: - Handler
    
    @objc private func handleNextTap() {
        view.layer.removeAllAnimations()
        SongManager.shared.paperFlickSong.play()
        navigateToNextVC?()
    }
    
    @objc private func handleBackTap() {
        SongManager.shared.paperFlickSong.play()
        PageTransitionManager.back(from: self)
    }
    
}
