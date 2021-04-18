import UIKit

public class BaseMission: UIViewController, Mission {
    
    var delegate: MissionDelegate?
    
    // MARK: - Views
    
    private let backgroundView: UIView = {
        let iv = UIImageView(frame: CGRect(x: 0, y: 0, width: 750, height: 500))
        // If set to false(by default), the underlying button won't get action event
        iv.isUserInteractionEnabled = true
        iv.image = UIImage(named: "mission_background")
        return iv
    }()
    
    internal let titleLabel: UILabel = {
        let lbl = UILabel(frame: CGRect(x: 58, y: 15, width: 450, height: 30))
        lbl.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        lbl.textColor = .gameYellow
        return lbl
    }()
    
    internal let missionNumberLabel: UILabel = {
        let lbl = UILabel(frame: CGRect(x: 642.76, y: 29.22, width: 134.23, height: 21.3))
        lbl.textAlignment = .center
        lbl.transform = CGAffineTransform(rotationAngle: 45 * CGFloat.pi / 180)
        lbl.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        lbl.textColor = .gameBlueSecondary
        return lbl
    }()

    internal lazy var helpButton: UIButton = {
        let btn = UIButton(frame: CGRect(x: 679, y: 103, width: 45, height: 45))
        btn.backgroundColor = .gameBluePrimary
        btn.layer.cornerRadius = 45 / 2
        btn.clipsToBounds = true
        btn.setTitle("?", for: .normal)
        btn.titleLabel?.font = UIFont(name: "Calistoga-Regular", size: 28)
        btn.setTitleColor(.gameYellow, for: .normal)
        btn.addTarget(self, action: #selector(handleHelpButtonTap), for: .touchUpInside)
        return btn
    }()
    
    internal let helpPanel: UIImageView = {
        let iv = UIImageView(frame: CGRect(x: 576, y: 133, width: 148, height: 210))
        iv.alpha = 0
        iv.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        iv.image = UIImage(named: "help_text_bg")
        return iv
    }()
    
    internal let helpLabel: UILabel = {
        let lbl = UILabel(frame: CGRect(x: 586, y: 161, width: 128, height: 141))
        lbl.font = UIFont(name: "Calistoga-Regular", size:  12)
        lbl.textColor = .gameBlueSecondary
        lbl.numberOfLines = 0
        lbl.alpha = 0
        lbl.transform = CGAffineTransform(scaleX: 0, y: 0)
        return lbl
    }()

    internal lazy var skipButton: UIButton = {
        let btn = UIButton(frame: CGRect(x: 679, y: 429, width: 45, height: 45))
        btn.setBackgroundImage(UIImage(named: "skip_button"), for: .normal)
        btn.addTarget(self, action: #selector(handleSkipButtonTap), for: .touchUpInside)
        return btn
    }()
    
    internal lazy var backToStoryButton: UIButton = {
        let btn = UIButton(frame: CGRect(x: 618, y: 429, width: 45, height: 45))
        btn.setBackgroundImage(UIImage(named: "back_to_story"), for: .normal)
        btn.addTarget(self, action: #selector(handleBackButtonTap), for: .touchUpInside)
        return btn
    }()
    
    internal let gameArea: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 61, width: 561, height: 439))
        view.backgroundColor = .clear
        return view
    }()
    
