import UIKit

public class MissionTwo: BaseMission, MissionDelegate {
    
    // MARK: - Properties
    
    private var gameItems: [(UIImage?, String)] = [
        (UIImage(named: "water"), "Water"),
        (UIImage(named: "flash_light"), "Flash Light"),
        (UIImage(named: "medicine"), "Medicine"),
        (UIImage(named: "iphone"), "iPhone"),
        (UIImage(named: "map"), "Map"),
        (UIImage(named: "document"), "Documents"),
        (UIImage(named: "cloth"), "Clothes"),
        (UIImage(named: "rope"), "Rope"),
        (UIImage(named: "measuring_tape"), "Measuring Tape")
    ]
    
    private var gameItemViews: [UIStackView] = [UIStackView]()
    
    private var gameItemOriginalCenterPoint: CGPoint = .zero

    private var pickedItems: [UIImage] = [UIImage]()
    
    private let cellRegistration = UICollectionView.CellRegistration<MissionTwoCell, UIImage> { cell, indexPath, item in
        cell.image = item
    }
    
    var selectedIndexPath: IndexPath?
    
    // MARK: - Views
    
    private let capacityBarView = BagCapacityBarView()
    
    private let capacityLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Capacity"
        lbl.font = UIFont(name: "Calistoga-Regular", size: 12)
        lbl.textColor = .gameYellow
        return lbl
    }()
    
    private let backpackImageView: UIImageView = UIImageView(image: UIImage(named: "backpack"))
    
    private let choosenItemBoardBg: UIImageView = UIImageView(image: UIImage(named: "board_one"))
    
    private let choosenItemBoardHeaderBg: UIImageView = UIImageView(image: UIImage(named: "board_one_header"))
    
    private let itemsBoardBg: UIImageView = UIImageView(image: UIImage(named: "board_two"))
    
    private let choosenItemCountLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "0/6"
        lbl.font = UIFont(name: "Calistoga-Regular", size: 14)
        lbl.textColor = .gameWoodenText
        return lbl
    }()
    
    private let dropButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "delete_button"), for: .normal)
        return button
    }()
    
    private lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.backgroundColor = .clear
        cv.delegate = self
        cv.dataSource = self
        
        return cv
    }()
    
    private lazy var removeButton: UIButton = {
        let btn = UIButton()
        btn.setBackgroundImage(UIImage(named: "remove_button"), for: .normal)
        btn.addTarget(self, action: #selector(handleDropTap), for: .touchUpInside)
        return btn
    }()
    
    // MARK: - Mission Methods
    
    public override func setupViewData() {
        delegate = self
        
        titleLabel.text = "Prepare an emergency backpack"
        missionNumberLabel.text = "Mission II"
        
        let helpAttrString = NSMutableAttributedString(string: "Drag and drop the given items to the backpack. As the bag has its limit, you should make a wise pick.")
        
        let hintAttr: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.foregroundColor : UIColor.gameBluePrimary,
            NSAttributedString.Key.font : UIFont(name: "Calistoga-Regular", size: 12)!,
            NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue
        ]
        
        helpAttrString.append(NSAttributedString(string: "\nHint: Some item could have more than one use case.", attributes: hintAttr))
        helpLabel.attributedText = helpAttrString
        SongManager.shared.missionTwoSong.play()
        SongManager.shared.missionTwoSong.numberOfLoops = -1
    }
    
    public override func setupGame(inside gameArea: UIView) {
        
        gameArea.backgroundColor = .clear
        
        layoutCapacityBarAndBackpackAndBoard(in: gameArea)
        
        layoutItemBoard(in: gameArea)
        
        setupItemsBoard(in: gameArea)
                
        layoutCollectionView(in: gameArea)
        layoutDropButton(in: gameArea)
    }
        
    // MARK: - Private helpers
    
    private func layoutCapacityBarAndBackpackAndBoard(in gameArea: UIView) {
        capacityBarView.translatesAutoresizingMaskIntoConstraints = false
        capacityBarView.layer.cornerRadius = 6
        capacityBarView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        capacityBarView.heightAnchor.constraint(equalToConstant: 126).isActive = true
        
        let capacitySV = UIStackView(arrangedSubviews: [capacityBarView, capacityLabel])
        capacitySV.axis = .vertical
        capacitySV.spacing = 12
        capacitySV.alignment = .center
        
        gameArea.addSubview(capacitySV)
        capacitySV.translatesAutoresizingMaskIntoConstraints = false
        capacitySV.leadingAnchor.constraint(equalTo: gameArea.leadingAnchor, constant: 31).isActive = true
        capacitySV.topAnchor.constraint(equalTo: gameArea.topAnchor, constant: 36).isActive = true
        
        gameArea.addSubview(backpackImageView)
        backpackImageView.translatesAutoresizingMaskIntoConstraints = false
        backpackImageView.centerYAnchor.constraint(equalTo: capacitySV.centerYAnchor).isActive = true
        backpackImageView.centerXAnchor.constraint(equalTo: gameArea.centerXAnchor, constant: -60).isActive = true
        
        gameArea.addSubview(choosenItemBoardBg)
        choosenItemBoardBg.translatesAutoresizingMaskIntoConstraints = false
        choosenItemBoardBg.topAnchor.constraint(equalTo: gameArea.topAnchor, constant: 36).isActive = true
        choosenItemBoardBg.trailingAnchor.constraint(equalTo: gameArea.trailingAnchor, constant: -30).isActive = true
        
        gameArea.addSubview(choosenItemBoardHeaderBg)
        choosenItemBoardHeaderBg.translatesAutoresizingMaskIntoConstraints = false
        choosenItemBoardHeaderBg.topAnchor.constraint(equalTo: gameArea.topAnchor, constant: 27).isActive = true
        choosenItemBoardHeaderBg.centerXAnchor.constraint(equalTo: choosenItemBoardBg.centerXAnchor).isActive = true
        
        gameArea.addSubview(choosenItemCountLabel)
        choosenItemCountLabel.translatesAutoresizingMaskIntoConstraints = false
        choosenItemCountLabel.centerXAnchor.constraint(equalTo: choosenItemBoardHeaderBg.centerXAnchor).isActive = true
        choosenItemCountLabel.centerYAnchor.constraint(equalTo: choosenItemBoardHeaderBg.centerYAnchor, constant: -4).isActive = true
        
        gameArea.addSubview(dropButton)
        dropButton.translatesAutoresizingMaskIntoConstraints = false
        dropButton.trailingAnchor.constraint(equalTo: choosenItemBoardBg.trailingAnchor, constant: -12).isActive = true
        dropButton.bottomAnchor.constraint(equalTo: choosenItemBoardBg.bottomAnchor, constant: -12).isActive = true
    }

    private func createGameItem(image: UIImage?, name: String) -> UIStackView {
        let iv = UIImageView(image: image)
        iv.contentMode = .scaleAspectFit
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleItemPan(sender:))))

        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.widthAnchor.constraint(equalToConstant: 44).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 44).isActive = true

        let label = UILabel()
        label.text = name
        label.font = UIFont(name: "Calistoga-Regular", size: 12)
        label.textColor = .gameWoodenText
        
        let sv = UIStackView(arrangedSubviews: [iv, label])
        sv.axis = .vertical
        sv.spacing = 4
        sv.alignment = .center
        
        return sv
    }
    
    private func layoutCollectionView(in gameArea: UIView) {
        gameArea.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leadingAnchor.constraint(equalTo: choosenItemBoardBg.leadingAnchor, constant: 12).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: choosenItemBoardBg.trailingAnchor, constant: -12).isActive = true
        collectionView.topAnchor.constraint(equalTo: choosenItemBoardBg.topAnchor, constant: 20).isActive = true
    }
    
    private func layoutDropButton(in gameArea: UIView) {
        gameArea.addSubview(removeButton)
        removeButton.translatesAutoresizingMaskIntoConstraints = false
        removeButton.bottomAnchor.constraint(equalTo: choosenItemBoardBg.bottomAnchor, constant: -12).isActive = true
        removeButton.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor).isActive = true
        removeButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 12).isActive = true
    }
    
    private func layoutItemBoard(in gameArea: UIView) {
        gameArea.addSubview(itemsBoardBg)
        itemsBoardBg.translatesAutoresizingMaskIntoConstraints = false
        itemsBoardBg.centerXAnchor.constraint(equalTo: gameArea.centerXAnchor).isActive = true
        itemsBoardBg.bottomAnchor.constraint(equalTo: gameArea.bottomAnchor, constant: -20).isActive = true
    }

    private func setupItemsBoard(in gameArea: UIView) {
        gameItemViews = gameItems.map { createGameItem(image: $0.0, name: $0.1) }
        
        var firstRowGameItems: [UIStackView] = [UIStackView]()
        var secondRowGameItems: [UIStackView] = [UIStackView]()
        
        gameItemViews.forEach { item in
            if (firstRowGameItems.count + 1) <= 5 {
                firstRowGameItems.append(item)
            } else {
                secondRowGameItems.append(item)
            }
        }
        
        let firstRowSV = UIStackView(arrangedSubviews: firstRowGameItems)
        firstRowSV.distribution = .equalSpacing
        
        let secondRowSV = UIStackView(arrangedSubviews: secondRowGameItems)
        secondRowSV.distribution = .equalSpacing
        
        let finalSV = UIStackView(arrangedSubviews: [firstRowSV, UIView(), secondRowSV])
        finalSV.axis = .vertical
        finalSV.spacing = 8
        
        gameArea.addSubview(finalSV)
        finalSV.translatesAutoresizingMaskIntoConstraints = false
        finalSV.leadingAnchor.constraint(equalTo: itemsBoardBg.leadingAnchor, constant: 40).isActive = true
        finalSV.trailingAnchor.constraint(equalTo: itemsBoardBg.trailingAnchor, constant: -40).isActive = true
        finalSV.topAnchor.constraint(equalTo: itemsBoardBg.topAnchor, constant: 38).isActive = true
        finalSV.bottomAnchor.constraint(equalTo: itemsBoardBg.bottomAnchor, constant: -24).isActive = true
    }
    
    private func animateGameItemOnPanBegin(_ itemView: UIImageView) {
        gameItemOriginalCenterPoint = itemView.center
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            itemView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }, completion: nil)
    }
    
    private func moveGameItemOnPanChange(in location: CGPoint, itemPoint point: CGPoint, sender: UIPanGestureRecognizer) {
        guard let itemView = sender.view as? UIImageView else { return }
        
        let translation = sender.translation(in: gameArea)
        
        itemView.center = CGPoint(x: itemView.center.x + translation.x, y: itemView.center.y + translation.y)
        
        // Reset the translation value
        sender.setTranslation(.zero, in: self.view)
        
        // Check if item intersect the backpack
        if backpackImageView.frame.contains(point) {
            // Scale backpack up
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseInOut, animations: { [weak self] in
                self?.backpackImageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }, completion: nil)
        } else {
            // Scale backpack to identity
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseInOut, animations: { [weak self] in
                self?.backpackImageView.transform = .identity
            }, completion: nil)
        }
    }
        
    private func onGameItemStopPan(_ itemView: UIImageView, point: CGPoint) {
        if backpackImageView.frame.contains(point) {
            addItemToBag(itemView)
        } else {
            // Reset item view animation
            UIView.animate(withDuration: 0.7, delay: 0.1, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                itemView.center = self.gameItemOriginalCenterPoint
                itemView.transform = .identity
            }, completion: nil)
        }
        
        // Reset backpack animation
        UIView.animate(withDuration: 0.7, delay: 0.1, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.backpackImageView.transform = .identity
        }, completion: nil)
                
    }
    
    private func addItemToBag(_ itemView: UIImageView) {
        SongManager.shared.addToBackpackSong.play()
        // start add animation
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut) {
            itemView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            itemView.alpha = 0
        } completion: { [weak self] (_) in
            // Perform actual adding process
            guard let strongSelf = self else { return }
            
            // Move item to it's original position
            itemView.center = strongSelf.gameItemOriginalCenterPoint
            
            // Add to collectin view
            strongSelf.pickedItems.append(itemView.image!)
            strongSelf.collectionView.reloadData()
            strongSelf.choosenItemCountLabel.text = "\(strongSelf.pickedItems.count)/6"
            
            // Increase one unit to capacity bar
            strongSelf.capacityBarView.value += 1
            
            if strongSelf.pickedItems.count == 6 {
                strongSelf.decideGameWinOrLose()
            }
        }
    }

    private func decideGameWinOrLose() {
        if pickedItems.contains(UIImage(named: "flash_light")!) || pickedItems.contains(UIImage(named: "map")!) || pickedItems.contains(UIImage(named: "measuring_tape")!) {
            missionCompletePanel.headerLabel.text = "Mission Failed!!!"
            missionCompletePanel.bodyTextLabel.text = "You could save some more space by picking something more useful. Please reconsider your choices again 😢😢😢"
            missionCompletePanel.nextButton.setTitle("OK", for: .normal)
        } else {
            missionCompletePanel.headerLabel.text = "Mission Complete"
            missionCompletePanel.bodyTextLabel.text = "KiKi really appreciate for your help. Now, it’s time to move into final chapter. Are you ready?"
            missionCompletePanel.nextButton.setTitle("Next", for: .normal)
        }
        AnimationManager.shared.scaleUp(view: backpackImageView, scale: (1.3, 1.3), duration: 1, delay: 0.3, shouldFadeIn: false) { _ in
            self.showMissionCompleteDialog(customAnimation: nil)
        }
    }
    
    // MARK: - Mission Delegate
    
    public func didBackToStoryTap() {
        PageTransitionManager.back(from: self)
        SongManager.shared.missionTwoSong.stop()
    }
    
    public func onMissionCompleteOrSkip(isCompleted: Bool) {
        SongManager.shared.missionTwoSong.stop()
        
        if isCompleted {
            // Reset the animation
            backpackImageView.transform = .identity
        }
        
        if missionCompletePanel.nextButton.titleLabel?.text == "OK" {
            AnimationManager.shared
                .fadeOutAndScaleDown(view: overlayView, scale: (0.1, 0.1), duration: 1)
                .fadeOutAndScaleDown(view: missionCompletePanel, scale: (1, 1))
            SongManager.shared.missionTwoSong.play()
        } else {
            PageTransitionManager.navigate(to: ChapterThree(), from: self)
        }
    }
    
    // MARK: - Handler
    
    @objc func handleItemPan(sender: UIPanGestureRecognizer) {
        guard let itemView = sender.view as? UIImageView else { return }

        let location = sender.location(in: self.view)
        let refinedItemPoint = CGPoint(x: location.x, y: location.y / 1.4)
        
        // Make sure backpack has enough space
        if pickedItems.count < 6 {
            switch sender.state {
            case .began:
                animateGameItemOnPanBegin(itemView)
            case .changed:
                moveGameItemOnPanChange(in: location, itemPoint: refinedItemPoint, sender: sender)
            case .ended:
                onGameItemStopPan(itemView, point: refinedItemPoint)
            default:
                break
            }
        }
        
    }
    
    @objc func handleDropTap() {
        guard let selectedIndexPath = selectedIndexPath else { return }
        
        // Remove item from the collection view
        collectionView.deleteItems(at: [selectedIndexPath])
        
        // Get the dropped game item back
        gameItemViews.forEach { sv in
            if let iv = sv.arrangedSubviews.first as? UIImageView {
                if pickedItems[selectedIndexPath.row] == iv.image {
                    UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
                        iv.alpha = 1
                        iv.transform = .identity
                    }, completion: nil)
                }
            }
        }
        
        // Remove from picked items
        pickedItems.remove(at: selectedIndexPath.row)
        
        // Play the audio
        SongManager.shared.removeFromBoardSong.play()
        
        // Decrease one unit of the capacity bar
        capacityBarView.value -= 1
        
        // Update the label
        choosenItemCountLabel.text = "\(pickedItems.count)/6"
    }
}

extension MissionTwo: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    // MARK: - CollectionView Methods
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let selected = selectedIndexPath, selected == indexPath {
            collectionView.deselectItem(at: indexPath, animated: true)
            selectedIndexPath = nil
        } else {
            selectedIndexPath = indexPath
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width / 3) - 10, height: (collectionView.frame.height / 2) - 5)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return min(6, pickedItems.count)
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: pickedItems[indexPath.row])
    }
}


