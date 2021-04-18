import UIKit

public class MissionOne: BaseMission, MissionDelegate {

    // MARK: - Properties
    
    let correctAnsArr: [UIImage?] = [UIImage(named: "m1_pic_1"), UIImage(named: "m1_pic_2"), UIImage(named: "m1_pic_3"), UIImage(named: "m1_pic_4")]
    
    var questionArr: [UIImage?] = [UIImage(named: "m1_pic_3"), UIImage(named: "m1_pic_1"), UIImage(named: "m1_pic_4"), UIImage(named: "m1_pic_2")]
    
    var wrongAnsArr: [UIImage?] = []
    
    var firstIndexPath: IndexPath?
    var secondIndexPath: IndexPath?
    
    let cellRegistration = UICollectionView.CellRegistration<MissionOneCell, UIImage> { cell, indexPath, item in
        cell.image = item
    }
    
    // MARK: - Views
    
    private let collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.allowsMultipleSelection = true
        cv.backgroundColor = .clear
        return cv
    }()
    
    private lazy var restartButton: UIButton = {
        let btn = UIButton()
        btn.setBackgroundImage(UIImage(named: "restart_button"), for: .normal)
        btn.addTarget(self, action: #selector(handleRestart), for: .touchUpInside)
        return btn
    }()
    
    private lazy var swapButton: UIButton = {
        let btn = UIButton()
        btn.setBackgroundImage(UIImage(named: "swap_button"), for: .normal)
        btn.addTarget(self, action: #selector(handleSwap), for: .touchUpInside)
        return btn
    }()
    
    // MARK: - Lifecycles
    
    public override func viewDidLoad() {
        wrongAnsArr = questionArr
    }
    
    public override func setupViewData() {
        delegate = self
        titleLabel.text = "Repair the torn up pieces"
        missionNumberLabel.text = "Mission I"
        helpLabel.text = "Put the pieces together. Select two pieces of letter and tap swap so that you can rearrange them in the correct order. It’s a good idea to restart if you’re confused."
        
        // Play the song
        SongManager.shared.missionOneSong.play()
        SongManager.shared.missionOneSong.numberOfLoops = -1
    }
    
    public override func setupGame(inside gameArea: UIView) {
        gameArea.backgroundColor = .clear
        gameArea.isUserInteractionEnabled = true
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        gameArea.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leadingAnchor.constraint(equalTo: gameArea.leadingAnchor, constant: 33).isActive = true
        collectionView.topAnchor.constraint(equalTo: gameArea.topAnchor, constant: 25).isActive = true
        collectionView.widthAnchor.constraint(equalToConstant: 372).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        let restartSV = createGameButtonStackView(text: "Restart", button: restartButton)
        let swapSV = createGameButtonStackView(text: "Swap", button: swapButton)
        
        let gameControlsSV = UIStackView(arrangedSubviews: [swapSV, restartSV])
        gameControlsSV.spacing = 28
        
        gameArea.addSubview(gameControlsSV)
        gameControlsSV.translatesAutoresizingMaskIntoConstraints = false
        gameControlsSV.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 15).isActive = true
        gameControlsSV.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor).isActive = true
    }
    
    // MARK: - Mission Delegate
    
    public func didBackToStoryTap() {
        PageTransitionManager.back(from: self)
        // Stop the mission one song
        SongManager.shared.missionOneSong.stop()
    }
    
    public func onMissionCompleteOrSkip(isCompleted: Bool) {
        if isCompleted {
            // Reset the animation
            collectionView.transform = .identity
        }
        PageTransitionManager.navigate(to: ChapterTwo(), from: self)

        // Stop the song
        SongManager.shared.missionOneSong.stop()
    }

    
    // MARK: - Handler
    
    @objc func handleSwap() {
        guard let start = firstIndexPath, let end = secondIndexPath else { return }
        
        SongManager.shared.paperPiecesSwapSong.play()
        
        collectionView.performBatchUpdates({
            collectionView.moveItem(at: start, to: end)
            collectionView.moveItem(at: end, to: start)
        }) { [weak self] (finished) in
            self?.updateDatasourceOnSwap(start: start, end: end)
           
            if self?.wrongAnsArr == self?.correctAnsArr {
                self?.showMissionCompleteDialog { animation in
                    animation.scaleUp(view: self!.collectionView, scale: (1.1, 1.1), duration: 1)
                }
            }
        }
    }
    
    @objc func handleRestart() {
        wrongAnsArr = questionArr
        firstIndexPath = nil
        secondIndexPath = nil
        collectionView.reloadData()
    }
    
    // MARK: - Private Helper
    
    private func createGameButtonStackView(text: String, button: UIButton) -> UIStackView {
        let label = UILabel()
        label.text = text
        label.font = UIFont(name: "Calistoga-Regular", size: 14)
        label.textColor = .gameYellow
        let sv = UIStackView(arrangedSubviews: [button, label])
        sv.axis = .vertical
        sv.spacing = 8
        sv.alignment = .center
        return sv
    }
    
    private func updateDatasourceOnSwap(start: IndexPath, end: IndexPath) {
        // update data source here
        collectionView.deselectItem(at: start, animated: true)
        collectionView.deselectItem(at: end, animated: true)
        firstIndexPath = nil
        secondIndexPath = nil
        wrongAnsArr.swapAt(start.item, end.item)
    }
    
}

extension MissionOne: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // MARK: - CollectionView Datasource & Delegate
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return wrongAnsArr.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: wrongAnsArr[indexPath.row])
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 2, height: collectionView.frame.height / 2)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        if firstIndexPath == nil {
            firstIndexPath = indexPath
            collectionView.selectItem(at: firstIndexPath, animated: true, scrollPosition: UICollectionView.ScrollPosition(rawValue: 0))
        } else if secondIndexPath == nil {
            secondIndexPath = indexPath
            collectionView.selectItem(at: secondIndexPath, animated: true, scrollPosition: UICollectionView.ScrollPosition(rawValue: 0))
        } else {
            collectionView.deselectItem(at: secondIndexPath!, animated: true)
            secondIndexPath = indexPath
            collectionView.selectItem(at: secondIndexPath, animated: true, scrollPosition: UICollectionView.ScrollPosition(rawValue: 0))
        }
    }
}


public class MissionOneCell: UICollectionViewCell {
    
    var image: UIImage? {
        didSet {
            guard let data = image else { return }
            imageView.image = data
        }
    }
    
    public override var isSelected: Bool {
        didSet {
            border.isHidden = !isSelected
        }
    }
    
    let border: UIView = {
        let border = UIView()
        border.backgroundColor = UIColor.clear
        border.layer.borderColor = UIColor.gameBluePrimary.cgColor
        border.layer.borderWidth  = 5
        border.isHidden = true
        return border
    }()
    
    private let imageView: UIImageView = UIImageView()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageView)
        imageView.frame = bounds
        
        addSubview(border)
        border.frame = bounds
    }
    
    public required init?(coder: NSCoder) {
        fatalError()
    }
}