    internal let overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gameTeal.withAlphaComponent(0.7)
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        view.isHidden = true
        return view
    }()
    
    internal let missionCompletePanel: GameAlertView = {
        let mcp = GameAlertView()
        mcp.isHidden = true
        mcp.layer.cornerRadius = 24
        mcp.bodyTextLabel.text = "KiKi really appreciate for your help. Now, it’s time to move into next chapter. Are you ready?"
        mcp.isHidden = true
        return mcp
    }()
    
    // MARK: - Lifecycles
    
    public override func loadView() {
        backgroundView.addSubview(titleLabel)
        backgroundView.addSubview(missionNumberLabel)
        backgroundView.addSubview(gameArea)
        
        backgroundView.addSubview(helpPanel)
        backgroundView.addSubview(helpLabel)
        backgroundView.addSubview(helpButton)
        backgroundView.addSubview(skipButton)
        backgroundView.addSubview(backToStoryButton)
        
        backgroundView.addSubview(overlayView)
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        overlayView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor).isActive = true
        overlayView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor).isActive = true
        overlayView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        overlayView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        missionCompletePanel.nextButton.addTarget(self, action: #selector(handleNextMissionButtonTap), for: .touchUpInside)
        
        backgroundView.addSubview(missionCompletePanel)
        missionCompletePanel.translatesAutoresizingMaskIntoConstraints = false
        missionCompletePanel.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor).isActive = true
        missionCompletePanel.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor).isActive = true
        missionCompletePanel.widthAnchor.constraint(equalToConstant: 353).isActive = true
        missionCompletePanel.heightAnchor.constraint(equalToConstant: 238).isActive = true
        
        setupGame(inside: gameArea)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.openHelpPanelAnimation()
        }
        
        self.view = backgroundView
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        if SongManager.shared.introSong.isPlaying {
            // Stop the intro song
            SongManager.shared.introSong.stop()
        }
        setupViewData()
    }
    
    // MARK: - Mission Methods
    
    public func setupViewData() {
        // Should be overrided by sub-classes
    }
    
    public func setupGame(inside gameArea: UIView) {
        // Should be overrided by sub-classes
    }
    
    public final func showMissionCompleteDialog(customAnimation: ((AnimationManager) -> Void)?) {
        // Play success song
        SongManager.shared.successSong.play()
        
        overlayView.isHidden = false
        missionCompletePanel.isHidden = false

        let defaultAnimation = AnimationManager.shared
            .scaleUp(view: overlayView, scale: (30, 30), duration: 1.5, delay: 0.5)
            .scaleUp(view: missionCompletePanel, scale: (1, 1), duration: 1.5, delay: 0.5)

        customAnimation?(defaultAnimation)

        missionCompletePanel.layoutIfNeeded()
    }
    
    // MARK: - Private helper
    
    private func openHelpPanelAnimation() {
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.helpButton.setTitle("X", for: .normal)
            self?.helpButton.transform = CGAffineTransform(translationX: -51, y: 0)
            self?.helpButton.layer.shadowColor = UIColor.black.cgColor
            self?.helpButton.layer.shadowOpacity = 1
            self?.helpButton.layer.shadowOffset = CGSize(width: -10, height: 10)
            self?.helpButton.layer.shadowRadius = 5
        } completion: { [weak self] _ in
            guard let strongSelf = self else { return }
            UIView.animate(withDuration: 0.1) {
                strongSelf.helpPanel.alpha = 1
                strongSelf.helpPanel.transform = CGAffineTransform(scaleX: 1, y: 1)
                strongSelf.helpLabel.alpha = 1
                strongSelf.helpLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
        }
    }
    
    private func dismissHelpPanelAnimation() {
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.helpPanel.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            self?.helpPanel.alpha = 0
            self?.helpLabel.transform = CGAffineTransform(scaleX: 0, y: 0)
            self?.helpLabel.alpha = 0
        } completion: { [weak self] _ in
            guard let strongSelf = self else { return }
            UIView.animate(withDuration: 0.5) {
                strongSelf.helpButton.layer.shadowColor = nil
                strongSelf.helpButton.transform = .identity
            }
        }
    }
    
    // MARK: - Handler

    @objc private func handleHelpButtonTap() {
        SongManager.shared.helpPanelPopUpSong.play()
        if helpButton.transform == .identity {
            openHelpPanelAnimation()
            helpButton.setTitle("X", for: .normal)
        } else {
            dismissHelpPanelAnimation()
            helpButton.setTitle("?", for: .normal)
        }
    }
    
    @objc private func handleBackButtonTap() {
        delegate?.didBackToStoryTap()
    }
    
    @objc private func handleSkipButtonTap() {
        delegate?.onMissionCompleteOrSkip(isCompleted: false)
    }
    
    @objc private func handleNextMissionButtonTap() {
        // Reset the animation
        AnimationManager.shared
            .fadeOutAndScaleDown(view: overlayView, scale: (0.1, 0.1), duration: 1)
            .fadeOutAndScaleDown(view: missionCompletePanel, scale: (1, 1)) { [weak self] _ in
                self?.delegate?.onMissionCompleteOrSkip(isCompleted: true)
            }
    }
}
