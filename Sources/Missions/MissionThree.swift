import UIKit

public class MissionThree: BaseMission, MissionDelegate {
        
    // MARK: - Properties
    
    private var keyOriginalCenter: CGPoint?
    
    // MARK: - Views
    
    private let boxOneImageView: UIImageView = UIImageView(image: UIImage(named: "box_one_locked"))
    private let boxTwoImageView: UIImageView = UIImageView(image: UIImage(named: "box_two_locked"))
    private let boxThreeImageView: UIImageView = UIImageView(image: UIImage(named: "box_three_locked"))
    private let panImageView: UIImageView = UIImageView(image: UIImage(named: "pan"))
    
    private let panLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "Calistoga-Regular", size: 16)
        lbl.textColor = .gameYellow
        lbl.text = "Pan"
        return lbl
    }()

    private let stickLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "Calistoga-Regular", size: 16)
        lbl.textColor = .gameYellow
        lbl.text = "Stick"
        return lbl
    }()

    private let questionMarkLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "Calistoga-Regular", size: 80)
        lbl.textColor = .gameAccent
        lbl.text = "?"
        return lbl
    }()
    
    private let panBangingImageView: UIImageView = {
        let iv = UIImageView(image: UIImage.gifImageWithName("pot_and_stick"))
        return iv
    }()
    
    private let stickImageView: UIImageView = UIImageView(image: UIImage(named: "stick"))
    
    // MARK: - Override Methods
    
    public override func setupViewData() {
        delegate = self
        missionNumberLabel.text = "Mission 3"
        titleLabel.text = "Find KiKi’s pan"
        
        let helpAttrString = NSMutableAttributedString(string: "Ape, KiKi’s programmer friend, said that he saw KiKi put it inside the 1st box. Tap one of three boxes to unlock.")
        
        let hintAttr: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.foregroundColor : UIColor.gameBluePrimary,
            NSAttributedString.Key.font : UIFont(name: "Calistoga-Regular", size: 12)!,
            NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue
        ]
        
        helpAttrString.append(NSAttributedString(string: "\nHint: Try to count like a programmer.", attributes: hintAttr))
        helpLabel.attributedText = helpAttrString
        
        missionCompletePanel.headerLabel.text = "Congratulations"
        missionCompletePanel.bodyTextLabel.text = "You've completed all the missions 🎉. Please pray for KiKi and the whole people of Myanmar 🇲🇲 suffering from dictatorship 🥺. Hope you like the story."
        missionCompletePanel.nextButton.setTitle("OK", for: .normal)
        
        skipButton.isUserInteractionEnabled = false
        skipButton.alpha = 0.5
        
        SongManager.shared.missionThreeSong.play()
        SongManager.shared.missionThreeSong.numberOfLoops = -1
                
        if !questionMarkLabel.isHidden {
            // Game is not finished yet
            animateBoxes()
            animatePanPlaceholderLabel()
        } else {
            // Game has finished already
            SongManager.shared.panBangingSong.play()
        }
    }
    
    public override func setupGame(inside gameArea: UIView) {
        gameArea.backgroundColor = .clear
        
        layoutBoxes(in: gameArea)
        [boxOneImageView, boxTwoImageView, boxThreeImageView].forEach {
            $0.isUserInteractionEnabled = true
            $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleBoxTap(_:))))
        }

        layoutPanPlaceholderAndStick(in: gameArea)
        layoutPan(in: gameArea)
        layoutGif(in: gameArea)
    }
    
    // MARK: - Mission Delegate
    
    public func didBackToStoryTap() {
        PageTransitionManager.back(from: self)
        SongManager.shared.missionThreeSong.stop()
        if SongManager.shared.panBangingSong.isPlaying {
            SongManager.shared.panBangingSong.stop()
        }
    }
    
    public func onMissionCompleteOrSkip(isCompleted: Bool) {
        
    }
    
    // MARK: - Private Helpers
    
    private func layoutBoxes(in gameArea: UIView) {
        let sv = UIStackView(arrangedSubviews: [boxOneImageView, boxTwoImageView, boxThreeImageView])
        sv.distribution = .equalSpacing
        
        gameArea.addSubview(sv)
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.leadingAnchor.constraint(equalTo: gameArea.leadingAnchor, constant: 46).isActive = true
        sv.trailingAnchor.constraint(equalTo: gameArea.trailingAnchor, constant: -56).isActive = true
        sv.bottomAnchor.constraint(equalTo: gameArea.bottomAnchor, constant: -56).isActive = true
    }
    
    private func layoutPanPlaceholderAndStick(in gameArea: UIView) {

        let placeholderWithLabelSV = UIStackView(arrangedSubviews: [questionMarkLabel, panLabel])
        placeholderWithLabelSV.axis = .vertical
        placeholderWithLabelSV.spacing = 20
        placeholderWithLabelSV.alignment = .center
        
        let stickWithLabelSV = UIStackView(arrangedSubviews: [stickImageView, stickLabel])
        stickWithLabelSV.axis = .vertical
        stickWithLabelSV.spacing = 8
        stickWithLabelSV.alignment = .center
        
        let finalSV = UIStackView(arrangedSubviews: [placeholderWithLabelSV, stickWithLabelSV])
        finalSV.spacing = 80
        
        gameArea.addSubview(finalSV)
        finalSV.translatesAutoresizingMaskIntoConstraints = false
        finalSV.centerXAnchor.constraint(equalTo: gameArea.centerXAnchor).isActive = true
        finalSV.topAnchor.constraint(equalTo: gameArea.topAnchor, constant: 24).isActive = true
    }
    
    private func layoutPan(in gameArea: UIView) {
        gameArea.addSubview(panImageView)
        panImageView.translatesAutoresizingMaskIntoConstraints = false
        panImageView.centerXAnchor.constraint(equalTo: questionMarkLabel.centerXAnchor).isActive = true
        panImageView.centerYAnchor.constraint(equalTo: questionMarkLabel.centerYAnchor).isActive = true
        panImageView.transform = CGAffineTransform(scaleX: 0, y: 0)
    }
    
    private func layoutGif(in gameArea: UIView) {
        gameArea.addSubview(panBangingImageView)
        panBangingImageView.translatesAutoresizingMaskIntoConstraints = false
        panBangingImageView.centerXAnchor.constraint(equalTo: gameArea.centerXAnchor).isActive = true
        panBangingImageView.topAnchor.constraint(equalTo: gameArea.topAnchor, constant: 0).isActive = true
        panBangingImageView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        panBangingImageView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        panBangingImageView.transform = CGAffineTransform(scaleX: 0, y: 0)
    }
    
    private func animatePanPlaceholderLabel() {
        UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: [ .curveEaseInOut, .repeat, .autoreverse]) {
            self.questionMarkLabel.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            self.questionMarkLabel.alpha = 0.5
        } completion: { _ in
            self.questionMarkLabel.transform = .identity
            self.questionMarkLabel.alpha = 1
        }
    }
    
    private func animateBoxes() {
        let overallDuration: TimeInterval = 3
        
        UIView.animateKeyframes(withDuration: overallDuration, delay: 0, options: [.calculationModeCubic, .repeat, .allowUserInteraction], animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1) {
                self.boxOneImageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                self.boxThreeImageView.transform = .identity
            }
            
            UIView.addKeyframe(withRelativeStartTime: 1/overallDuration, relativeDuration: 1) {
                self.boxOneImageView.transform = .identity
                self.boxTwoImageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }
            
            UIView.addKeyframe(withRelativeStartTime: 2/overallDuration, relativeDuration: 1) {
                self.boxTwoImageView.transform = .identity
                self.boxThreeImageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }
            
        }, completion: nil)
    }
    
    private func removeBoxAnimations() {
        [boxOneImageView, boxTwoImageView, boxThreeImageView].forEach { $0.layer.removeAllAnimations() }
    }
    
    private func resetBoxScales() {
        UIView.animate(withDuration: 0.5) {
            [self.boxOneImageView, self.boxTwoImageView, self.boxThreeImageView].forEach { $0.transform = .identity }
        }
    }
    
    private func incorrectBoxUnlockAnimation(_ box: UIImageView, to image: UIImage?) {
        let originalImage = box.image
        box.image = image
        
        let glowLightIV = UIImageView(image: UIImage(named: "box_glow_light"))
        gameArea.insertSubview(glowLightIV, at: 0)
        glowLightIV.translatesAutoresizingMaskIntoConstraints = false
        glowLightIV.leadingAnchor.constraint(equalTo: box.leadingAnchor).isActive = true
        glowLightIV.bottomAnchor.constraint(equalTo: box.bottomAnchor).isActive = true

        glowLightIV.alpha = 0
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn) {
            box.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            glowLightIV.alpha = 1
        } completion: { _ in
            UIView.animate(withDuration: 0.5, delay: 2, options: .curveEaseIn) {
                box.transform = .identity
                glowLightIV.alpha = 0
            } completion: { _ in
                SongManager.shared.removeFromBoardSong.play()
                box.image = originalImage
                glowLightIV.removeFromSuperview()
                self.animateBoxes()
            }
        }
    }
    
    private func correctBoxUnlockAnimation(_ box: UIImageView, to image: UIImage?) {
        UIView.animate(withDuration: 2, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseInOut) {
            box.image = image
            box.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            box.center = CGPoint(x: box.center.x, y: box.center.y - 30)
            self.boxOneImageView.alpha = 0
            self.boxThreeImageView.alpha = 0
        } completion: { _ in
            self.showPanAnimation()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.showMissionCompleteDialog(customAnimation: nil)
            }
        }

    }
    
    private func showPanAnimation() {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseInOut) {
            self.panImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.questionMarkLabel.alpha = 0
        } completion: { _ in
            UIView.animate(withDuration: 0.5) {
                self.panImageView.transform = CGAffineTransform(translationX: 40, y: 0)
                self.stickImageView.transform = CGAffineTransform(translationX: -40, y: 0)
                self.panLabel.alpha = 0
                self.stickLabel.alpha = 0
            } completion: { _ in
                SongManager.shared.panBangingSong.play()
                SongManager.shared.panBangingSong.numberOfLoops = -1
                UIView.animate(withDuration: 0.5) {
                    [self.panImageView, self.stickImageView].forEach {
                        $0.transform = CGAffineTransform(scaleX: 0, y: 0)
                        $0.alpha = 0
                    }
                    self.panBangingImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
                } completion: { _ in
                    self.questionMarkLabel.layer.removeAllAnimations()
                    self.questionMarkLabel.isHidden = true
                }

            }
        }
    }
    
    private func unlockAndAnimate(to box: UIImageView) {
        switch box.image {
        case UIImage(named: "box_one_locked"):
            incorrectBoxUnlockAnimation(box, to: UIImage(named: "box_one_unlocked"))
        case UIImage(named: "box_two_locked"):
            correctBoxUnlockAnimation(box, to: UIImage(named: "box_two_unlocked"))
        default:
            incorrectBoxUnlockAnimation(box, to: UIImage(named: "box_three_unlocked"))
        }
    }
    
    // MARK: - Handler
    
    @objc private func handleBoxTap(_ sender: UITapGestureRecognizer) {
        SongManager.shared.boxOpenSong.play()
        guard let tappedBox = sender.view as? UIImageView else { return }
        
        removeBoxAnimations()
        resetBoxScales()
        
        unlockAndAnimate(to: tappedBox)
    }
}
