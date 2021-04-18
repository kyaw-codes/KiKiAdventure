//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

let viewRect = CGRect(x: 0, y: 0, width: 750, height: 500)

public class CoverPage: UIViewController {
    
    // A flag indicating whether the view is appeared for the first time or not
    private var animateForTheFirstTime = true
    
    // MARK: - Views
    
    private lazy var containerView: UIView = {
        let view = UIView(frame: viewRect)
        view.backgroundColor = .gameBluePrimary
        return view
    }()
    
    private let backgroundImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "cover_bg"))
        iv.frame = CGRect(x: 40, y: 30, width: 670, height: 438)
        iv.layer.cornerRadius = 60
        return iv
    }()
    
    private let kikiImageView: UIImageView = {
        let iv = UIImageView(frame: CGRect(x: 260, y: 82, width: 220, height: 223))
        iv.image = UIImage(named: "kiki_icon")
        iv.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        iv.alpha = 0
        return iv
    }()
    
    private let chatBubbleImageView: UIImageView = {
        let iv = UIImageView(frame: CGRect(x: 469, y: 96, width: 140, height: 79.26))
        iv.image = UIImage(named: "chat_bubble")
        iv.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        iv.alpha = 0
        return iv
    }()
    
    private let introLabel: UILabel = {
        let lbl = UILabel(frame: CGRect(x: 197, y: 352, width: 357, height: 52))
        lbl.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        lbl.textColor = .gameYellow
        lbl.numberOfLines = 2
        lbl.textAlignment = .center
        return lbl
    }()
    
    private let beginButton: UIButton = {
        let btn = UIButton(frame: CGRect(x: 612, y: 360, width: 107, height: 44))
        btn.setBackgroundImage(UIImage(named: "begin_button"), for: .normal)
        btn.addTarget(self, action: #selector(handleBegin), for: .touchUpInside)
        return btn
    }()
    
    // MARK: - Lifecycles
    
    public override func loadView() {
        navigationController?.navigationBar.isHidden = true
        containerView.addSubview(backgroundImageView)
        containerView.addSubview(kikiImageView)
        containerView.addSubview(chatBubbleImageView)
        containerView.addSubview(introLabel)
        containerView.addSubview(beginButton)
        
        self.view = containerView
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        SongManager.shared.introSong.play()
        SongManager.shared.introSong.numberOfLoops = -1
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if animateForTheFirstTime {
            // add animation
            animate(kikiIV: kikiImageView, chatBubbleIV: chatBubbleImageView, introLabel: introLabel)
            animateForTheFirstTime = false
        }
    }
    
    // MARK: - Animations
    
    private func animate(kikiIV: UIImageView, chatBubbleIV: UIImageView, introLabel: UILabel) {
        UIView.animate(withDuration: 0.5, delay: 0.3, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            kikiIV.transform = .identity
            kikiIV.alpha = 1
        }, completion: { [weak self] _ in
            self?.animate(chatBubble: chatBubbleIV, introLabel: introLabel)
        })
    }
    
    private func animate(chatBubble imageView: UIImageView, introLabel: UILabel) {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut) {
            imageView.transform = .identity
            imageView.alpha = 1
        } completion: {_ in
            AnimationManager.shared.typeWritingAnimation(for: introLabel, with: "Step into KiKi’s shoes, living in a country where the military seized the power", duration: 1, textShouldFadeIn: true)
        }
    }
    
    // MARK: - Handler
    
    @objc func handleBegin() {
        containerView.layer.removeAllAnimations()
        SongManager.shared.paperFlickSong.play()
        
        PageTransitionManager.navigate(to: ChapterZero(), from: self)
    }
}

// Custom font registration
let cfURL = Bundle.main.url(forResource: "Calistoga-Regular", withExtension: "ttf")! as CFURL
CTFontManagerRegisterFontsForURL(cfURL, CTFontManagerScope.process, nil)


// Present the view controller in the Live View window
let navController = UINavigationController(rootViewController: CoverPage())
navController.view.frame = viewRect
navController.view.backgroundColor = .gameBluePrimary
PlaygroundPage.current.liveView = navController.view
